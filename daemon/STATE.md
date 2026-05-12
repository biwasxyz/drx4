# State -- Inter-Cycle Handoff
## cycle 2034v252 — throttle-hold, biwasxyz iterating; chore-rebuild didn't fix runtime 404

cycle: 2034v252
at: 2026-05-12T07:42Z
status: shipped (no GH comment this cycle — throttle in effect)

## OPERATOR DIRECTIVE (active — /start args 2026-05-11)
> "we need to closely look into the prs and updates on the trading competition on both mcp and landing-page so we need to keep looking into the PRs review them test them using the preview url focus your 100% on those okay file an issue tag whoabuddy/arc"

## v252 observation (no ship)
**biwasxyz pushed `f59cf453` at 07:37Z** — empty/chore commit "rebuild to exercise versions upload + get branch preview URL". Build green at 07:39Z (3rd consecutive success on f59cf453 after 62fb3b09×2). But routes STILL 404 with `x-preview-user-error: true`:
- biwasxyz tried to fix the issue by triggering a rebuild
- The rebuild succeeded but didn't change behavior (since the commit was a no-op)
- Confirms the issue is in the code, not CF's URL provisioning

## v252 static-analysis observations
Read worker.ts + scheduler-do.ts + page.tsx (62fb3b09 patch) more carefully:
- worker.ts shallow: imports SchedulerDO and re-exports (fine)
- scheduler-do.ts top-level: imports DurableObject from cloudflare:workers + tenero clients + logging + 4 constants — nothing should throw at module load
- The opportunistic kick in page.tsx IS guarded with `try { if (env.SCHEDULER) { ... .status().catch(...) } } catch {}` — well-bounded, can't 404 every route
- The SchedulerDO constructor calls `blockConcurrencyWhile` but fire-and-forget; can't block the worker

So the universal 404 must be in compile/bundle-time machinery (e.g., OpenNext.js bundling failing to handle `cloudflare:workers` DurableObject import) OR in some side effect I haven't read. Without dash trace access, can't pinpoint further.

## v252 throttle reasoning
- v246 doc-nit on #738
- v250 deploy-fail flag on #743 (~28min ago)
- v251 runtime-404 flag on #743 (~6min ago)
- Adding a v252 cause-hypothesis comment now = 3rd comment on #743 in 16 min — pile-on territory
- Better: let biwasxyz iterate. They have my diagnosis pointers from v251 + dash trace access I don't have.
- Per v248 learning: max 1 nit per PR per ~30min session window

## v252 boot SHA-compare
- lp#651 unchanged d711c3a1
- lp#738 unchanged 5224a0d9
- lp#743 f59cf453 (chore rebuild on top of 62fb3b09; still runtime-broken)
- mcp#510 unchanged 521c2466
- main lp HEAD unchanged 45e70f94

## Pending on resume — next cycle (270s tight)
- biwasxyz fix-push or response to v251
- biwasxyz may consult dash trace and fix
- Pre-staged scout (daemon/scouts/743-scheduler-do-comment.md) still ready for branch A/B once runtime stabilizes
- All other surfaces unchanged

## Cadence
- **270s** stays. Cache stays warm; next poll catches biwasxyz iteration.
