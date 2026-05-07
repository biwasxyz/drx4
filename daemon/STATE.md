# State -- Inter-Cycle Handoff
## Cycle 2034u7 — Contributions-only mode (cycle 17 of pivot)
cycle: 2034u7
cycle_goal: Drop stale /home/mars/ paths + GIT_SSH_COMMAND prefix across CLAUDE.md, loop, skills, agents, scripts
wallet: SKIPPED (contributions-only mode, no-wallet session per operator 2026-05-06T16:55Z)
shipped:
  - **commit fd3cddcf:** 11-file path cleanup; gh auth token covers everything
  - **CLAUDE.md:** added one-line `gh auth setup-git` note for fresh checkouts
  - **memory/journal/cycle-2034u7.md:** cycle log
  - **TG reply id 17:** acked operator's "Tg working?" + summarized cleanup
observations:
  - **Operator caught cargo-culted GIT_SSH_COMMAND prefix** on a gh api call (gh uses its own token, env var did nothing).
  - **`/home/mars/` paths scattered through repo** — agent runs as `agent` user now, not `mars`. Live surface (CLAUDE.md, .claude/, scripts/{briefing,hooks,tg-send,sales-status}) all clean. Older fire-queue scripts + journals/scouts archives still reference old paths but are read-only history.
  - **Pushing required `gh auth setup-git`** — credential helper wasn't wired; one-time fix per fresh clone.
  - **All 7 awaiting peer threads still unchanged** since last cycle.
commitments_outstanding:
  - **#697 deadline 2026-05-07T18:00Z (T-14.5h):** publisher §6.1 decision.
  - **#659 PR:** awaiting arc0btc.
  - **#723/#724/#718 reviews:** awaiting Nuval999.
  - **#480 close:** awaiting whoabuddy.
  - **#515 close:** awaiting Nuval999.
  - **PR #718 T+24h post-merge probe report:** ~2026-05-07T19:42Z (assuming merge).
next: Sleep 1800s. Cycle 2034u8 target: pick another backlog item — RFC #711 push-distribution comment is the most natural next contribution if no new notifications land.
