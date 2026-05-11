# State -- Inter-Cycle Handoff
## cycle 2034v201 — #743 substantive review (CI BLOCKER + 5 non-blocking observations)

cycle: 2034v201
at: 2026-05-11T08:55Z
status: shipped_1_substantive_review

## cycle_goal
biwasxyz just opened landing-page#743 ("feat(agents): MCP trades count + volume + latest-trade columns on /agents") at 08:49Z — directly adjacent to #740/#741 root cause area, stacked on #738. Substantive review with line cites.

## shipped
1. **#743 substantive review** (08:54:41Z, https://github.com/aibtcdev/landing-page/pull/743#pullrequestreview-4262032588) — COMMENTED with [BLOCKER] lead:
   - **[BLOCKER]** CI failing — `lib/competition/volume.ts` lines 87/100/107 trip ESLint `no-console` (3 `console.warn` calls in `fetchTokenPriceUsd`). Fix recipe: thread `createConsoleLogger`/`createLogger` from `@/lib/logging` per the project's documented pattern, replace 3 lines, CI clears. ~6 LOC added, 3 LOC changed. Operator pasted the Cloudflare Workers build log mid-cycle confirming the exact failure.
   - **Architecture wins**: single D1 GROUP BY query, parallel Tenero pricing deduplicated by token_in, AbortSignal.timeout(5_000), TOKEN_DECIMALS pinned with provenance comment, count-unknowns-but-skip-from-volume semantic discipline. Matches v183 JIT-at-current-scale framing I argued on #651.
   - **Observation 1 (v137-family)**: 0 unit tests for `lib/competition/volume.ts` despite 7 specific behavioral claims in docstrings. Test scaffold proposed (~120-180 LOC). Same pattern as #705/#510/#706 that #738's b6eb2c8e partially closed.
   - **Observation 2 (v172 cross-PR)**: /agents now has TWO source-of-truth conventions — agent list from stale KV cache (#740/#741 root cause) + MCP trade columns from fresh D1. Visually side-by-side stale level + live trade count. Track A flip closes this when arc lands it.
   - **Observation 3 (wstx normalization)**: per v183 strategic-reply concern, `wstx` has no Tenero liquidity. `parseSwap` records `SP4SZE…wstx::wstx` not `stx` for stableswap-pool swaps. TOKEN_DECIMALS missing wstx → null price → volume=0. Two fix shapes: normalize at parser (v172 single-source) vs at pricer time. (a) is preferred.
   - **Observation 4 (Tenero cache absence)**: ~3 parallel 5s calls per /agents render. Tenero blip → all volume=0 for outage window. KV-cache last-known-good 60-300s TTL is the standard pattern. Mention for "if it shows up in latency traces" line in PR body.
   - **Observation 5 (sort tiebreak)**: Volume sort with all-zero unpriced agents has undefined order. Tiebreak by mcpTradeCount, parallel to existing sort-by-trades tiebreak (AgentList.tsx:213-216).

## #743 architecture summary
- Stacked on #738 (`feat/competition-read-routes`) — won't merge until #738 lands
- True new work: `lib/competition/volume.ts` (+198), `app/agents/page.tsx` (+34), `app/agents/AgentList.tsx` (+105) — rest is phantom-diff from stale base
- Closes my v183 strategic-reply framing as actually-implemented (Portfolio/Score absorbed into /agents columns rather than separate /leaderboard page; #742 closed as overengineered)

## Trading-comp surfaces (v201 end)
- #738 (Phase 3.1 verifier): OPEN, awaiting whoabuddy merge. ~19h since my final APPROVE.
- #743 (MCP-trade columns): NEW today, OPEN, UNSTABLE on CI BLOCKER. Awaiting biwasxyz console.warn fix.
- #651/#735: OPEN, awaiting merge
- #512/#513: OPEN, awaiting merge
- #740/#741: OPEN, awaiting whoabuddy Track B decision + arc Track A PR
- #730 Step 4: issue OPEN, PR not yet filed

## Wallet
- secret mars v2, mainnet, UNLOCKED.

## Inbox
- 0 unread.
