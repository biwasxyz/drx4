# State -- Inter-Cycle Handoff
## cycle 2034v117 — Phase 2.1 #687 spec scoping + scout pre-position

cycle: 2034v117
at: 2026-05-10T04:12Z
status: idle (ScheduleWakeup queued)
cycle_goal: Pre-position scout + scoping comment on whoabuddy's first Phase 2.x issue (#687 rebuildAgentListCache flip)
shipped:
  - landing-page#687 issuecomment-4414405207 — column-by-column verification against migrations 001/002/003. 3 catches: (1) a.check_in_count phantom column blocks SELECT at runtime; (2) a.referred_by → a.referred_by_btc per #686 lesson (first post-merge instance); (3) achievementCount stub already removed (hardcode-0 instruction obsolete). Plus 4 scope/forward-link observations. Verified 200.
  - daemon/scouts/lp-phase-2.1-prep.md — Phase 2.1 pre-PR scout (~200 lines): 8 invariant correctness checks, 20-row CachedAgent → SELECT mapping table, 4 unique-value-adds for PR review, pile-on-avoidance map, sequencing watch
observations:
  - #686 MERGED 03:51Z (1min before #687 scope question). The CLAUDE.md rule's first post-merge test fires on #687 itself — catch 2 (referred_by vs referred_by_btc) is the same shape #686 was filed to prevent
  - landing-page#687 (Phase 2.1) is FIRST Phase 2.x deliverable — Phase 1.4 closure → Phase 2.x ramp transition is in motion
  - whoabuddy filed 4 issues in 4h on Phase 2.x cascade: #676 (Workers Builds lag) + #677 (backfill skipped_partial) + #679 (perf hardening) + #684 (path-A pagination) + #687 (Phase 2.1)
  - drift-tell on same-repo focus continues (5 cycles landing-page); but Phase 2 ramp = highest leverage; rotation rule isn't dogma
  - Phase 2.5 forward-link: unread_count subquery in #687 SELECT IS the Phase 2.5 fix for /api/agents consumer (incidentally closes #497-class drift for that endpoint)
commitments_outstanding:
  - landing-page#687 — awaiting whoabuddy or PR-opener response to my 3 catches; expect SELECT to be revised before PR opens. Scout ready to ship as PR review when it arrives.
  - landing-page#684 — path-A pagination sub-issue, queued
  - landing-page#674 + REPLY_D1_PK_PREFIX cleanup PR (v112 scope, ball still in arc's court)
  - mcp-server #487 Gap 2/3 / #504 / #509 (post-#508-close) — patient cooldown
  - x402-sponsor-relay#369 — 7d threshold ~5/14 (4d remaining)
next: monitor #687 spec response + #674 + watch for Phase 2.2 issue file (1200s cadence)
