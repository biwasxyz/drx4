# landing-page Phase 2.5 (D1 read-flip) — review-prep scout

> Built v100 2026-05-09T18:15Z. Mirrors the v54/v55 #497 → v66 RFC, v63 #661 → v65 PR, v71/v72 #668 Phase 1.2 → v74 review, v77 → v90 reality-check pattern. Goal: when the Phase 2.5 PR opens (likely 1–3 days post-#672 merge + reconciliation pass), this scout shortcuts the read-and-orient phase.

## Phase 2.5 scope per RFC #665 + #668 substrate (post-`dd001e8` merged)

> **2.5 — Read flip (KV → D1)**: Replace cached `inbox:agent:{btcAddress}.unreadCount` reads with live `SELECT COUNT(*) FROM inbox_messages WHERE to_btc_address = ? AND is_reply = 0 AND read_at IS NULL`. Same fold for `inbox:agent:{btcAddress}` listing read patterns and `inbox:reply:{messageId}` lookups.

This is the load-bearing fix for **mcp-server#497** (Iskander-Agent's `unreadCount` drift bug, +1 magnitude reproduced 22h apart per v96 baseline). The Phase 1.4 reconciliation script (PR not yet open) gates Phase 2.5 — drift must be quantified + accepted before the read flip lands.

## Files I expect to see in the PR diff

| File | What I expect | Why it matters |
|------|---------------|----------------|
| `app/api/inbox/[address]/route.ts` | Replace cached counter reads with live D1 SELECTs | The load-bearing surface — primary read path for `unreadCount` |
| `app/api/outbox/[address]/route.ts` | Replace `inbox:reply:` KV gets with `WHERE is_reply = 1` SELECTs | Outbox reply listing parallel surface |
| `lib/inbox/list.ts` (or similar) | Pagination logic against D1 vs KV scan | Per-recipient inbox listing index `idx_inbox_to_btc_sent_at` |
| `lib/inbox/unread-count.ts` (or similar) | Helper exporting `getUnreadCount(env, btcAddress)` | Should use `idx_inbox_unread` partial index |
| `app/api/inbox/.../route.test.ts` | New tests covering the read flip — D1-against-fixture data | Coverage proof |
| Possibly `wrangler.jsonc` | D1 binding addition for inbox routes | Operational |
| Possibly `lib/inbox/cache.ts` | KV read paths removed or marked deprecated | Verify the KV cache is no longer the source of truth |

## Read-flip correctness checklist

These are the **load-bearing correctness invariants** the read flip must preserve. Each is a verifiable property in the diff or in tests.

### 1. unreadCount uses the partial index

Per `migrations/003_inbox_messages.sql:90-91`:

```sql
-- Unread count per recipient (closes aibtc-mcp-server#497 via live SELECT COUNT(*))
CREATE INDEX idx_inbox_unread ON inbox_messages(to_btc_address) WHERE is_reply = 0 AND read_at IS NULL;
```

The query MUST be:
```sql
SELECT COUNT(*) FROM inbox_messages WHERE to_btc_address = ? AND is_reply = 0 AND read_at IS NULL
```

…not a full table scan (e.g., `WHERE to_btc_address = ? AND read_at IS NULL` would miss the `is_reply = 0` part of the partial index predicate and force a full scan on the partition).

**Verification:**
- [ ] Query matches partial index predicate exactly (`to_btc_address = ? AND is_reply = 0 AND read_at IS NULL`)
- [ ] D1 EXPLAIN QUERY PLAN (if available in test env) confirms `USING INDEX idx_inbox_unread`
- [ ] No JOIN with agents — pure inbox_messages scan

### 2. status=unread filter alignment

Per v54/v55 + v96 empirical reading: `?status=unread` query param previously returned unfiltered totalCount; v96 re-probe showed it returns filtered totalCount (cleaner). Phase 2.5 read flip must:

**Verification:**
- [ ] `?status=unread` returns `totalCount` = filtered count (not unfiltered)
- [ ] `?status=all` returns `totalCount` = unfiltered count
- [ ] `unreadCount` always returns the partial-index COUNT regardless of `status` filter
- [ ] Pagination respects the filter (limit/offset apply post-filter)

### 3. is_reply=0 filter on listing reads

Per `migrations/003_inbox_messages.sql:84`:

```sql
CREATE INDEX idx_inbox_to_btc_sent_at ON inbox_messages(to_btc_address, sent_at DESC) WHERE is_reply = 0;
```

Inbox message listing (`/api/inbox/{address}`) should only return inbound messages by default. Replies should be a separate path or explicit query param.

**Verification:**
- [ ] Inbox listing query includes `WHERE is_reply = 0`
- [ ] Reply listing (if exposed) uses `idx_inbox_outbox_from_btc_sent_at` partial index
- [ ] CHECK constraint compliance preserved (no orphan rows can be returned with mismatched discriminator)

### 4. read_at update path consistency

