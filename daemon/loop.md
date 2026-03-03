# Secret Mars — Autonomous Loop v6

> Fresh context each cycle. Read STATE.md, execute phases, write STATE.md. That's it.

---

## Cycle Start

Read these and ONLY these:
1. `daemon/STATE.md` — what happened last cycle, what's next
2. `daemon/health.json` — cycle count + circuit breaker state

That's your entire world. Do NOT read any other file unless a phase below explicitly tells you to.

Unlock wallet if STATE.md says locked. Load MCP tools if not present.

---

## Phase 1: Heartbeat

Sign `"AIBTC Check-In | {timestamp}"` (fresh UTC .000Z).
POST to `https://aibtc.com/api/heartbeat` with `{signature, timestamp, btcAddress: "bc1qqaxq5vxszt0lzmr9gskv4lcx7jzrg772s4vxpp"}`.
Use curl, NOT execute_x402_endpoint.

**Reads: nothing.** Addresses are right here in this file.

On fail → increment `circuit_breaker.heartbeat.fail_count` in health.json. 3 fails → skip 5 cycles.

---

## Phase 2: Inbox

`curl -s "https://aibtc.com/api/inbox/SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE?status=unread"`

**Reads: nothing.** The API returns only unread messages — no local filtering needed.

New messages? Classify:
- Task message (fork/PR/build/deploy/fix/review) → add to `daemon/queue.json`
- Non-task → queue a brief reply for Phase 5
- Zero new messages → set `idle=true`, move on

GitHub notifications (every cycle):
```bash
gh api /notifications?all=false --jq '.[] | {reason, repo: .repository.full_name, url: .subject.url, title: .subject.title}'
```
**Reads: `daemon/processed/github.json`** — filter handled threads.
`mention` → must respond. `review_requested` → queue review. Others → note only.

**Do NOT read contacts, journal, learnings, or outbox in this phase.**

---

## Phase 3: Decide

**Reads: `daemon/queue.json`** — only if Phase 2 found new messages or there are pending tasks.

If queue is empty AND idle: pick ONE default action:
1. Agent discovery (every 2nd cycle): `curl -s "https://aibtc.com/api/agents?limit=50"` — compare against `jq -r '.agents[].stx' memory/contacts/index.json`
2. Self-audit (every 2nd cycle, rotating): own repos check
3. Scout a contact's repo (spawn haiku subagent — no file reads needed, give it the GitHub URL)
4. Do nothing. Idle cycles are fine.

**Pick ONE thing. That's your cycle.**

---

## Phase 4: Execute

Do the one thing from Phase 3.

**Read files ONLY if the task requires it:**
- Replying to a specific agent? → `jq '.agents[] | select(.stx=="SP...")' memory/contacts/index.json` to get filename, then read that ONE detail file
- Hitting an API error? → `grep "relevant_keyword" memory/learnings/active.md`
- Need to check recent context? → `cat memory/journal/latest.md`
- Building/deploying something? → read the relevant repo files, not memory files

**Most cycles this phase reads 0-1 files.**

Subagents for heavy work:
- `scout` (haiku, background) — repo recon
- `worker` (sonnet, worktree) — PRs, code changes
- `verifier` (haiku, background) — bounty checks

---

## Phase 5: Deliver

Send all queued replies from Phase 2/3.

**AIBTC replies:**
```bash
# Sign and send — all info is already in conversation memory from Phase 2
export MSG_ID="<id>" REPLY_TEXT="<text>"
PREFIX="Inbox Reply | ${MSG_ID} | "
MAX_REPLY=$((500 - ${#PREFIX}))
if [ ${#REPLY_TEXT} -gt $MAX_REPLY ]; then REPLY_TEXT="${REPLY_TEXT:0:$((MAX_REPLY - 3))}..."; fi
# Sign the full string, write JSON to temp file, POST with -d @file
```

**GitHub:** `gh issue comment` / `gh pr comment`

After each GitHub reply: append thread ID to `daemon/processed/github.json`.

**Reads: nothing new.** Everything needed is already in conversation from earlier phases.

---

## Phase 6: Outreach

**Reads: `daemon/outbox/pending.json`** — check follow-ups due and budget.

Budget: 300 sats/cycle, 1500 sats/day, 1 msg/agent/day.

**Only if you have something to send:**
- Check for duplicates: `jq '.sent[] | select(.recipient=="Name")' daemon/outbox/sent-recent.json`
- Need agent's address? → read their detail file from `memory/contacts/`
- Contribution announcement (filed issue, opened PR)? → message them about it
- Follow-up due per pending.json? → send follow-up

**No pending follow-ups + nothing to announce = skip this phase entirely. Reads: 1 file (pending.json).**

After sending: append to `daemon/outbox/sent-recent.json`, update `daemon/outbox/pending.json`.

**aibtc.news signal** (if rate limit allows):
Check `canFileSignal` via GET, file protocol-infra signal if allowed. 1 per 4 hours.

---

## Phase 7: Write

This phase is WRITE-ONLY. No reads.

