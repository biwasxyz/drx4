# State -- Inter-Cycle Handoff
## cycle 2034v264 — stale-APPROVE-carry-forward observation; v264 learning codified

cycle: 2034v264
at: 2026-05-12T12:05Z
status: shipped (learning codified, no GH action)

## OPERATOR DIRECTIVE (active — /start args 2026-05-11)
> "we need to closely look into the prs and updates on the trading competition on both mcp and landing-page so we need to keep looking into the PRs review them test them using the preview url focus your 100% on those okay file an issue tag whoabuddy/arc"

## v264 observation — arc's APPROVE staleness

Checked arc's review history across the trading-comp cluster:

| PR | Latest arc APPROVE | Current SHA | reviewDecision | Staleness |
|---|---|---|---|---|
| lp#738 | `d3d0afeb` (5/11 04:32Z) | `5224a0d9` | **empty** | ~32h + many architectural commits |
| lp#743 | `dd48fcf7` (5/11 08:47Z) | `46e6badb` | APPROVED (carry-forward) | ~28h + SchedulerDO full rebase |

Both arc APPROVEs pre-date substantial commits. lp#738's reviewDecision is empty (branch protection invalidated); lp#743 shows APPROVED via stale-ancestor carry-forward. **A non-empty reviewDecision=APPROVED is NOT a reliable signal of fresh review on the current SHA.**

## v264 ship — learning codified
**v264 stale-APPROVE-carry-forward learning** (~35 lines in memory/learnings/active.md):
- Observation: GitHub's reviewDecision can carry forward stale APPROVEs depending on branch protection
- Operational rule: when tracking PR merge-readiness, record both reviewDecision AND most-recent-approver-SHA; the diff is the real "review staleness" signal
- Cross-tied to v228 (SHA-compare-at-boot precision pattern)
- Verification snippet for finding the most-recent APPROVE's commit_id

## v264 hard-wait state (7 thin-ship cycles)
- All comp surfaces unchanged since v258
- Operator silent on v261 cadence menu (1.6h+)
- Maintainer idle clock:
  - biwasxyz 200+ min (3.4h) since 08:42Z
  - whoabuddy 3.6h since #772 merge
  - arc 8.7h since mcp#510 (arc's actual APPROVE on lp#738 was 32h+ ago)

## v264 boot SHA-compare (no change since v258)
- lp#651 d711c3a1 BLOCKED
- lp#738 5224a0d9 CLEAN, my APPROVE×5 on this SHA, arc stale on d3d0afeb
- lp#743 46e6badb DIRTY, my APPROVE on this SHA, arc stale on dd48fcf7
- mcp#510 521c2466 chained
- main lp HEAD a0b16768

## Pending on resume — next cycle (1800s)
- Operator response to v261 cadence menu (still pending)
- arc fresh APPROVE on lp#738 5224a0d9 (would unblock the merge path)
- whoabuddy merge actions
- biwasxyz scope decision on lp#651

## Cadence
- **1800s stays** — sustained hard-wait. Default A from operator menu.
