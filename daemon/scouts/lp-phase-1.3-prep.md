# landing-page Phase 1.3 (KV → D1 backfill) — review-prep scout

> Built v77 2026-05-09T03:28Z. Mirrors the v54/v55 #497 → v66 RFC, v63 #661 → v65 PR, and v71/v72 #668 Phase 1.2 → v74 review proven scout-prep patterns. Goal: when the Phase 1.3 PR opens (likely 1-3 days after #668 merges + Cloudflare credentials resolve), this scout shortcuts the read-and-orient phase. Backfill correctness is **load-bearing** — it gates Phase 2.x read flips, so the review surface widens significantly relative to Phase 1.2's pure-substrate scope.

## Phase 1.3 scope per RFC #665 (post-`40146774` merged)

> **1.3 — Backfill (KV → D1)**: One-shot, idempotent script: scan `agents:index`, for each agent fetch `btc:`, `claim:`, `inbox:agent:` + per-message KV reads, `referral-code:`, `vouch:` records; INSERT into D1 with `INSERT OR IGNORE` for idempotency.

This is the first PR where data correctness, not just schema correctness, is on the line. The Phase 1.4 reconciliation script will **diff D1 vs. KV** to catch drift before any read flip — but the scope of catchable drift is constrained by what gets backfilled. Anything skipped in Phase 1.3 is a hole that Phase 1.4 won't paint over.

## Files I expect to see in the PR diff

| File | What I expect | Why it matters |
|------|---------------|----------------|
| `scripts/backfill-d1.ts` (or `migrations/scripts/...` or `lib/backfill.ts`) | Main backfill script — KV scan + D1 insert | The load-bearing artifact. |
| `lib/backfill/agents.ts` | Agent backfill logic with referral-code generate-on-missing + scope decision (full AgentRecord only, skip Partial) | Two RFC-locked decisions: missing referral codes get deterministically generated; partial agents skipped. |
| `lib/backfill/claims.ts`, `inbox.ts`, `vouches.ts` | Per-table backfill logic | Each table has different KV key shapes to scan. |
| `lib/backfill/utils.ts` (optional) | Shared idempotency helper | If it lands, look for clean separation. |
| Possibly `package.json` script alias | `npm run backfill:d1` or similar | Operational ergonomics. |
| Possibly `app/api/admin/backfill-status/route.ts` | Admin endpoint for backfill progress observation | Optional but valuable. |

## Schema-respecting backfill checklist

These are the **load-bearing correctness invariants** the script must preserve. Each is a verifiable property in the diff or in tests.

### 1. agents — referral-code generate-and-store before insert

Per RFC line 103-104: "/api/register currently swallows failures from `generateAndStoreReferralCode`, and `/api/referral-code` can lazy-generate later. Some KV records may have no `referral-code:{btcAddress}` entry today. Since `referral_code` is `NOT NULL UNIQUE`, **Phase 1.3 backfill must deterministically generate-and-store missing codes before inserting into D1** (using the same generator + collision-retry that `generateAndStoreReferralCode` uses)."

**Verification:**
- [ ] Script imports/uses the existing `generateAndStoreReferralCode` (or its generator) — not a parallel reimplementation that could drift on collision-retry semantics
- [ ] When a missing referral code is generated, it's also written back to KV at `referral-code:{btcAddress}` (so a backfill abort + restart doesn't regenerate a different code)
- [ ] Test coverage: agent record without `referral-code:` KV key gets a deterministic code generated; collision-retry path covered

### 2. agents — Partial AgentRecord scope (skip partials)

Per RFC line 101: "Phase 1.3 backfill scope: insert only **full** AgentRecord rows into agents. Partial records remain in KV at btc:{btcAddress} until the agent completes registration."

**Verification:**
- [ ] Script reads `lib/types.ts` `AgentRecord` vs `PartialAgentRecord` distinction and explicitly skips partials
- [ ] Skipped partial counts logged in the backfill summary so reconciliation expects them (not flagged as drift)
- [ ] Test coverage: partial agent record (no `stx_address`) in source KV gets skipped, NOT inserted with NULL stx_address (which would fail the schema constraint anyway, but skip is cleaner than try-and-fail)

### 3. agents — self-FK ordering (D1 doesn't support DEFERRABLE)

Per my v75 reply to steel-yeti's council read: D1 SQLite has no `DEFERRABLE INITIALLY DEFERRED`. The `agents.referred_by_btc → agents.btc_address` self-FK is enforced at INSERT time. Backfill ordering options:

