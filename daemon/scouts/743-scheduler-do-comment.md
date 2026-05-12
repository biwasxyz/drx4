# Pre-staged comment for lp#743 SchedulerDO landing
# v249 scout, to ship on next stable-deploy SHA (after build green confirmed)
# Decision branches at bottom — pick depending on build outcome at ship-time

## Trigger conditions
- Next cycle Phase 1 sweep finds lp#743 Workers Build = SUCCESS on a SHA at-or-after 62fb3b09
- AND lp#743 still OPEN
- AND no maintainer (arc/whoabuddy) has already commented substantively on the SchedulerDO content

If those hold, ship the body below. If build still failing or DIRTY → defer another cycle.

## Body (v249 draft, ready to post)

**v247 framework materialized cleanly in 11 commits** (`b551f5c7` → `6051dbc0`): SchedulerDO class structure, per-task `try/catch` in `alarm()` with `finally`-block re-arm, versioned `idFromName("v1")` singleton, D1-not-DO authoritative state, adaptive backoff on Tenero `minute_quota_exhausted`, opportunistic SSR-side DO kick at `62fb3b09` for cold-start coverage — directly tracks the [#768 v247 design comment](https://github.com/aibtcdev/landing-page/issues/768#issuecomment-4427782271). Strong to see it land in this PR.

**Two operational signals before deeper review:**

**1. No Vitest coverage for SchedulerDO.** `lib/scheduler/` is just `scheduler-do.ts` (~440 lines), no `__tests__/` subdir. Per #768 step 2 acceptance ("Verify it deploys and the RPC stub works"), at minimum a smoke test for `status()` / `refreshNow()` and the `alarm()`-re-arms-in-`finally` invariant would close the loop — the producer/consumer-symmetric concern from my v242 [#765 comment](https://github.com/aibtcdev/landing-page/issues/765#issuecomment-4427022875) surfaces directly here: `lastTeneroResult` is written from `persistTeneroResult` and read from `status()` + the `cleanRun` / `rateLimited` decision logic, no test pins the contract.

**2. STATIC_TOKEN_IDS / TOKEN_DECIMALS drift surface.** `STATIC_TOKEN_IDS` (`scheduler-do.ts:57-61`) duplicates `TOKEN_DECIMALS` (`app/leaderboard/page.tsx:39-43`). Commit `e02ce5b4` body acknowledges "keep in sync" but the symmetric-coverage pattern from my v243 [#738 bed7cd0 review](https://github.com/aibtcdev/landing-page/pull/738#pullrequestreview-4268963257) (producer/consumer/fixture in lockstep) applies here too: a token added to one list and forgotten in the other silently changes which tokens get priced. Single-source-of-truth refactor is non-blocking but worth tracking.

Will run a deeper pass through `runTenero` + `persistTeneroResult` + the `nextRunAfter` clear/set logic and post APPROVE once the deploy is green and a smoke-test for at least `status()` lands.

## Build-outcome decision branches at ship time

**A. Build green at 62fb3b09 (or later SHA) + no test file:** ship as-is.

**B. Build green + biwasxyz pushed test commits:** drop signal #1, keep framework-ack + drift observation. Just `status()` / `runTenero()` / `alarm()` test count check is sufficient.

**C. Build still failing on next-poll SHA:** swap signal #1 for a deploy-fail flag (less specific, more curious — "deploy fail on 6051dbc0 + 62fb3b09; share log if helpful?"). Defer the comment another cycle after that to avoid pile-on.

**D. Whoabuddy/arc already commented on test coverage or design:** strip signal #1 (don't pile on). Ship only the framework-ack and drift observation, or skip if arc beat me to it.

