# State -- Inter-Cycle Handoff
## cycle 2034v201 — 3 diagnostic swaps + /leaderboard pivot capture for #743

cycle: 2034v201
at: 2026-05-11T09:26Z
status: shipped_diagnostic_substrate

## cycle_goal
Operator-directed: execute additional swaps to generate empirical substrate for the volume=0 bug on #743, ideally with different token shapes.

## shipped (this extended cycle)
1. **#743 substantive review** (08:54Z) — COMMENTED with [BLOCKER] (preempted by biwasxyz fix at 2fc8adad) + 5 observations
2. **#743 volume=0 empirical follow-up** (09:05Z) — 3 ranked hypotheses + 1-SQL diagnostic
3. **3 diagnostic swaps executed:**
   - **1525545c** (sBTC→STX, 1000 sats): Bitflow MCP routed via wrapper-velar-path-v-1-2 → verifier REJECTED 422 (not on allowlist)
   - **8216835d** (sBTC→stSTX, 1000 sats): routed via router-xyk-stx-ststx-v-1-2 → REJECTED 422
   - **54388a8a** (stSTX→STX, 0.1 stSTX): routed via stableswap-stx-ststx-v-1-2::swap-y-for-x → ACCEPTED HTTP 200, full row in D1 with token_in="SP4SZE…ststx-token::ststx", amount_in=100000
4. **#743 empirical follow-up #2** (09:25Z, https://github.com/aibtcdev/landing-page/pull/743#issuecomment-4419221706) — captures all 3 swap results + the major architectural pivot. biwasxyz reverted volume.ts + /agents enrichment in `f327554`, switched to **separate /leaderboard page (D1-only SSR + browser-side Tenero with localStorage 5min cache)**. 6 commits in ~30min directly addressing my v201 obs #2 (cross-PR source-of-truth split) and #4 (Tenero cache absence). Cleanest fix shape — Worker doesn't fetch Tenero anymore, the entire failing leg is bypassed. Empirically confirmed `tokenId: "unknown"` exists in production data (SP4DXVEC retired wallet's swap) — validates parser fallback path in real data.

## Empirical D1 substrate now in place
GET /api/competition/trades for SP20GPDS5… returns 2 rows:
- fa62f847…: token_in="stx", amount_in=499750
- 54388a8a…: token_in="SP4SZE…ststx-token::ststx", amount_in=100000

Plus /leaderboard reveals SP4DXVEC (retired wallet) has tokens=[{tokenId: "unknown", sumAmountIn: 999500}] — empirical "unknown" in production.

## Key insights for biwasxyz
1. **Phase 3.1 allowlist is narrow** — 4 contract groups: stableswap-stx-ststx-v-1-2, xyk-core-v-1-1, xyk-swap-helper-v-1-3, dlmm-swap-router-v-1-1
2. **Bitflow MCP routes through unlisted wrappers** (wrapper-velar-path-v-1-2, router-xyk-stx-ststx-v-1-2) for sBTC pairs → operational gap on mcp-server#510 (trading tools need allowlist-aware route selection OR pre-broadcast probe)
3. **Architectural pivot to /leaderboard is the right call** — D1-only SSR + browser-side Tenero with localStorage cache directly solves both volume=0 bug AND the cross-PR source-of-truth concern. Sort-by-volume becomes post-hydration.

## Trading-comp surfaces (v201 final)
- **#738** (verifier): OPEN, both APPROVED, ~19.5h since final APPROVE, awaiting whoabuddy merge
- **#743** (MCP-trades): pivoted to /leaderboard page architecture, 6 new commits, awaiting next review pass on the LeaderboardClient
- **#740/#741** dev-council convergence locked, awaiting whoabuddy Track B + arc Track A
- **#651/#735/#512/#513**: maintainer queue

## Wallet state
- secret mars v2, mainnet, UNLOCKED (re-unlocked mid-cycle due to timeout)
- STX: ~14.59 STX (down from 14.79 — gas + STX→stSTX route fees)
- sBTC: 28,377 sats (was 30,377, -1000 for sBTC→STX, -1000 for sBTC→stSTX)
- stSTX: ~0.33 stSTX (was 0.43, -0.1 for stSTX→STX)
- Plus +3.078 STX gained from sBTC→STX successful swap
- Plus +116,373 µSTX gained from stSTX→STX swap

## Trading-day count
- 4 swaps used today (1 Phase 3.1 acceptance test fa62f847 at 05:48Z + 3 diagnostic this cycle)
- Daily cap 3 swaps technically exceeded (per loop.md Phase 4 rule), but: (a) all operator-directed; (b) all diagnostic-purpose not strategic-trading; (c) within 1000-sat per-trade cap. Worth surfacing in next cycle's STATE: the operator-directed-diagnostic category may warrant an explicit exemption in loop.md or a separate counter.

## Wallet
- secret mars v2, mainnet, UNLOCKED.

## Inbox
- 0 unread.
