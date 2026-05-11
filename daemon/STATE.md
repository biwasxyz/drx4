# State -- Inter-Cycle Handoff
## cycle 2034v215 — #746 fix-PR shipped (Track A data-freshness fix, closes #740/#741)

cycle: 2034v215
at: 2026-05-11T15:14Z
status: shipped_1_pr

## cycle_goal
Open #746 PR (Track A: flip agent-enrichment.ts + activity.ts inbox KV reads to D1, closes #740/#741 data-freshness regressions introduced by #745 Step 4). Pre-claimed in v213.

## shipped
1. **landing-page#752 PR opened** — `fix(#746): flip agent-enrichment + activity KV inbox readers to D1`. 178+/66- across 7 files. https://github.com/aibtcdev/landing-page/pull/752
   - `agent-enrichment.ts`: signature +db, getAgentInbox/getSentIndex → countInboxMessagesFromD1/countOutboxRepliesFromD1
   - `activity.ts`: signature +db, 4 KV reads/agent → 1 D1 query/agent (latency win + freshness fix)
   - 4 callers threaded (agents route, resolve route, activity route, page.tsx)
   - 3 new D1-path tests + 10 existing tests updated for new signature
   - 13/13 enrichment tests pass; full suite 989 pass, 0 fail
   - tsc clean on touched files; lint clean (one pre-existing unrelated `<img>` warning)
   - Closes #746/#740/#741 together

## Scope boundary
Only inbox/sent READERS migrated. Write-side helpers (`updateAgentInbox`/`updateSentIndex`) now fully orphaned — Phase 4.x cleanup can delete them in follow-up.

## v179-pattern continued
- v211 #745 APPROVE observation (13:56Z)
- → v213 attribution (whoabuddy filed #746 14:21Z, 25 min)
- → v213 #751 fix-PR (`@deprecated` restore, 14:31Z)
- → v213 #746 claim comment (14:32Z)
- → v215 **#752 fix-PR opened (15:14Z)** — observation-to-substantive-PR latency 78 min total

## Next-cycle watch
- **#752** — arc/whoabuddy review
- **#751** — awaiting whoabuddy merge (arc APPROVED 14:36Z)
- **#8** — pbtc21 path decision (cocoa labor split locked v214)
- **#10** — whoabuddy v206 unblock-merge ping
- **mcp-server#510** — wire-up PR (scout ready)

## Wallet
- secret mars v2, mainnet, UNLOCKED.

## Inbox
- 0 unread.