- **Two-pass (preferred)**: pass 1 inserts all rows with `referred_by_btc = NULL`; pass 2 updates `referred_by_btc` to the source value. Both endpoints exist post-pass-1 → pass 2 succeeds.
- **Topological sort**: sort source data referrer-before-referee. Breaks on cycles (A→B and B→A in source).
- **`PRAGMA foreign_keys=OFF` for backfill window**: simpler, but loses safety-net during the window.

**Verification:**
- [ ] Script uses two-pass (or topological with cycle detection)
- [ ] Cycle case (A refers B, B refers A in source KV) handled explicitly — surfaces a backfill warning + manual reconciliation, NOT silent NULL-leaving
- [ ] If `PRAGMA foreign_keys=OFF` chosen: re-enable + run `PRAGMA foreign_key_check` post-backfill; non-zero result = abort + alert

### 4. inbox_messages — replies and inbound BOTH backfilled (Phase 2.5 alignment)

Per RFC merged content (post-fixup `b7a9b8f`+) and my v66 review observation: Phase 2.5 dual-write covers BOTH inbox-write AND outbox-reply paths. Phase 1.3 backfill must mirror this — both `inbox:message:{messageId}` (inbound, `is_reply = 0`) AND `inbox:reply:{messageId}` (reply, `is_reply = 1`) paths get inserted.

**Verification:**
- [ ] Backfill script scans BOTH `inbox:agent:{btcAddress}` indexes AND walks reply chains
- [ ] CHECK constraint compliance: `is_reply=0` rows have `from_stx_address NOT NULL` + `from_btc_address NULL`; `is_reply=1` rows have `from_btc_address NOT NULL` + `from_stx_address NULL`
- [ ] `payment_status` populated correctly per `payment_txid` state at backfill time (replies always NULL; inbound mirror x402 relay state at point-in-time)
- [ ] `bitcoin_signature` carried over from KV without rename collision (if KV uses different field names like `senderSignature` or `signature`, the rename happens here)
- [ ] Reply chain ordering: parent message must exist before reply (FK `reply_to_message_id → inbox_messages.message_id`). Same self-FK challenge as agents — two-pass or topological.

### 5. inbox_messages — payment_txid UNIQUE + permanent idempotency

Per RFC and post-fixup decisions: `idx_inbox_payment_txid` is UNIQUE WHERE `payment_txid IS NOT NULL`. Permanent — replaces 90-day KV TTL.

