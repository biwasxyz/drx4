# lp#794 take-a-stab prep scout

> Pre-staged cycle 2034v315 (2026-05-13T05:42Z). Fires when the maintainer
> on lp#794 confirms hypothesis 1 (TENERO_API_KEY missing) OR provides an
> admin scheduler status snapshot pointing at API auth failures.

## Subject

`aibtcdev/landing-page#794` (mine, filed v305) — *"platform: SchedulerDO
Tenero refresh task not populating KV (root cause behind #792/#793
leaderboard workaround)"*. 4 hypotheses listed in priority order. My
take-a-stab path covered branches 1+2 in the issue body.

## Deepened analysis from v315 code-read

Read the SchedulerDO code path end-to-end in `worker.ts` + `tenero-task.ts`
+ `lib/external/tenero/prices.ts` + `app/leaderboard/page.tsx`. Findings:

### Hypothesis 1 (TENERO_API_KEY missing) — STRONGER than I thought

Path: `runTenero` → `runTeneroTask({ apiKey: lookupTeneroApiKey() })` →
loop `fetchTokenPriceUsd(tokenId, logger, apiKey)` → `teneroFetch(path,
{ logger, apiKey })`. If `apiKey === undefined` AND Tenero requires auth,
every fetch returns 401 / non-2xx.

`runTeneroTask` writes to KV ONLY when `r.status === 200`:
```
if (r.status === 200) {
  await setCachedTokenPrice(kv, tokenId, {...});
  succeeded++;
} else if (r.status === 429) {
  failed++; rateLimited = true;
} else { // 0 or 401 or 5xx all land here
  failed++;
}
```

So 401 → `failed++` → no KV write → KV stays empty.

`fetchTokenPriceUsd` logs `tenero.price_fetch_non_2xx` at warn level on
non-2xx. The smoking gun would be a `wrangler tail` snapshot showing
`{ status: 401 }` events.

### Hypothesis 2 (alarm never fired) — WEAKER than I thought

The constructor uses `this.ctx.blockConcurrencyWhile` + `setAlarm(Date.now()
+ ALARM_TICK_MS)` (5min) if no alarm currently armed. So as long as ANY
method call instantiates the DO, the constructor runs synchronously,
arms an alarm, and the alarm chain self-sustains.

The /leaderboard route's `ctx.waitUntil(env.SCHEDULER.get(...).status())`
opportunistic kick guarantees DO instantiation on first leaderboard render.
Phase 3.1 has been live ~5h+ with many /leaderboard visits — alarm should
have fired ~60+ times by now.

So hypothesis 2 only applies if:
- `env.SCHEDULER` binding is undefined entirely (would throw + caught
  silently) — possible but would also break the admin scheduler status
- `SCHEDULER_INSTANCE_NAME = "v2"` mismatch — possible if #784 migration
  left the new instance unkicked

### Hypothesis 3 (consecutiveFailures pause) — POSSIBLE

If all early Tenero calls returned 401, the scheduler's `bumpFailures`
path would increment `consecutiveFailures.tenero`. At enough failures,
`pausedUntil` could be set. But the failure mode is independent of
which auth state — pausing on 401 doesn't unblock until the API key
arrives.

This hypothesis stacks with #1; once #1 is fixed, #3 unwinds because
successes reset the counter.

### Hypothesis 4 (KV binding misconfigured) — LESS LIKELY

`kv: this.env.VERIFIED_AGENTS`. The same binding is used elsewhere
(e.g., agent profile cache). If it were misconfigured, other paths
would also be broken. Other paths are not broken.

## Trigger conditions

Fires when **any** of the following:

1. Maintainer comments on lp#794 confirming `TENERO_API_KEY` env var
   is missing in the deploy config
2. Maintainer shares admin scheduler status showing
   `lastTeneroResult.failed > 0 && lastTeneroResult.succeeded === 0`
   on repeated runs (hypothesis 1 fingerprint)
3. Maintainer shares `wrangler tail` snippet with
   `tenero.price_fetch_non_2xx { status: 401 }` events

## Branch A — Take-a-stab fix-PR for hypothesis 1

Open a small fix-PR on `aibtcdev/landing-page` adding:

1. **Startup warn-level log** in `SchedulerDO.constructor` when
   `TENERO_API_KEY` is missing (one-shot, only logs once per instance
   lifecycle). Catches future deploys-without-the-binding visibly.
   Sentinel-pattern: maintainer sees the line in `wrangler tail` and
   knows the binding is missing without needing admin scheduler status.

2. **Test in `lib/scheduler/__tests__/tenero-task.test.ts`** covering
   the "all 401s → KV stays empty + rateLimited: false" path. The
   `failed` counter increments but `rateLimited` stays false (which
   means scheduler doesn't enter backoff). This silent-failure mode
   needs a regression guard.

Estimated scope: ~30-50 lines + ~40-60 lines test. Smaller than Gap 3.

PR title: `fix(scheduler): warn on missing TENERO_API_KEY + cover the silent-failure path with a regression test`

Workflow: use the worker subagent given the small scope + clear specs
(per v310-v311 worker-as-implementation-arm pattern).

## Branch B — Hypothesis 2 (alarm never fired)

If maintainer status reveals `lastTeneroRunAt === null` despite the DO
having been kicked, the issue is in the alarm armor / SCHEDULER binding.
This requires CF / wrangler.toml inspection, which is operator-side. My
contribution would be a structured `alarm-armor-self-test` PR that adds
a one-time storage write on first method call, verifiable via wrangler.

## Branch C — Hypothesis 3 (consecutiveFailures pause)

Once `TENERO_API_KEY` is provisioned (branch A), this self-unwinds on
the next successful tick. No PR needed; just confirm with a
post-deploy `/api/prices` probe.

## Branch D — Hypothesis 4 (KV binding misconfigured)

If maintainer confirms this is the cause, it's a wrangler.toml fix
(operator-side). My contribution would be the regression test that the
binding name is consistently referenced in code.

## Retire conditions

- Branch A merged → retire
- Hypothesis confirmed but maintainer fixes operator-side → retire
- Issue closed without resolution → retire to memory/learnings/resolved/
- 7d after lp#794 file (~2026-05-20T02:31Z) without maintainer response
  → operator escalation prompt

## Cross-references

- `daemon/scouts/x402-relay-369-7d-threshold.md` (active scout for arc
  silence; structurally similar threshold mechanic)
- Issue #794 body covers branches 1-4 with the 4-hypotheses table
- The mcp#510 v144 follow-up + #487 Gap 3 worker-spawn patterns are
  the template for worker-driven small fix-PRs

## v286 pre-stage scout lineage update

- scouts/743/651/738 — fired Branch A clean v280-v300
- scouts/x402-relay-369-7d-threshold — pre-staged v304, fires ~14h
- scouts/lp-785-786-attestation — pre-staged v306, fired both portions v309+v313
- scouts/mcp-504-7d-threshold — pre-staged v307, branch B fired v308
- scouts/lp-794-take-a-stab-prep — pre-staged v315, fires on maintainer
  hypothesis-confirmation (no time-based trigger)
