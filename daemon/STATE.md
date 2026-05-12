# State -- Inter-Cycle Handoff
## cycle 2034v256 — production restored via #772; v254 hypothesis #2 (migration-tag conflict) was root cause

cycle: 2034v256
at: 2026-05-12T08:36Z
status: shipped (reaction-ack on #772, no GH comment)

## OPERATOR DIRECTIVE (active — /start args 2026-05-11)
> "we need to closely look into the prs and updates on the trading competition on both mcp and landing-page so we need to keep looking into the PRs review them test them using the preview url focus your 100% on those okay file an issue tag whoabuddy/arc"

## v256 production-incident-resolution observation
biwasxyz filed + merged **#772 to main** at 08:30Z: "fix(wrangler): add v2 deleted_classes migration for SchedulerDO"

Per #772 PR body diagnostic narrative: during PR #743 work earlier today, biwasxyz temporarily flipped the deploy command from `wrangler versions upload` to `wrangler deploy --env preview`. Cloudflare Workers Builds **overrode** the `--env preview` worker name from `landing-page-preview` back to `landing-page` (production). Result: v1 SchedulerDO migration applied to production, leaving an orphaned namespace registration on `aibtc.com` that the rollback couldn't undo (CF refused: "version depends on Durable Object migration ... but current deployment is using migration v1").

The fix is a forward v2 `deleted_classes` migration that cleans up the orphan. Verified post-merge:
- aibtc.com/ → 200
- aibtc.com/leaderboard → 307 (redirect)
- aibtc.com/api/leaderboard?limit=1 → 200
- aibtc.com/agents → 200

So production is restored from main + #772.

## v254 hypothesis #2 VALIDATED
My v254 issuecomment-4428573313 listed 2 hypotheses for the persistent runtime 404:
1. DurableObject base class still stripped despite inline (cause-class A)
2. **Migration-tag conflict surfaced once the class registered (cause-class B)** ← THIS WAS THE ACTUAL ROOT CAUSE

biwasxyz's #772 PR body confirms cause-class B verbatim: "v1 SchedulerDO migration was applied to the production worker, not the intended preview worker." The migration-tag conflict was real; just not the conflict-shape I described (I guessed OpenNext-managed-DO collision, actual was preview-vs-production target confusion in deploy command).

## v256 ship
- **+1 reaction** on biwasxyz's #772 PR — closes diagnostic loop without comment noise
- STATE narrative + learning observations
- No new GH comment

## v256 PR #743 forward path (per #772 body)
> "PR #743 remains open; its scheduler work needs to be revisited as a clean follow-up (likely with the class definition inline at the entry point, plus a fresh migration v3 reintroducing it)."

Concrete next steps biwasxyz outlined:
1. Rebase #743 onto main (pick up v2 deleted_classes)
2. Add v3 new_sqlite_classes migration to reintroduce SchedulerDO

## v256 boot SHA-compare
- lp#651 unchanged d711c3a1
- lp#738 unchanged 5224a0d9 (still awaiting arc/whoabuddy approve)
- lp#743 a6f0ffb0 (broken, awaiting biwasxyz refactor)
- mcp#510 521c2466 (chained behind #738)
- **main lp HEAD: a0b16768** (advanced via #772 — production restored)

## Pending on resume — next cycle (900s)
- biwasxyz refactor on lp#743 (rebase + v3 migration)
- arc/whoabuddy approve on lp#738
- Any other movement

## Cadence
- **900s stays** — biwasxyz just merged #772; may now refocus on #743. 900s catches.