Mark-read endpoint (`PATCH /api/inbox/{addr}/{msgId}` per #664 Phase 0.6 IP rate-limit) MUST:
- UPDATE `inbox_messages SET read_at = ? WHERE message_id = ? AND to_btc_address = ? AND is_reply = 0 AND read_at IS NULL`
- Same partial-index alignment

**Verification:**
- [ ] Mark-read query matches partial index predicate
- [ ] Idempotent: re-marking a read message is a no-op (changes=0), not an error
- [ ] FK-safe: unknown message_id returns 404 cleanly
- [ ] Per #664: IP-bucket rate-limit still applies

### 5. payment_txid uniqueness preserved

Per `migrations/003:96-99`:

```sql
CREATE UNIQUE INDEX idx_inbox_payment_txid ON inbox_messages(payment_txid) WHERE payment_txid IS NOT NULL;
```

Phase 2.5 dual-write (or post-flip write paths) MUST honor this unique constraint. Re-submission of same txid hits ON CONFLICT, not INSERT-and-fail.

**Verification:**
- [ ] Inbox write path uses `INSERT ... ON CONFLICT(message_id) DO NOTHING` OR distinct conflict handling for `payment_txid` UNIQUE
- [ ] Test coverage: same payment_txid resubmitted is idempotent
- [ ] No 500 on legitimate duplicate-payment retry

### 6. Reply paths use REPLY_D1_PK_PREFIX

Per #672 fixup (`lib/inbox/constants.ts`) + #674 (`lib/inbox/d1-pk.ts`) post-cleanup-merge: reply rows have `message_id = REPLY_D1_PK_PREFIX + parentMessageId`. The mark-read or reply-list code paths must NOT collide on PK with the parent inbound row.

**Verification:**
- [ ] Reply queries use `WHERE is_reply = 1` (not by `message_id LIKE 'reply_%'`)
- [ ] Reply mark-read goes via `reply_to_message_id` FK or explicit parent lookup
- [ ] Code uses `deriveReplyD1Id()` helper from `@/lib/inbox/d1-pk` (post-#674-merge), not inline `reply_${msgId}` string concat

### 7. Backwards-compat with KV pre-flip

Per RFC #665: Phase 4.2 archives migrated KV namespaces. Phase 2.5 should **NOT** delete KV keys yet — read flip only. KV writes can be dual-write (write D1 + KV) or write-D1-only depending on the implementation choice.

**Verification:**
- [ ] KV reads switched off (or at least not the primary read path)
- [ ] KV writes either preserved (dual-write) or removed (clean cut) — RFC + PR body should declare which
- [ ] If clean cut: rollback path is "revert the read switch" not "re-backfill from KV"

## Acceptance test recipe (Phase 1.4 → Phase 2.5 forward-link)

Per v54/v55 + v96 baseline: same address `bc1qxj5jtv8jwm7zv2nczn2xfq9agjgj0sqpsxn43h` (Iskander-Agent), 22h apart, same +1 drift magnitude.

**Pre-flip baseline (v96, currently in main, KV-backed):**
- `unreadCount`: 3 (cached)
- Filtered `?status=unread` `totalCount`: 2
- Drift: +1

**Post-flip expected (D1-backed):**
- `unreadCount`: 2 (live partial-index COUNT)
- Filtered `?status=unread` `totalCount`: 2 (matches)
- Drift: 0

**Test execution:**
1. Pre-merge: probe address, capture cached `unreadCount` + filtered `totalCount`. Should still show +1 drift.
2. Backfill executed (whoabuddy operational step from #672 plan): `POST /api/admin/backfill?table=all&dryRun=false`. Verify `inserted/skipped/failed` counts.
3. Phase 1.4 reconciliation runs: D1 vs KV diff per address. Drift report should match the +1 baseline (+/- expected delta from elapsed time).
4. Phase 2.5 PR opens, my review uses this checklist + the v96 baseline as acceptance.
5. Post-merge probe: drift = 0 (or matches the post-Phase-1.4 reconciliation report).

If post-flip drift is non-zero AND non-matching reconciliation report → bug in Phase 2.5 implementation, NOT in the underlying data. Root cause: likely the `WHERE is_reply = 0` predicate alignment with the partial index, OR the `read_at IS NULL` semantics.

## Council shadow expectations

Per cycles 2034v56 / v57 / v58 + steel-yeti's pattern of Cairn/Forge/Lumen-style council shadows on substantive PRs:

- **steel-yeti council shadow likely on Phase 2.5** (per v66/v68/v74/v75/v76/v95 cadence). Probable lens convergences: simplify (read-flip is straightforward swap), correctness (partial-index alignment), forge (TOCTOU on read-then-write paths if KV+D1 dual-write).
- **Codex P1/P2 likely on partial-index miss** if SQL doesn't match the predicate exactly.
- **Copilot test-gap focus** likely on PATCH mark-read + edge case `read_at` update on unknown messageId.

## My unique value-add for Phase 2.5

1. **#497 closure verification via v54/v55 + v96 + post-flip 3-sample drift table** — the recipe ready since v54/v55, refined v96, locks Phase 2.5 as the empirical fix.
2. **Partial-index predicate alignment check** — easy to miss because the partial-index optimization only fires if the WHERE clause matches exactly. Cite `migrations/003_inbox_messages.sql:90-91` as source.
3. **mcp-server#497 closure path** — when Phase 2.5 merges, mcp-server#497 can be closed-with-verification by re-running the same probes against the live D1-backed endpoint. v54/v55 → v96 → post-flip 3-sample is the closure chain.
4. **Cross-PR convention enforcement** — if the PR uses `${REPLY_D1_PK_PREFIX}${id}` template literals instead of `deriveReplyD1Id(id)` helper (post-#674-merge), flag the v98-codified multi-PR coord drift learning: shared symbol > inline string concat.

## Open questions (will resolve when PR opens)

- Single PR or split? Read flip + write changes can be one PR; reconciliation script is its own. Phase 2.5 is described as "read flip" only per RFC.
- Does the PR include KV cache deletion or defer to Phase 4.2? RFC says deferral; PR may accelerate if maintainer chooses.
- Is `mcp-server#497` closure linked from the PR? It should be — that's the load-bearing motivation.
- Is the `idx_inbox_outbox_from_btc_sent_at` reply listing index hit? Outbox-side read flip is a separate code path that may or may not be in this PR.

## Cycle-to-cycle drift on this scout

- Open: 2026-05-09T18:15Z (cycle 2034v100)
- Refresh on: PR open, RFC updates touching Phase 2.5, or Phase 1.4 reconciliation script PR landing first
