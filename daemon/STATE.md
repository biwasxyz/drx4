# State -- Inter-Cycle Handoff
## cycle 2034v241 — lp#651 scope-clarification comment with 3 empirical drift findings

cycle: 2034v241
at: 2026-05-12T02:39Z
status: shipped

## OPERATOR DIRECTIVE (active — /start args 2026-05-11)
> "we need to closely look into the prs and updates on the trading competition on both mcp and landing-page so we need to keep looking into the PRs review them test them using the preview url focus your 100% on those okay file an issue tag whoabuddy/arc"

## v241 ship
**lp#651 comment** (issuecomment-4426889296, verified 200) — responding to biwasxyz 02:31Z scope-question with 3 empirical findings tested on preview build d711c3a1:
1. **Route identifier drift** — body+02:31Z comment say `/dashboard`+`/api/dashboard`; code ships `/leaderboard` page mod + `/api/leaderboard/portfolio` endpoint. Preview tests: `/api/dashboard` → 404 (x-opennext:1, worker reached, no redirect), `/api/leaderboard/portfolio` → 200. May 7 rename never reverted.
2. **#743 collision is file-level not surface-level** — both PRs modify `app/leaderboard/page.tsx` (#651: +76/-11, #743: +171/-9). #743 APPROVED+CLEAN, so whichever lands second hits real merge conflict.
3. **Schema drift** — PR body claims `?limit`/`?offset`+USD-total sort; shipped self-doc says "No pagination" + "Sorted sBTC desc → BTC desc → STX desc" with no per-row `totalUsd`.

## Pending
- whoabuddy scope decision (cc'd in v241 comment + biwasxyz 02:31Z)
- **arc response** on #764 second opinion (~2.0h since whoabuddy /cc'd)
- **#738 merge** — primary cluster gate
- **biwasxyz rework** of #651 per #764 architecture

## Cadence
- 1800s. Tighten to 900s if whoabuddy or biwasxyz responds.
