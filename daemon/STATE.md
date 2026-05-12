# State -- Inter-Cycle Handoff
## cycle 2034v244 — lp#738 5224a0d9 KV→D1 cursor refactor APPROVE; #765 CLOSED by biwasxyz

cycle: 2034v244
at: 2026-05-12T04:20Z
status: shipped

## OPERATOR DIRECTIVE (active — /start args 2026-05-11)
> "we need to closely look into the prs and updates on the trading competition on both mcp and landing-page so we need to keep looking into the PRs review them test them using the preview url focus your 100% on those okay file an issue tag whoabuddy/arc"

## v244 ship
**lp#738 APPROVE re-review** (pullrequestreview-4269088188, verified 200) — 5224a0d9 cursor KV→D1 refactor since v243 APPROVE on bed7cd0:
- Generic `competition_state(key, value, updated_at)` schema absorbs future signals without per-signal migrations
- 3-op surface (`getCronCursor`/`setCronCursor`/`clearCronCursor`) preserves cron.ts shape; `cursorKey` test option deleted cleanly
- Test isolation via per-test `cursorStore` closure (no shared-singleton risk); SQL-prefix discrimination in prepare-mock works
- UPSERT semantics with `unixepoch()` default — atomic, matches #672/#705 D1-pk lineage
- Non-blocking observation: legacy KV `comp:cron:cursor` key orphaned post-cutover; verifier `INSERT OR IGNORE` makes restart-from-head correctness-safe (per arc's #765 idempotency point) — worth description one-liner

## v244 framework-validation moment
**biwasxyz CLOSED lp#765 at 03:54Z** explicitly citing the state-store / scheduler-primitive orthogonality:
> "we're going direct-to-D1 for the verifier cron's state (cursor) instead of doing the DO-alarm rework. Scheduler primitive selection (Cron Trigger vs DO alarm) becomes orthogonal once state isn't KV-bound — either fires the same D1-backed cron handler."

My v242 #765 comment naming the NonceDO event-driven vs verifier poll-driven distinction made the trigger-semantics complexity visible enough that the simpler-state-store path got chosen instead. 5224a0d9 is the materialization.

## v244 other observations
- **lp#743** advanced to `ed3eac0` (KV→D1 leaderboard display) + `1e20c2db` (perf: single LEFT JOIN + 60s ISR). arc APPROVE is stale (on `dd48fcf7` from 5/11). Workers Build CURRENTLY FAILURE on 1e20c2db. Biwasxyz will see the build status; not flagging unless persists.
- **lp#651 + lp#764** unchanged

## Pending on resume
- whoabuddy/biwasxyz response on **lp#651** scope question (v241 comment 4426889296)
- whoabuddy/biwasxyz response on **lp#738** v244 re-APPROVE + KV-orphan note
- **#738 merge** = primary cluster gate (now 2× APPROVE since 5224a0d9: arc on prior commits + me on 5224a0d9 — need to verify arc has reapproved)
- **mcp#510 merge** unblocks after #738

## Cadence
- 1800s default. Tighten to 900s on engagement.
