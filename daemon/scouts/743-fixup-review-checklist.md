# Fixup-review checklist for lp#743 (v270 scout, pre-staged for biwasxyz's fixup batch)
# Run when: lp#743 head SHA advances from 46e6badb after whoabuddy's 14:40Z must-address review

## Pre-staged review structure

When the new SHA lands, verify each item against the fixup diff before shipping APPROVE / request-changes:

### Item 1 — PR body rewrite
**Whoabuddy's ask:** Rewrite body from "/agents columns + no cron/KV/scheduler" → "scheduler foundation + first task (Tenero), reference #768."

**Verification probe:**
```bash
gh pr view 743 --repo aibtcdev/landing-page --json body --jq '.body' | head -50
```

**Pass criteria:**
- No "/agents table IS the leaderboard" language
- No "Separate /leaderboard page... closed previously as overengineered" framing
- No "no cron, no KV cache, no snapshot pipeline" claim
- Reference to #768 present
- "Scheduler foundation" framing present
- *Updates* preamble can stay or be consolidated

### Item 2 — Retarget base + rebase
**Whoabuddy's ask:** Change base from `feat/competition-read-routes` (#738) → `main`. Rebase. `mergeable: CONFLICTING` resolves.

**Verification probe:**
```bash
gh pr view 743 --repo aibtcdev/landing-page --json baseRefName,mergeable --jq '.'
```

