# landing-page#687 — Phase 2.1 rebuildAgentListCache flip — pre-PR scout

**Captured:** 2026-05-10T04:08Z (cycle 2034v117)
**Issue:** [#687](https://github.com/aibtcdev/landing-page/issues/687) (whoabuddy, 03:53Z 5/10)
**Surface:** `lib/cache/agent-list.ts` `rebuildAgentListCache(kv)`
**Sequencing:** First Phase 2.x deliverable. Phase 1.4 closed at 03:19Z 5/10 (#685 merged).

## Spec correctness — schema verification (3 catches)

Verified spec's SELECT against actual D1 migrations 001/002/003 (`gh api repos/aibtcdev/landing-page/contents/migrations/...`).

### Catch 1 (substantive, blocking): `a.check_in_count` is a phantom column

Spec L26 SELECT: `a.btc_address, ..., a.check_in_count, a.erc8004_agent_id, ...`

`migrations/001_agents.sql` has NO `check_in_count` column. Verified columns:
```
btc_address, stx_address, stx_public_key, btc_public_key, taproot_address,
display_name, description, bns_name, owner, verified_at, last_active_at,
erc8004_agent_id, nostr_public_key, capabilities_json, last_identity_check,
github_username, referred_by_btc, referral_code
```

Confirmed via `gh search code --repo aibtcdev/landing-page check_in_count`: only match is `scripts/migrations/paid-attention-retire.md` (historical). Also `checkInCount` does NOT appear in `lib/cache/types.ts`'s `CachedAgent` interface.

**Implication:** the SELECT as written would fail at runtime. Drop `a.check_in_count` from the column list — there's no consumer for it.

### Catch 2 (substantive, blocking): `a.referred_by` should be `a.referred_by_btc`

Spec L26 SELECT: `... a.referred_by, a.github_username, ...`

Actual column name in `001_agents.sql`: `referred_by_btc TEXT` (line 27, with comment "the BTC address of the referrer"). The spec uses the conceptual term, not the stored column name.

**Ironic context:** PR #686 (just merged 03:51Z 5/10) lands the contributor rule "spec from real records, not from concepts" specifically to short-circuit this exact class. The cited example in #686's note is `OutboxReply.toBtcAddress` vs `replyTo`. Phase 2.1's spec instantiates the same class in the OPPOSITE direction (column `referred_by_btc` vs spec's `referred_by`). Worth surfacing as the rule's first post-merge test.

**Mapping fix:** `a.referred_by_btc` in SELECT → `referredBy: row.referred_by_btc` in CachedAgent.

### Catch 3 (minor, outdated concern): `achievementCount` stub no longer exists

Spec §"Computed fields" L60: "`achievementCount`: hardcode `0` (achievements removed in Phase 0.1 via #654)" + earlier "the call site may still exist as a stub."

`lib/cache/types.ts`'s `CachedAgent` interface (current head) does NOT include `achievementCount` — already removed. Current `rebuildAgentListCache`'s map (L263-282 of `lib/cache/agent-list.ts`) does NOT emit `achievementCount`. `gh search code --repo aibtcdev/landing-page achievementCount` returns 0 matches. The stub is gone.

**Implication:** the spec's "hardcode `0`" instruction is obsolete — there's no field to hardcode. Spec can be tightened to drop the achievementCount discussion entirely.

## Spec correctness — fields fetched but unused

### `c.claimed_at` (in SELECT, not in CachedAgent shape)

Spec SELECT joins `claims` and pulls `c.claimed_at` alongside `c.status AS claim_status`. Current `CachedAgent` interface has no `claimedAt` field. `computeLevel(agent, claim)` only reads `claim.status` (not `claim.claimed_at`).

**Question:** is the spec planning to add `claimedAt` to the consumer-facing shape (which contradicts "consumer-facing shape unchanged")? Or is `c.claimed_at` defensive over-fetching? Worth pinning in the PR.

### `capabilities_json` (in 001 migration, not in SELECT)

Migration 001 has `capabilities_json TEXT` but the spec SELECT omits it. `CachedAgent` doesn't have a `capabilities` field either, so this is consistent — flagging only because `capabilities_json` is in the migration and a future reader might wonder why it's absent.

## D1 query shape — performance + alternatives

Spec proposes 2 correlated COUNT subqueries:

```sql
(SELECT COUNT(*) FROM inbox_messages WHERE to_btc_address = a.btc_address AND is_reply = 0)
  AS message_count,
(SELECT COUNT(*) FROM inbox_messages WHERE to_btc_address = a.btc_address AND is_reply = 0 AND read_at IS NULL)
  AS unread_count
```

`migrations/003_inbox_messages.sql` has a partial index that covers the first subquery directly:
```sql
CREATE INDEX idx_inbox_to_btc_sent_at ON inbox_messages(to_btc_address, sent_at DESC) WHERE is_reply = 0;
```

The partial-index restriction `WHERE is_reply = 0` matches both subqueries; SQLite can use this index for both. With ~7761 inbox rows total + ~243 agents, expected: ~486 small index seeks per rebuild. Well within Workers CPU budget.

**Alternative (LEFT JOIN with derived table):**
```sql
LEFT JOIN (
  SELECT to_btc_address,
    COUNT(*) AS message_count,
    SUM(CASE WHEN read_at IS NULL THEN 1 ELSE 0 END) AS unread_count
  FROM inbox_messages
  WHERE is_reply = 0
  GROUP BY to_btc_address
) im ON im.to_btc_address = a.btc_address
```

Single pass over inbox_messages (~7761 rows) instead of 2× per agent. Trade-off: subquery is simpler to read; derived table is faster at scale. At current 243-agent scale, both are fast — preference is readability over premature optimization.

**Recommendation:** ship correlated subqueries first (simpler, indexed); profile via worker-logs after deploy; switch to derived-table aggregation only if message_count/unread_count subqueries surface in the cost runbook.

## Phase 2.5 forward-link

The `unread_count` subquery in Phase 2.1's SELECT IS the Phase 2.5 fix for the `/api/agents` consumer of unreadCount. mcp-server#497 closure path was via Phase 2.5 read-flip — but Phase 2.1's flip *also* sources unreadCount from D1 SELECT (instead of cached `inbox:agent:{addr}.unreadCount`) for one consumer.

**Sequencing implication:** post-Phase-2.1-deploy, `/api/agents` would serve drift-free unreadCount **incidentally** for the agent-list endpoint. Phase 2.5 still needs to address `/api/inbox/{addr}` separately (different cache layer, different consumer).

Worth verifying with a 3-sample post-deploy probe at the regression-test address `bc1qxj5jtv8jwm7zv2nczn2xfq9agjgj0sqpsxn43h` (per v54/v55/v96 baseline) — `/api/agents` row's unreadCount should now == live-D1-count for that address.

## Signature compatibility

Spec acceptance criterion: "`rebuildAgentListCache(kv, db)` accepts a D1 binding (or pulls from `getCloudflareContext().env.DB` directly inside)".

Current callers of `rebuildAgentListCache`:
- `getCachedAgentList` (same file, L83 + L102) — passes `kv` only
- `maybeTriggerBackgroundRebuild` (same file, L137) — passes `kv` only
- `invalidateAgentListCache` (same file) — does NOT call rebuild directly

If signature changes to `(kv, db)`, all 2-3 internal callers need updating. Cleaner: pull DB from `getCloudflareContext().env.DB` inside the rebuild — preserves the existing 1-arg signature, no caller changes needed. Aligned with how other D1-using routes resolve the binding.

## CachedAgent shape — fields fetched but consumer-shape-unchanged invariant

The spec asserts `CachedAgent` / `CachedAgentList` types are unchanged. Verified against the current type definitions in `lib/cache/types.ts`:

```ts
interface CachedAgent {
  stxAddress, btcAddress, stxPublicKey, btcPublicKey,
  taprootAddress | null, displayName | null, description | null, bnsName | null,
  owner | null, verifiedAt, lastActiveAt | null, erc8004AgentId | null,
  nostrPublicKey | null, lastIdentityCheck | null, referredBy | null,
  githubUsername | null, level: number, levelName: string,
  messageCount: number, unreadCount: number
}
```

That's 20 fields. Spec's SELECT covers 17 agent columns + 2 claim columns + 2 computed counts = 21 source columns producing 20 output fields (after `level`/`levelName` derivation from `agent + claim` and dropping `claimed_at`).

**Mapping table** for the PR:

| CachedAgent field | Source |
|---|---|
| stxAddress | `a.stx_address` |
| btcAddress | `a.btc_address` |
| stxPublicKey | `a.stx_public_key` |
| btcPublicKey | `a.btc_public_key` |
| taprootAddress | `a.taproot_address` |
| displayName | `a.display_name` |
| description | `a.description` |
| bnsName | `a.bns_name` |
| owner | `a.owner` |
| verifiedAt | `a.verified_at` |
| lastActiveAt | `a.last_active_at` |
| erc8004AgentId | `a.erc8004_agent_id` |
| nostrPublicKey | `a.nostr_public_key` |
| lastIdentityCheck | `a.last_identity_check` |
| referredBy | `a.referred_by_btc` (NOT `a.referred_by`) |
| githubUsername | `a.github_username` |
| level | `computeLevel({stxAddress, ...} as AgentRecord, {status: row.claim_status, ...} as ClaimStatus)` |
| levelName | `LEVELS[level].name` |
| messageCount | `row.message_count` (subquery) |
| unreadCount | `row.unread_count` (subquery) |

Signed off — all 20 fields trace cleanly to a source column or derivation.

## stats fields

Spec doesn't explicitly discuss `stats: { total, genesisCount, messageCount }`. Current rebuild derives:
- `total = cachedAgents.length`
- `genesisCount = cachedAgents.filter(a => a.level >= 2).length`
- `messageCount = inboxData.reduce((sum, inbox) => sum + (inbox?.messageIds.length ?? 0), 0)` — total across all agents

For Phase 2.1: same shape, derived from the rebuilt `cachedAgents` array. `messageCount` becomes `cachedAgents.reduce((s, a) => s + a.messageCount, 0)` (using each agent's per-row count). Worth a one-liner test confirming `stats.messageCount === sum of per-agent message_count` post-flip.

## 8 invariant correctness checks for the PR review

1. ✅ Spec column-list matches actual schema (catches 1 + 2 above).
2. ✅ NULL handling: `LEFT JOIN claims` with `claim_status = NULL` → `level = 1` (Registered). Test added per spec.
3. ✅ NULL handling: `claim_status = 'pending' or 'failed'` → `level = 1` (NOT Genesis). `computeLevel` only matches `'verified' | 'rewarded'`.
4. ✅ Subqueries respect partial index (`idx_inbox_to_btc_sent_at WHERE is_reply = 0`) — verify via EXPLAIN QUERY PLAN if profiling.
5. ✅ Zero KV reads on rebuild path — verify via worker-logs after deploy.
6. ✅ Cache layer wrapping unchanged — `getCachedAgentList` mark-stale invalidation via `cachedAt` shift remains (no logic change to the wrapper).
7. ✅ Consumer-shape unchanged — type-check pass + `__tests__/agent-list.test.ts` existing tests pass.
8. ✅ Sentinel `BUILDING_KEY` flow unchanged — rebuild still claims/releases the sentinel via the existing wrapper.

## 4 unique-value-adds I'll surface in PR review

1. **Schema verification table** — cite catches 1+2 with SELECT-vs-migration column-by-column comparison.
2. **`computeLevel` reconstruction shape** — show the lightweight AgentRecord/ClaimStatus shapes that satisfy the function's reads, vs full record reconstruction.
3. **Phase 2.5 forward-link probe** — propose 3-sample post-deploy verification at regression address per v54/v55/v96 baseline.
4. **Subquery vs derived-table trade-off** — defer derived-table optimization to post-deploy profiling rather than pre-empt it now.

## Pile-on-avoidance map

Areas to NOT pile on:
- Existing wrapper logic (`getCachedAgentList`, `maybeTriggerBackgroundRebuild`, `invalidateAgentListCache`) — preserved from PR #656.
- Cache TTL / freshness window constants — out-of-scope per spec.
- Vitest test framework choices — established.
- D1 binding resolution — internal-call-graph optimization debatable but minor.

## Sequencing watch

Next likely Phase 2.x issues to file (extrapolating from spec pattern):
- Phase 2.2: claim status / leaderboard endpoint flip
- Phase 2.3: vouch list endpoint flip
- Phase 2.4: agent profile detail endpoint flip
- Phase 2.5: inbox `/api/inbox/{addr}` flip (closes mcp-server#497 directly per existing recipe)

If whoabuddy files these as separate issues, the same scout pattern applies. Phase 2.5 already has a scout at `daemon/scouts/lp-phase-2.5-prep.md` (180 lines from v100).
