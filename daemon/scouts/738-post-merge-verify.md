# Post-merge verification scout for lp#738 (Phase 3.1 verifier + SchedulerDO)
# v298 scout — run when lp#738 merges + Workers Build deploys to production

## Trigger conditions
- lp#738 state = MERGED
- main HEAD advances past `e622849d` (v297 baseline)
- Workers Builds: landing-page → SUCCESS on the merge SHA
- Migration 009 (competition_state) applied via `wrangler d1 migrations apply`

## Pre-merge baseline (verified at v280 scouts/743 + present)

Currently `/api/competition/*` returns **404** (verified at v280 deploy-probe and v298 sweep):
```
GET /api/competition/trades?docs=1 → 404
GET /api/competition/allowlist → 404
GET /api/competition/status → 404 (probably)
```

`/leaderboard` page is live but the **Volume column shows `allPriced: false`** in HTML serialization (no real trade data yet). SchedulerDO v2 is running but only firing the Tenero task at 5min cadence.

## Post-merge runnable probe (~12 lines bash)

```bash
echo "=== /api/competition/* now live (was 404 pre-merge) ==="
for path in "/api/competition/trades?docs=1" "/api/competition/trades?limit=1" "/api/competition/allowlist" "/api/competition/status"; do
  RC=$(curl -sS -o /tmp/probe-$$.out -w "%{http_code}" "https://aibtc.com$path")
  echo "$path → $RC"
done

echo "=== SchedulerDO v2 status reflects competition task ==="
# Admin-key gated; operator-side check only:
# curl -H "X-Admin-Key: $ARC_ADMIN_API_KEY" "https://aibtc.com/api/admin/scheduler?name=v2"
# Expected: status JSON includes `lastCompetitionRunAt`, `lastCompetitionResult`,
#           `consecutiveFailures.competition`, `nextRunAfter.competition`

echo "=== /leaderboard Volume column has real data (after ~15min first competition tick) ==="
curl -sS "https://aibtc.com/leaderboard" -o /tmp/lb-$$.html
grep -oE '"volumeUsd":[0-9.]+|"tradeCount":[0-9]+|allPriced":(true|false)' /tmp/lb-$$.html | head -5

echo "=== Database migration 009 applied ==="
# Operator-side check:
# wrangler d1 execute landing-page --remote --command "SELECT name FROM sqlite_master WHERE type='table' AND name='competition_state'"
# Expected: 1 row returned

echo "=== Probe: post-deploy production sanity ==="
for path in "/" "/leaderboard" "/agents" "/api/leaderboard?limit=1" "/api/openapi.json" "/.well-known/agent.json"; do
  RC=$(curl -sS -o /dev/null -w "%{http_code}" "https://aibtc.com$path")
  echo "$path → $RC"
done
```

**Expected post-merge state matrix:**

| Path | Pre-merge | Post-merge | Note |
|---|---|---|---|
| `/api/competition/trades?limit=1` | 404 | **200** | Schema: { trades, pagination } |
| `/api/competition/trades?docs=1` | 404 | **200** | OpenAPI self-doc |
| `/api/competition/allowlist` | 404 | **200** | Schema: { agents, total } |
| `/api/competition/status` | 404 | **200** | Schema: { lastRunAt, cursor, ... } |
| `/leaderboard` HTML | `allPriced: false` | `allPriced: true` (after ~15min) | First competition tick fires; trade data populates |
| `/api/leaderboard?limit=1` schema | level-scoring | **unchanged** | Sanity that #738 doesn't touch this endpoint |
| `/` | 200 | 200 | Production not broken |

## Decision branches at scout-run time

**A. All /api/competition/* probes return 200 + Volume populates after ~15min:**
- Brief "Phase 3.1 live, deploy verified" ack on lp#738
- Confirm SchedulerDO status includes lastCompetitionRunAt non-null after the first tick
- Cross-reference lp#743 (closed v280) — `/leaderboard` now has real trade data flowing
- Move trade-comp Phase 3.x cluster to "production live" status in repo-org-board v24 patch

**B. /api/competition/* returns 200 but Volume column stays `allPriced: false` after 30min:**
- SchedulerDO competition task not firing — check admin scheduler status for lastCompetitionRunAt
- If `lastCompetitionRunAt: null`: alarm scheduling logic gap (my v297 [observation] applicable)
- If `lastCompetitionResult: { found: 0, scanned: 0 }`: cursor advance issue or verifier scope problem
- File diagnostic issue with the SchedulerDO status payload + the v297 alarm-logic concern

**C. /api/competition/* returns 5xx:**
- Production-broken regression — flag immediately on lp#738 + tag whoabuddy
- Possible: migration 009 not applied (competition_state table missing)
- Rollback path: revert lp#738 OR apply migration 009 manually if it didn't ship in the deploy

**D. /api/leaderboard schema changes:**
- Real regression — flag on lp#738 + cite #743 unchanged-semantics expectation
- Schema drift in either { leaderboard, distribution, pagination } structure or per-row keys

**E. Workers Build red on main:**
- Different rollback path — flag with `wrangler deploy` log line on main

## SchedulerDO operational signal

`runCompetitionScheduler` is supposed to fire every ~15min via the DO alarm. Operator can run `wrangler tail` filtered to scheduler logs to see:
- `competition.scheduler.run_started`
- `competition.scheduler.scanned` (count of trades scanned this tick)
- `competition.scheduler.inserted` (count of new trades inserted)
- `competition.scheduler.cursor_advanced` (cursor moved forward)

Healthy signal: at least one `inserted > 0` event per ~hour during active comp window, OR `cursor_advanced` ticking forward every 15min even when no trades to ingest.

Unhealthy signal: `consecutiveFailures.competition` increasing past 3 → adaptive backoff fired → tick frequency drops. Operator should investigate via admin scheduler status payload.

## Related close-out actions

- Update `daemon/repo-org-board.md` v24 patch with Phase 3.1 live status if branch A
- Volume column verification feeds into lp#743 closure-of-loop (deploy-verified ack already shipped at v280)
- If branch B fires (alarm gap), surface my v297 [observation] as a concrete fix issue (per-task next-run-after gate in alarm() body)
- Retire this scout once branch A or branch C is observed

## Retire

When lp#738 merges + branch A/B/C outcome documented in next cycle's STATE, retire this scout (move to memory/learnings/resolved.md or delete).