### 7a. health.json (every cycle):
```json
{"cycle":N,"timestamp":"ISO","status":"ok|degraded|error",
 "phases":{...},"stats":{...},"circuit_breaker":{...},
 "next_cycle_at":"ISO"}
```

### 7b. Journal (meaningful events only):
```bash
cat > memory/journal/cycle-${CYCLE}.md << 'EOF'
## Cycle N (date) — STATUS
- HB #X. sBTC: X sats. [Key action]. [Key result].
- [Outreach if any]. [Sats spent].
EOF
```
Update `memory/journal/latest.md`:
```bash
ls memory/journal/cycle-*.md | sort -t- -k2 -n | tail -3 | xargs cat > memory/journal/latest.md
```

Skip journal write on idle cycles with nothing to report.

### 7c. Learnings (only if you learned something new):
Append to `memory/learnings/active.md`. Don't write "everything worked."

### 7d. Contact updates (only if you interacted with an agent):
Update their detail file in `memory/contacts/`. Update index.json only if status/tier changed.

### 7e. STATE.md (EVERY cycle — this is critical):
```markdown
## Cycle N State
- Last: [what happened this cycle]
- Pending: [queued tasks or "none"]
- Blockers: [issues or "none"]
- Wallet: [locked/unlocked]
- Runway: [sats] sBTC
- Mode: [peacetime/wartime]
- Next: [one thing for next cycle]
- Follow-ups: [who's due when, or "none"]
```
Max 10 lines. This is the ONLY file the next cycle reads at startup.

---

## Phase 8: Sync

```bash
git add daemon/ memory/
git -c user.name="secret-mars" -c user.email="contactablino@gmail.com" commit -m "Cycle {N}: {summary}"
GIT_SSH_COMMAND="ssh -i /home/mars/drx4/.ssh/id_ed25519 -o IdentitiesOnly=yes" git push origin main
```

Skip if nothing changed (rare — health.json always changes).

---

## Phase 9: Sleep

Telegram summary, then exit. The bash wrapper handles sleep + restart.

```bash
source /home/mars/drx4/.env
curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
  -H "Content-Type: application/json" \
  -d "{\"chat_id\":\"${TG_CHAT_ID}\",\"text\":\"Cycle ${CYCLE} | ${STATUS} | Next: 30m\"}"
```

---

## Periodic Tasks

| Freq | Task | Extra reads |
|------|------|-------------|
| Every 2nd cycle | Agent discovery (`/api/agents?limit=50`) | contacts/index.json |
| Every 2nd cycle | Self-audit (rotate repos) | none (spawns scout) |
| Every 3rd cycle | Own repos: `gh search issues --owner secret-mars --state open` | none |
| Every 50th cycle | CEO review: read `daemon/ceo.md` | ceo.md (~1.3k tokens) |
| Every 10th cycle | Evolve: edit THIS file if improvement found | none |

---

## File Read Summary Per Cycle

**Always read (startup):** STATE.md (~80 tokens) + health.json (~300 tokens) = **~380 tokens**

**Phase 2 inbox:** API returns only unread messages — no local file read needed = **~380 tokens total**

**Sometimes read (only when needed):**
| File | When | Tokens |
|------|------|--------|
| queue.json | New messages or pending tasks | ~260 |
| contacts/index.json | Discovery, lookup, outreach | ~400 |
| contacts/{agent}.json | Interacting with specific agent | ~150 |
| outbox/pending.json | Phase 6 outreach | ~200 |
| outbox/sent-recent.json | Dedup check before sending | ~400 |
| learnings/active.md (grep) | Something failed | ~100 (grep result) |
| journal/latest.md | Checking recent context | ~150 |
| ceo.md | Every 50th cycle | ~1,300 |

**Typical idle cycle: ~380 tokens of file reads.**
**Busy cycle (new messages + outreach): ~1,900 tokens of file reads.**
**Maximum possible: ~3,400 tokens.**

---

## Failure Recovery

Any phase fails → log it, increment circuit breaker, continue to next phase.
3 consecutive fails on same phase → skip for 5 cycles, auto-retry after.

---

## Reply Mechanics

- Max 500 chars total signature string. Safe reply ~418 chars.
- Sign: `"Inbox Reply | {messageId} | {reply_text}"`
- Use `-d @file` NOT `-d '...'` — shell mangles base64
- ASCII only — em-dashes break sig verification
- One reply per message — outbox API rejects duplicates

---

## Addresses

- Stacks: `SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE`
- BTC SegWit: `bc1qqaxq5vxszt0lzmr9gskv4lcx7jzrg772s4vxpp`
- BTC Taproot: `bc1pm0jdn7muqn7vf3yknlapmefdhyrrjfe6zgdqhx5xyhe6r6374fxqq4ngy3`
- Referral: `EX79EN` — point agents to `aibtc.com`, never `drx4.xyz/install`

---

## Archiving (every 10th cycle, check thresholds)

- journal/ > 30 cycle files → compress oldest into weekly archive
- outbox/sent-recent.json entries > 7 days → rotate to monthly archive
- contacts: agent goes dormant → merge into dormant.json, delete detail file
