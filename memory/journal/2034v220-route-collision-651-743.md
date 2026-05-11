# cycle 2034v220 — second collision surfaced: #651 + #743 both target /leaderboard

## Context
v219 ack at 16:23Z. Next wake at 16:40Z. Polled cluster for #738 merge action.

## Findings
1. **Cluster blocked on whoabuddy** — #738 hasn't moved in 7+ hours; everything downstream waits. No merge during the v219→v220 window.
2. **Second collision surfaced** while verifying #651 substrate (originally for "did the cold-miss-poll-budget commit happen post-my-APPROVE?"). Both #651 and #743 modify `app/leaderboard/page.tsx`:
   - #651 → balance-ranked Genesis leaderboard (sBTC/BTC/STX) via `getDashboardSnapshot`
   - #743 → MCP-trade-count leaderboard via D1 `swaps` query
3. Same route, same title metadata, divergent designs. Merge conflict guaranteed on whichever merges second.

## Timeline reconstruction
- 05:08:14Z `79d1a116` — #651 renames `/dashboard → /leaderboard`. Route uniquely owned by #651.
- 05:29:16Z — my APPROVE on #651 head `d711c3a1`. Collision didn't exist yet.
- 09:08:48Z `92b37cd4` — #743 pivot introduces its own /leaderboard page (the post-v201 architectural pivot to client-side Tenero).
- Collision created here. Lay dormant until v220 verification check.

## Why this didn't surface at #651 review time
- At 05:29Z when I APPROVED #651, /leaderboard route was uniquely owned by #651. No collision detectable.
- The collision was created LATER by biwasxyz's #743 pivot at 09:08Z (4h after my APPROVE).
- This is a NEW class of drift: **collision created by sibling-PR mutation after the first PR was already approved.** Not detectable by review-time discipline alone — requires post-merge or cluster-wide periodic verification.

## What I shipped
1. #754 issuecomment-4422764531 — full analysis + 3-resolution menu + coordination with v218 merge-order chain.
2. #651 issuecomment-4422766463 — cross-link to #754 second finding.
3. #743 issuecomment-4422766762 — cross-link to #754 second finding.

## Why one issue, two findings
v218's directive was "file ONE consolidated issue". v220's second finding is the same family (cross-PR coordination gap on trading-comp cluster), just a different mechanism (route collision vs branch drift). Adding to #754 honors the consolidation directive AND gives arc/whoabuddy a single thread to track.

## Pattern observation (worth codifying after a few more instances)
**"Sibling-PR-created collision"**: a PR is approved + mergeable; a sibling PR mutates such that they collide on a file; the original approval is now stale not because the original PR changed, but because its sibling did. The first PR's review state ("APPROVED + mergeable") becomes a stale judgment.

Detection: at cycle-boot for any approved-mergeable PR in a cluster, grep sibling PR file lists for path overlap. If any overlap on key files (route handlers, page components, lib helpers), flag for re-review.

## Time
~6 min from boot to ship (poll → collision discovery → analysis → three comments → verify).
