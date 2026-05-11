# scout — #738 stale source-code comments post chainhook scope-cut

**Status:** pre-positioned for re-review trigger. Do NOT post until biwasxyz pushes a new commit on #738 (would compound noise after v218/v220/v223/v227 comments not yet responded to).

**Discovery cycle:** 2034v233 (2026-05-11T23:38Z)

**Context:** PR-C (chainhook) was scope-cut at 04:31-04:34Z 5/11 via 8 revert commits (per v227 finding). Most chainhook references in the branch are intentional — `source` enum reserves the value for future use, agent-card describes it as "reserved." But two source-code comments still reference chainhook as an active ingestion path.

## Findings (2 stale code comments)

### 1. `lib/competition/verify.ts:14` — claims 3 ingestion paths

Current text:
```ts
 * `verifyAndPersistSwap` is the shared entry point used by all three
 * ingestion paths (agent-submit POST, chainhook, nightly cron). It takes a
 * txid, fetches the Hiro tx, runs sender + allowlist checks, parses the
 * swap, and persists via INSERT OR IGNORE (first writer wins on `(txid)`).
```

Current reality: 2 ingestion paths (`POST /api/competition/trades` agent-submit, `/api/competition/cron` cron sweep). Chainhook is reserved enum, not a deployed path. The "all three" framing is stale.

Suggested replacement:
```ts
 * `verifyAndPersistSwap` is the shared entry point for the two deployed
 * ingestion paths (agent-submit POST, nightly cron). A third value
 * `'chainhook'` is reserved in the `source` enum for future real-time
 * ingestion. It takes a txid, fetches the Hiro tx, runs sender + allowlist
 * checks, parses the swap, and persists via INSERT OR IGNORE.
```

Line cost: ~3 LOC delta.

### 2. `lib/competition/d1-reads.ts` — references PR-C as part of shipping plan

Current text (top-of-file comment):
```ts
 * Phase 3.1 PR-A — read routes only. The verifier (POST /api/competition/trades)
 * ships in PR-B; chainhook + cron + allowlist in PR-C + PR-D.
 *
 * Read contract (locked, per PHASE-3.1-HANDOFF.md):
```

Current reality: PR-C was reverted; only PR-A + PR-B + PR-D + PR-E remain. PR-D ships cron + allowlist (chainhook excluded). Also references PHASE-3.1-HANDOFF.md which is missing from branch (per v223 finding).

Suggested replacement:
```ts
 * Phase 3.1 PR-A — read routes only. The verifier (POST /api/competition/trades)
 * ships in PR-B; cron + allowlist in PR-D. Chainhook (PR-C) was scope-cut;
 * the source enum reserves its name for future implementation.
 *
 * Read contract (locked):
```

(Drops PHASE-3.1-HANDOFF reference since the doc isn't committed.)

### 3. `verify.test.ts` chainhook test fixtures (NOT stale, but worth noting)

Two tests use `source: "chainhook"` to verify the verifier doesn't overwrite a chainhook-sourced row (first-writer-wins). These tests are HYPOTHETICAL — they construct a row with source="chainhook" to exercise the enum-value-preservation path. Not stale per se since the enum value IS reserved and the verifier IS supposed to preserve any source. But they ARE testing a code path that has no production caller right now.

Decision: leave the tests as-is. They guard against a future regression where someone adds chainhook ingestion and discovers the verifier overwrites source. Cheap insurance.

## Posting trigger

When biwasxyz pushes a new commit on #738 (any reason), pivot this scout into a non-blocking inline review comment on the verify.ts / d1-reads.ts lines. Until then, hold — would be 5th comment from me without biwasxyz response = noise compounding per v229 discipline.

## Cross-references

- v227 chainhook scope-cut discovery (8 revert commits at 04:31-04:34Z 5/11)
- v223 PHASE-3.1-HANDOFF.md broken link
- v228 commit-SHA-compare-at-boot discipline (would catch when biwasxyz pushes new commits on #738)