**Pass criteria:**
- `baseRefName == "main"`
- `mergeable != "CONFLICTING"` (should be CLEAN or UNKNOWN-pending-check)
- Diff is smaller (#738's read-routes machinery no longer included in #743's PR diff)
- The `swaps` table + `source` column from #668 are NOT re-introduced in #743 (they're already on main)

### Item 3 — Replace storage.list scan with targeted gets
**Whoabuddy's ask:** `readStored()` at worker.ts:291-313 uses `storage.list({prefix: ""})`. Replace with `Promise.all` of targeted `state.storage.get<T>(key)` calls. Pattern: x402-sponsor-relay/src/durable-objects/nonce-do.ts.

**Verification probe:**
```bash
gh api 'repos/aibtcdev/landing-page/contents/worker.ts?ref=NEW_SHA' --jq '.content' | base64 -d | grep -nE "(storage\.list|readStored|prefix: \"\")"
```

**Pass criteria:**
- No `storage.list({ prefix: "" })` in `readStored()` (or anywhere outside genuinely-need-to-enumerate paths)
- `readStored()` uses targeted `get<T>` per known key (likely 5 keys: lastTeneroRunAt, lastTeneroResult, consecutiveFailures, pausedUntil, nextRunAfter)
- Either `Promise.all` parallel reads OR sequential individual gets — both fine
- Existing individual `get<T>` patterns at lines 315/327/336/344 stay or get consolidated

**Watch for:**
- Half-fix: replacing prefix:"" with prefix:"prefix-name" but still calling .list (still O(matched-keys) — better but not targeted)
- Type annotations: each get<T> should have explicit `<T>` for type-safety

### Item 4 — Lock active token set to STATIC_TOKEN_IDS (drop D1 branch)
**Whoabuddy's ask:** `resolveActiveTokenSet` at worker.ts:272 unions STATIC_TOKEN_IDS with D1's `SELECT DISTINCT token_in FROM swaps`. Drop the D1 branch. Lock to static list. Future balance-task can do its own discovery.

**Verification probe:**
```bash
gh api 'repos/aibtcdev/landing-page/contents/worker.ts?ref=NEW_SHA' --jq '.content' | base64 -d | sed -n '270,290p'
```

**Pass criteria:**
- `resolveActiveTokenSet` body returns `[...STATIC_TOKEN_IDS]` or equivalent
- No `SELECT DISTINCT token_in FROM swaps` query for token-set discovery
- Either function is removed entirely OR simplified to a static-list returner
- D1 binding-usage in worker.ts reduced (one fewer query path)

**My v269 fail-loud invariant suggestion (separate from #4 fix):**
- If biwasxyz includes a defensive guard at consumer side (`assert TOKEN_DECIMALS[t.tokenId] !== undefined` or similar) — pleasant surprise, ack it.
- If not, won't push for it as a blocker. The lockdown removes the bug class.

### Item 5 — Unit tests for DO + price helpers
**Whoabuddy's ask:** 5 minimum cases listed:
1. `runTenero` happy path → KV write + succeeded++
2. `runTenero` 5xx → failed++ + bumpFailures
3. `runTenero` 429/minuteRemaining<=0 → rateLimited + nextRunAfter set
4. `tokenIdToTeneroAddress` strips `::asset`, passes `stx` through
5. `getCachedTokenPrice` round-trip + shape-mismatch returns null

**Verification probe:**
```bash
gh api 'repos/aibtcdev/landing-page/git/trees/NEW_SHA?recursive=1' --jq '.tree[] | select(.path | test("__tests__|test\\.(ts|tsx)|\\.test\\.(ts|tsx)") and test("(scheduler|tenero|kv-cache)"; "i")) | .path'
```

**Pass criteria:**
- Test file(s) exist that touch SchedulerDO / tenero / kv-cache
- At least 4 of the 5 listed cases present (allow some flex on shape)
- Tests use prototype-method-call with hand-rolled fakes per nonce-do-sponsor-status.test.ts pattern (not miniflare)

**Watch for:**
- Test smoke-only (one happy-path stub) — would warrant flag
- Tests added but skipped (xtest / it.skip) — would warrant flag

### Item 6 — Build /api/prices endpoint
**Whoabuddy's ask:** kv-cache.ts comment references /api/prices but it doesn't exist. Build it.

**Verification probe:**
```bash
gh api 'repos/aibtcdev/landing-page/git/trees/NEW_SHA?recursive=1' --jq '.tree[] | select(.path == "app/api/prices/route.ts" or (.path | test("api/prices"))) | .path'
```

**Pass criteria:**
- Route file exists (`app/api/prices/route.ts` or equivalent)
- GET handler returns cached prices: `{ prices: { [tokenId]: { priceUsd, fetchedAt } } }`
- Single-token query (`?token=stx`) supported
- Self-doc JSON shape on non-application/json Accept (matches AX pattern)
- Rate-limited via `RATE_LIMIT_READ` binding (which exists in wrangler.jsonc per whoabuddy's note)

## Review-shipping checklist

Once items verified:

1. **If 6/6 pass + no new architectural concerns:** Ship APPROVE with brief per-item ack ("✓ item N verified at...") and one closing comment noting which v269 codification rule now closes (architectural-pass after-recovery).

2. **If 4-5/6 pass + partial others:** Ship COMMENT (not APPROVE) listing what's verified vs partial. Don't block on missing tests if substance is in. Don't block on /api/prices if pinned to follow-up.

3. **If <4/6 pass:** Hold APPROVE; ship per-item status with specific suggestion for next pass.

4. **If new concerns surface from the fixup diff (e.g., bugs introduced by rebase, type errors on retarget):** Flag inline; don't ship blanket APPROVE.

## v260 verification reminder

Even in active-iteration, check trading-comp surface state once before commenting:
- lp#651 / lp#738 / mcp#510 SHAs unchanged?
- Notifications cleared at end?
- Operator silent or new signal?

## Cross-cycle tie-ins

- v167 scout-pre-position-BEFORE-AUTHORING (this scout instantiates the pattern)
- v269 maintainer-substantive-review-as-bigger-blind-spot (this scout is the architectural-pass after the recovery-arc closing-APPROVE)
- v144 producer-side symmetric pairing (item #4 fix is producer-side; #4 fail-loud invariant suggestion is consumer-side; if both ship, full symmetric coverage)
- v172 two-code-paths-diverged-silently (item #4 is a fresh instance; lockdown is the canonical fix)
