# State -- Inter-Cycle Handoff
## cycle 2034v251 — lp#743 runtime-error follow-up (green build, all routes 404)

cycle: 2034v251
at: 2026-05-12T07:36Z
status: shipped

## OPERATOR DIRECTIVE (active — /start args 2026-05-11)
> "we need to closely look into the prs and updates on the trading competition on both mcp and landing-page so we need to keep looking into the PRs review them test them using the preview url focus your 100% on those okay file an issue tag whoabuddy/arc"

## v251 ship
**lp#743 runtime-error flag** (issuecomment-4428320462, verified 200) — follow-up to v250's deploy-fail flag:
- Build 3 (62fb3b09 at 07:28Z) + build 4 (07:34Z) both SUCCESS — CF reports "Deployment successful"
- BUT branch preview at feat-agents-mcp-trades-volume-... returns HTTP 404 on **every route** with `x-preview-user-error: true` header (CF's signal user code threw)
- Tested 6 routes (/, /leaderboard, /api/competition/trades, /api/competition/allowlist, /dashboard, /agents) — all universal 404
- Worker throwing at module-load or fetch-handler entry, before route dispatch
- Likely cause guesses (without dash access): env.SCHEDULER.idFromName("v1") in 62fb3b09's opportunistic SSR kick throws when binding not fully wired in preview env, OR SchedulerDO constructor's blockConcurrencyWhile-then-setAlarm throwing on first instantiation
- Offered to read trace; holding substantive 12-commit review until runtime stabilizes

## v251 build-state-vs-runtime-state observation
Important learning surface: **CF's "Deployment successful" status only confirms build+upload succeeded; runtime errors at module-load or fetch-handler entry are invisible to CF's check_run.** The deploy is technically live but the worker is universally throwing. This is exactly the scenario operator directive ("test them using the preview url") catches that CF check_runs miss.

## v251 boot SHA-compare
- lp#651 unchanged d711c3a1
- lp#738 unchanged 5224a0d9
- lp#743 still 62fb3b09 (build green, runtime broken)
- lp#768 unchanged issue
- mcp#510 unchanged 521c2466

## Pending on resume — next cycle (270s tight)
- biwasxyz may respond to either v250 (deploy-fail) or v251 (runtime-broken) flag
- Likely fixup push from biwasxyz once they see flags
- Pre-staged scout (daemon/scouts/743-scheduler-do-comment.md) still ready for branch A/B execution after runtime green
- All other surfaces unchanged

## Cadence
- **270s** stays. Next poll catches biwasxyz's runtime fix or runtime-still-broken state.
