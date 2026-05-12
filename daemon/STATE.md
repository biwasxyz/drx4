# State -- Inter-Cycle Handoff
## cycle 2034v247 — lp#768 SchedulerDO design comment (two orthogonal adaptive directions)

cycle: 2034v247
at: 2026-05-12T06:08Z
status: shipped

## OPERATOR DIRECTIVE (active — /start args 2026-05-11)
> "we need to closely look into the prs and updates on the trading competition on both mcp and landing-page so we need to keep looking into the PRs review them test them using the preview url focus your 100% on those okay file an issue tag whoabuddy/arc"

## v247 ship
**lp#768 substantive comment** (issuecomment-4427782271, verified 200) — whoabuddy filed lp#768 at 05:33Z bundling Tenero prices + competition Hiro sweep under one `SchedulerDO`, explicit cc to me + biwasxyz. Direct continuation of my v242/v244 architectural thread. 3 findings + 1 cross-PR clarification:

1. **Two orthogonal adaptive directions worth naming**: my v242 finding (find-rate-based ACTIVE/IDLE from below) vs whoabuddy's Option C (rate-limit-based back-off ceiling from above). These compose — Tenero stays at 5-min floor unless 429-throttled; verifier sweep stays at 15-min floor unless ALSO speeding up post-comp-start when find-rate fires. Worth tracking both signals in lastTeneroResult/lastSweepResult.
2. **Open Q3 (keep `/api/competition/cron`)**: vote keep as thin RPC pass-through — same direction as my v244 #738 + my v242 #765 + arc's idempotency point. Recovery-layer insurance against stuck DO.
3. **#743 412f91ff is the stepping stone**: current server-side D1 + ISR + browser-side Tenero composition is the first half of the 2-step ramp; KV-backed `/api/prices` after SchedulerDO lands is the second half. No architectural rework needed.
4. **Cross-PR clarification on chainhook single-writer claim**: data-layer idempotency via INSERT OR IGNORE on (txid) already handles user/cron/chainhook concurrency; DO single-writer is for cursor consistency, not row collision — worth being explicit which property protects what.

## v247 boot SHA-compare
- All comp surfaces unchanged since v246 (lp#651, lp#738/5224a0d9, lp#743/412f91ff, mcp#510/521c2466)
- main lp HEAD unchanged 60622b2f; main mcp unchanged 19c89f3e
- v246 doc-drift comment on #738 (issuecomment-4427595315) no maintainer response yet

## Architectural thread now spans (chronologically)
- #764 (whoabuddy filed, my v218+v220 second-opinion on NonceDO + trigger semantics)
- #765 (biwasxyz filed → my v242 trigger-semantics-distinction → biwasxyz closed v244, pivoted to D1 cursor)
- #738 5224a0d9 (the D1 cursor materialization, my v244 APPROVE + v246 doc-nit)
- #768 (whoabuddy filed scope-broadening to two-task SchedulerDO + my v247 comment)

## Pending on resume
- whoabuddy/biwasxyz response on **lp#768** scheduler design — implementation PR ahead
- arc re-review on **lp#738 5224a0d9** + my v246 doc-drift
- arc re-review on **lp#743 412f91ff** (stale APPROVE on dd48fcf7)
- whoabuddy/biwasxyz response on **lp#651** scope question (v241)
- **#738 merge** = primary gate; **mcp#510 merge** unblocks after

## Cadence
- 1800s. Tighten to 900s on engagement (especially if SchedulerDO PR opens).
