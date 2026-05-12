# Post-merge verification scout for lp#743 SchedulerDO deploy
# v259 scout — run when whoabuddy merges #743 + main CI deploy completes

## Trigger conditions
- lp#743 state = MERGED
- main HEAD advances past `a0b16768`
- main CI "Workers Builds: landing-page" status = SUCCESS on the merge SHA

## Pre-merge checklist items from biwasxyz's 08:42Z comment

1. `wrangler deploy` success in main CI deploy log
2. `tenero.*` events flowing in `logs.aibtc.com` post-deploy
3. ~5 min after first `/leaderboard` visit: Volume column populates
4. Rollback path if regression: v4 `deleted_classes` migration hotfix (same shape as #772)

## v259 verification additions

5. `aibtc.com/api/leaderboard?limit=1` schema unchanged from pre-merge (still level-scoring with `level`/`levelName`/`score` keys) — the SchedulerDO + KV-prices touches `/leaderboard` SSR but should NOT change `/api/leaderboard` semantics
6. `aibtc.com/` returns 200 (production not broken)
7. `aibtc.com/leaderboard` returns 200 + Volume column header present in HTML

## Runnable post-merge probe (~5 lines bash)

```bash
echo "=== aibtc.com sanity ==="
for path in "/" "/leaderboard" "/agents" "/api/leaderboard?limit=1" "/api/competition/trades?docs=1" "/api/competition/allowlist"; do
  RC=$(curl -sS -o /tmp/probe-$$.out -w "%{http_code}" "https://aibtc.com$path")
  echo "$path → $RC"
done

echo "=== /api/leaderboard schema (must match level-scoring) ==="
curl -sS "https://aibtc.com/api/leaderboard?limit=1" | python3 -c "
import json,sys
d=json.load(sys.stdin)
print('top keys:', list(d.keys()))
print('row keys:', list(d['leaderboard'][0].keys()) if d.get('leaderboard') else 'EMPTY')
"

echo "=== /leaderboard HTML semantics ==="
curl -sS "https://aibtc.com/leaderboard" -o /tmp/lb-prod-$$.html
grep -oE '(<title>[^<]+|Volume \(USD|Trades|allPriced|priceUsd)' /tmp/lb-prod-$$.html | head -10
```

## Decision branches at scout-run time

**A. All probes pass + Volume populates after ~5min:** Comment a brief "deploy verified" ack on #743 (post-merge). Close out the SchedulerDO arc publicly.

**B. /api/leaderboard schema changed:** Real regression — flag on #743 + tag biwasxyz + arc. Rollback v4 path discussion.

**C. /leaderboard 404 or 500:** Production-broken regression — flag immediately + tag whoabuddy + biwasxyz with deploy SHA + log line if visible.

**D. Volume column never populates:** SchedulerDO alarm not firing OR Tenero failing. Wait 30min; if still empty, file separate issue with logs.aibtc.com query for `tenero.*` events absent.

**E. Workers Build red on main:** Different rollback path — flag with `wrangler deploy` log line on main if visible.