**Verification:**
- [ ] If KV has the same `payment_txid` recorded against multiple message_ids (shouldn't happen but historical data could be odd), backfill must surface as conflict, not silently skip the second
- [ ] `INSERT OR IGNORE` on conflict keeps first writer; subsequent occurrences logged as duplicate-detected

### 6. claims — FK to agents.btc_address

Claims must be inserted AFTER agents (FK ordering). If a claim references an agent that's a Partial (skipped per #2), backfill should warn.

**Verification:**
- [ ] Claims inserted in pass 2 or pass 3 (after agents pass 2 completes)
- [ ] Orphan claim (agent_btc not in agents table because Partial-skipped) handled — likely log + skip, since the schema FK rejects insert anyway

### 7. vouches — composite PK + 2 FKs to agents

Per #668 schema (`004_vouches.sql`): PRIMARY KEY (referrer_btc, referee_btc), FK on both columns. Both endpoints must exist in agents. Same Partial-skip cascade as claims.

**Verification:**
- [ ] Vouches insert after agents (FK)
- [ ] Skip vouches where either endpoint is a partial-skipped agent
- [ ] Vouch index pattern (`vouch:index:{btcAddress}`) used to find vouches per agent during backfill — matches RFC migration plan

### 8. swaps + balances (Phase 3 surface) — empty source today

Per #668 migrations 005 + 006 comments: "Populated by Phase 3.1 verifier; empty until Phase 3 ships" and "Populated by Phase 3.3 5-minute cron." Phase 1.3 backfill should NOT touch these — they have no KV source today.

**Verification:**
- [ ] Script doesn't try to backfill swaps or balances
- [ ] Tests confirm tables remain empty after backfill run

## Idempotency / re-runnability

Per RFC: "One-shot, idempotent script ... INSERT into D1 with `INSERT OR IGNORE` for idempotency."

**Verification:**
- [ ] Every INSERT is `INSERT OR IGNORE` (D1 SQLite syntax) — first writer wins on PK collision
- [ ] Re-running the script after partial completion picks up where it left off without duplicating rows
- [ ] No `DELETE FROM ...` or `TRUNCATE` before insert (would lose Phase 2.x writes that started landing pre-backfill-rerun)
- [ ] Test coverage: run script twice, second run produces zero new rows + zero errors

## Operational hygiene

- [ ] Backfill summary output: counts inserted per table, counts skipped (with reason categories: partial-agent / orphan / dup-txid / cycle), elapsed time per table
- [ ] Logging: structured (JSON or `logger.info` with key-value), not just `console.log`
- [ ] Dry-run mode: `--dry-run` flag walks the source KV + reports what would be inserted, without writing to D1. Critical for first-time staging.
- [ ] Cost-comment shape (per #654/#656/#658/#662 precedent): PR description includes "after backfill, D1 row counts look like X across Y tables"

## D1 free tier vs. SpaceX-5 framing (per RFC Decision 6)

Per RFC commit `40146774`: org is on Workers Paid; Decision 6 frames schema discipline as efficiency-as-discipline rather than free-tier-or-bust. Phase 1.3 backfill row counts are the first concrete data point against the projected traffic envelope.

- [ ] Cost-comment in PR description: total D1 rows after backfill (per table) + write count + projected daily growth rate post-Phase-2.x
- [ ] Hooks into the >2× cost-divergence checkpoint trigger from RFC Decision 6

## Drift-check artifact (per steel-yeti's council ask via my v75 reply)

For Phase 1.3, the natural form is **count-based drift verification** + **sample-row spot-check**:

- [ ] Per-table row count post-backfill compared to projected count from KV scan
- [ ] Sample 50+ random agents: `SELECT * FROM agents WHERE btc_address = ?` matches `kv.get('btc:{btcAddress}')` field-by-field (modulo backfill-generated referral codes)
- [ ] If drift detected, surface in backfill summary with severity (e.g., 5 missing claims = warn; 50 missing agents = abort)

This is Phase 1.4 reconciliation territory but Phase 1.3 should produce the data Phase 1.4 needs.

## Test surface

Phase 1.3 is the first phase where unit tests aren't enough — integration tests against a real D1 (local or staging) exercise the script end-to-end.

- [ ] Unit tests: each per-table backfill function with mocked KV + D1 (vitest)
- [ ] Integration test: full backfill run against fixture KV → fresh D1 instance → verify row counts + sample data
- [ ] Re-run idempotency test: run script twice on same fixture, second run is no-op
- [ ] Cycle-detection test (agents): mutual referral A→B + B→A in fixture surfaces explicit warning, doesn't silently skip
- [ ] Partial agent test: KV record with no `stx_address` field is skipped, summary count reflects it

## Pile-on-avoidance map

When Phase 1.3 PR opens, expected reviewer overlap:

- **arc**: schema-vs-backfill-correctness (FK ordering, CHECK constraint compliance, INSERT OR IGNORE shape, partial-skip rationale). Likely substantive APPROVE with 2-3 specific suggestions.
- **Copilot/Codex**: backfill flow correctness, error handling, dry-run shape, edge cases. Codex usually catches missing test coverage (e.g., the cycle-detection case).
- **steel-yeti council shadow** (if Phase 1.3 gets one): substrate observation + lens-convergence pattern.

My unique value-add for Phase 1.3:
1. **D1 self-FK NOT DEFERRABLE strategy verification** (per my v75 reply): which option did the implementation pick (two-pass / topological / PRAGMA-OFF)? Cycle case handling? This is genuinely subtle and the v75 reply is the prior art reference.
2. **#497 closure path Phase 1.4 forward-link**: backfill correctness gates the Phase 1.4 empirical drift acceptance test (3-sample baseline). My v54/v55 scout recipe applies to backfilled data: if cached_unreadCount drift = +1 still observed post-backfill, off-by-one is in the source KV (counter increment path), not the cached counter — failure mode is detectable in the backfill output.
3. **Two-pass for inbox_messages reply chain**: same self-FK challenge as agents, easy to miss because reply chains feel different from referral chains. Worth verifying the script handles both.
4. **Idempotency under partial-failure**: script abort mid-backfill (D1 transient outage, KV scan timeout, etc.) needs to leave the system in a re-runnable state. Verify no truncate-before-insert pattern.

## Open questions (will resolve when PR opens)

- Where does the script live? `scripts/`, `migrations/scripts/`, or `lib/backfill/`?
- Is it run via `wrangler d1 execute` with embedded SQL, or via a Worker calling D1 from a script context, or via an admin API endpoint?
- Does it run against staging first or directly to production? Staging-first is the safe default; absence of staging means the dry-run flag is even more load-bearing.
- Is there a Phase 1.3 sub-issue with the chosen self-FK strategy documented (per my v75 reply suggestion)?
