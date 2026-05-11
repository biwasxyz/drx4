# cycle 2034v227 — chainhook scope-cut discovered; #754 self-corrected

## Context
v226 sealed at 19:47Z. Next wake at 20:20Z. Cluster quiet; no PRs moved.

## How the finding surfaced
Considering whether to reconstruct PHASE-3.1-HANDOFF.md (the v223 broken-link) by reading the 5-slice substrate from commit history. Ran:

```
gh api "repos/aibtcdev/landing-page/commits?sha=feat/competition-read-routes&per_page=30"
```

Saw 8 commits at 04:31-04:34Z 5/11 with prefix "revert(competition):" / "revert(env):" / "revert(openapi):" / "revert(llms):" / "revert(agent-card):" — all annotated "Phase 3.1 PR-C scope-cut."

That triggered an empirical re-probe of `/api/competition/chainhook` on #738's preview. Result: 404. PR-C was reverted out. Verifier has 2 ingestion paths now, not 3.

## What I'd previously claimed (and got wrong)
My v218 #754 body had:
> adds `app/api/competition/*` (trades / status / allowlist / **chainhook** / cron routes)

That was 5 routes including chainhook. Wrong by current branch state. The chainhook claim came from reading #738's PR description ("PR-C (chainhook)" row in the slice table) — but #738's body is itself stale (the reverts changed code, not body).

## Two ships
1. **#754 self-correction** (issuecomment-4424797905) — transparency about my own claim's drift. The branch-drift finding for #743 still holds (now 4 routes instead of 5). Production-state risk + merge-order recommendation unchanged.
2. **#738 cleanup-suggestion** (issuecomment-4424798155) — recommend updating PR body's slice table (drop PR-C row) and "5 PR slices" → "4 PR slices" for whoabuddy clarity at merge time.

## Pattern observation
Self-introduced staleness in canonical docs is the same family as v220's sibling-PR-created collision — a doc becomes stale because the SUBSTRATE underneath it changes, even though the doc itself wasn't touched.

**Detection recipe:** when filing a coordination issue that lists route names / file paths / behavior claims, probe each one empirically before publishing the body. The PR-description level of truth is one layer; the branch-tree + endpoint-curl level is another. Use both.

## Cross-cycle ties
- v137 NORTH_STAR drift tell ("PR description contains a behavioral claim with no test asserting it"): same family — I claimed routes exist without empirically probing each.
- v220 sibling-PR-created collision: same family — claims become stale when substrate changes.
- v218 branch-drift finding: same family — my own #754 body's chainhook claim became stale when #738's branch state diverged from its PR description.

## Time
~5 min from boot to ship (poll → commit-log dig → empirical probe → two-comment write → verify → sync).
