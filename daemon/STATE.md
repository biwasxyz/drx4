# State -- Inter-Cycle Handoff
## cycle 2034v236 — NonceDO trigger semantic clarification on #764

cycle: 2034v236
at: 2026-05-12T01:07Z
status: shipped (follow-up clarification)

## OPERATOR DIRECTIVE (active — /start args 2026-05-11)
> "we need to closely look into the prs and updates on the trading competition on both mcp and landing-page so we need to keep looking into the PRs review them test them using the preview url focus your 100% on those okay file an issue tag whoabuddy/arc"

## v236 ship
**landing-page#764 issuecomment-4426399994** — tight follow-up to my v235 second opinion. Deeper read of `nonce-do.ts` empirically validates a real difference between NonceDO and #764's proposed adaptive-interval logic:
- **NonceDO** = state-driven (`ALARM_INTERVAL_ACTIVE_MS = 60s` when `assigned > 0`; `IDLE = 5min`). Trigger: "wallet busy?"
- **#764** = failure-driven (ACTIVE healthy ~2min; IDLE ~10min after upstream failures). Trigger: circuit-breaker on 429s
- Different semantic; both valid; using same alarm-rescheduling primitive

Named 3 trigger flavors (state / failure / work) for `VerifierSweepDO` design. Cleans up an implicit claim in my v235 ("matches NonceDO") that turned out to be speculative — actual NonceDO doesn't use observation-based triggering.

This is self-correction discipline (v228/v227 family — own canonical doc drifted from empirical reality). Caught and corrected within 16 min.

## v236 SHA-verified state
| Surface | SHA | |
|---|---|---|
| All 6 trading-comp PRs | unchanged | OPEN, mergeable |
| #764 | 2 comments (mine v235 + v236) | OPEN |
| arc / biwasxyz response on #764 | none yet | ~30 min since first /cc |
| main HEAD | `3dc8994d` | unchanged 5.8h+ |

## Pending on resume
- **arc response on #764** — still pending, ~30 min since /cc
- **biwasxyz response** to #764 implications for #651 rework
- **#738 merge** — primary gate still
- **#651 rework** by biwasxyz to consume #764 architecture

## Cadence
- Holding 900s — cluster active, arc may respond shortly.
