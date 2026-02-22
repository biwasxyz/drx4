# Evolution Log

Track what changed in daemon/loop.md and why. Moved here from loop.md to save context.

| Cycle | Change | Reason |
|-------|--------|--------|
| 0 | Initial version | Created by operator |
| 2 | Added 500-char reply limit note | Got HTTP 400 on long reply |
| 3 | Note: mark-read uses short msg ID, may fail on old msgs | PATCH "not found" error |
| 6 | Added in-session tool/wallet caching optimization | Tools persist, no need to reload each cycle |
| 7 | Switch free endpoints to curl, stop using execute_x402_endpoint | Was auto-paying 100 sats per call on free APIs, 303 unnecessary txs |
| 8 | Reply messageId must use full URL, not short msg_xxx | Short form returns "Message not found" on outbox POST |
| 8 | DO NOT use execute_x402_endpoint for inbox sends | Retry loop bug drains sBTC — filed #141 |
| 8 | Use GH_TOKEN=$GITHUB_PAT_SECRET_MARS for gh CLI as secret-mars | gh CLI defaults to biwasxyz |
| 12 | Skip journal/commit on idle cycles | Don't log "nothing happened" — operator request |
| 14 | Always include live URL in delivery replies | Operator feedback: repo link alone isn't enough |
| 14 | CF deploys use CLOUDFLARE_API_TOKEN from .env | Never push token to git |
| 15 | Added balance-change monitoring to Reflect phase | Must check tx history when balance changes, up or down — operator feedback |
| v2 | Observe-first architecture: gather all state before acting | Learned from arc-starter sensor pattern — prevents reacting to partial info |
| v2 | Structured cycle events instead of free-form reflection | Learned from arc-starter typed event bus — makes debugging and learning systematic |
| v2 | Health file (daemon/health.json) written every cycle | Learned from arc-starter /health endpoint — enables external monitoring |
| v2 | Failure recovery table — never abort cycle on single phase failure | Learned from arc-starter task wrapping with started/completed/failed events |
| v2 | Balance check moved to Observe phase (parallel with heartbeat/inbox) | Was in Reflect — should be observed before deciding, not after |
| v2 | Replies queued in Decide, sent in Deliver (not inline in Inbox phase) | Separation of observation from action — cleaner control flow |
| v2.1 | NEVER reply to task messages before completing the task | Outbox allows only 1 reply per message — premature ack wastes it. Do work first, reply with proof. |
| v2.2 | Added GitHub activity check to Observe phase (2c), every 3rd cycle | Operator feedback: check issues, PRs, and comments on our repos. Not every cycle — too frequent. |
| v2.3 | Added portfolio site update to Evolve phase (7b), every 5th cycle | Operator feedback: keep drx4.xyz reflecting recent work. |
| v2.3 | Wallet may lock during sleep — re-unlock at start of each cycle if needed | Observed wallet locking after 5-min sleep. |
| 27 | Heartbeat timestamp must be fetched fresh (`date -u`), not pre-computed | Stale timestamp rejected after sleep delay |
| v3 | Added Phase 6: Outreach — proactive sends, follow-ups, delegation | Inbox 409 bug fixed (PR #223), send_inbox_message works reliably. Agent was reactive-only; now can initiate conversations, delegate tasks, follow up. |
| v3 | Updated Observe (2b) to detect delegation responses from outbox | Cross-ref incoming messages against outbox.json sent items |
| v3 | Updated Decide (3) with outreach decision logic | Decide when to announce, delegate, or follow up |
| v3 | Updated Execute (4) with delegated task support | New task status "delegated" — skip in queue, handle when response arrives |
| v3 | Budget guardrails: 200 sats/cycle, 1000 sats/day, 1 msg/agent/day | Anti-spam rules to prevent overspending or annoying other agents |
| 42 | Added idle outreach (6c): auto-send after 3+ idle cycles | Operator request: if no activity for 3 cycles, proactively message contacts. Track idle_cycles_count in health.json. |
| 173 | Added agent discovery phase (2d): every 10th cycle, fetch /api/agents, greet new ones | Operator request: discover and greet new AIBTC agents automatically. Budget-respecting, adds to contacts.md. |
| 229 | Periodic journal logging: write summary every 5th cycle even when idle | Operator request: keep journal updated so logs are visible, not just during events. |
| 290 | Agent discovery: paginate through ALL pages, not just page 1 | Was missing agents on pages 2+. Use offset parameter to fetch all 52+ agents. |
| 328 | Idle outreach threshold: 3 cycles → 2 cycles. Reframed as collaboration-focused outreach | Operator directive: grow the network by pulling agents into building together. |
| 328 | Loop bounty program: 1k sats for proper loop-starter-kit implementation. Personalized outreach only. | Operator directive: onboard agents onto the loop. No generic templates ever. |
| 328 | Agent contribution mode: scout repos, file issues, open PRs when idle. Go brrr. | Operator directive: be a real contributor, not just a message sender. |
| 328 | Two-tier idle system: scouting every cycle (free), paid messages after 2 idle. | Do the work first for free, only spend sats to tell agents about work already done. |
| 328 | Tiered memory: hot/warm/cool/cold. Evolution log moved to daemon/evolution-log.md. | Context optimization — loop.md was 651 lines eating context every cycle. |
| 342 | Learnings trigger: write on discoveries/insights, not just failures. Added staleness check (force-write if 10+ cycles). | Learnings.md went 125 cycles (216-341) without update — only triggered on failures, missing operational insights, scouting patterns, agent dynamics. Operator flagged the gap. |
| 354 | Reply JSON template: env vars instead of string interpolation to prevent Python injection. | Self-audit finding #8: untrusted data interpolated into `python3 -c` could enable code injection. |
| 354 | Added Phase 7f (processed.json archiving) and 7g (queue.json archiving) to loop.md. | Self-audit found unbounded growth in both files — no purge logic existed. |
| 354 | Fixed outbox-archive.json creation: added note to create with `{archived:[]}` if missing. | Self-audit finding #5: referenced but never created, could cause JSON parse error. |
| 354 | Removed stale `/root/drx4` path from settings.local.json. | Self-audit finding #1: dead permission entry from previous machine layout. |
| 356 | Reply signature format reminder: `"Inbox Reply | {messageId} | {reply text}"` — NOT just reply text. | Was already documented in loop.md and learnings.md but not followed during cycle 356. Wasted 5 signing attempts before re-reading docs. Added critical reminder to learnings.md. |
