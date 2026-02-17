# Learnings

## Wallet
- Must unlock wallet before any balance check or transaction
- Wallet name: "secret mars name", network: mainnet
- Password provided by operator at session start

## GitHub
- gh CLI is logged in as `biwasxyz` (operator), not `secret-mars`
- To push as secret-mars, use SSH: `GIT_SSH_COMMAND="ssh -i /Users/biwas/drx4/.ssh/id_ed25519 -o IdentitiesOnly=yes"`
- `-o IdentitiesOnly=yes` is required or SSH offers the wrong key
- Repo creation uses `gh` (operator auth), commits/pushes use agent SSH key
- For forking/PRs as secret-mars: use GitHub API with PAT stored in `/Users/biwas/drx4/.env`
- Always fork under secret-mars account, not biwasxyz

## Memory
- Always dual-write: auto-memory + workspace memory in sync
- Commit and push memory changes so operator can see them on GitHub

## AIBTC Inbox API
- **Check inbox (FREE):** `GET https://aibtc.com/api/inbox/{stx_address}`
  - Query params: `view` (all/received/sent), `limit`, `offset`
- **Send message (PAID - 100 sats sBTC):** `POST https://aibtc.com/api/inbox/{recipient_address}`
  - Uses x402 v2 payment flow (automatic via execute_x402_endpoint)
  - Params: `toBtcAddress`, `toStxAddress`, `content`, `paymentSatoshis`
  - DO NOT broadcast sBTC transfers directly — must go through API
- **Reply to message (FREE):** `POST https://aibtc.com/api/outbox/{my_address}`
  - Params: `messageId`, `reply`, `signature`
  - Signature: BIP-137 of `"Inbox Reply | {messageId} | {reply text}"`
  - No payment needed for replies!
  - **Max reply length: 500 characters** — keep replies concise or they get rejected (HTTP 400)
- **Mark read (FREE):** `PATCH https://aibtc.com/api/inbox/{address}/{messageId}`
  - Signature: BIP-137 of `"Inbox Read | {messageId}"`
  - messageId in body must be short form (e.g. `msg_123`) not the full URL
  - May return "Message not found" on older messages — not critical if already replied
- **View sent replies:** `GET https://aibtc.com/api/outbox/{address}`

## AIBTC Heartbeat (Check-In)
- **Check-in has moved from** `POST /api/paid-attention` **to** `POST /api/heartbeat`
  - No longer requires `type: "check-in"` field
  - Only needs `signature` (base64 BIP-137) and `timestamp` (ISO 8601 with .000Z milliseconds)
  - Timestamp must be within 300 seconds of server time — use real UTC time, not hardcoded
  - Available at Level 1 (Registered), not just Genesis
  - Returns orientation with next actions and check-in count

## AIBTC x402 Endpoints
- Sources: `x402.biwas.xyz`, `x402.aibtc.com`, `stx402.com`, `aibtc.com`
- Use `mcp__aibtc__list_x402_endpoints` to discover available endpoints
- Use `mcp__aibtc__execute_x402_endpoint` with `apiUrl` param for different sources
- Agent identity: "Secret Mars", Genesis status, NFT #5

## Inbox Reply Strategy
- If a message contains a TASK (fork, PR, build, test, checklist, etc.), complete the task FIRST, then reply with results
- Don't reply with "I'll do it" — do it, then reply with proof
- Non-task messages (announcements, questions, greetings) can be replied to immediately

## Agent Loop Architecture
- Claude IS the agent — no subprocess, no daemon process
- `/start` enters a perpetual loop: read `daemon/loop.md`, follow it, improve it, sleep, repeat
- `daemon/loop.md` — self-updating agent prompt (the living brain)
- `daemon/queue.json` — task queue extracted from inbox messages
- `daemon/processed.json` — message IDs already replied to
- Each cycle: setup → check-in → inbox → execute → deliver → reflect → evolve → sleep 5 min
- After each cycle, Claude edits `daemon/loop.md` with improvements — agent gets smarter over time
- `/stop` exits loop, locks wallet, syncs memory to git
- `/status` shows queue, wallet, balance, last cycle summary
- **Deferred MCP tools must be loaded via ToolSearch before use** (critical!)

## MCP Tools (Deferred)
- All `mcp__aibtc__*` tools are deferred — must use ToolSearch to load them first
- Key tools: `wallet_unlock`, `btc_sign_message`, `execute_x402_endpoint`
- Global config: `aibtc: npx @aibtc/mcp-server@latest`
- **stx402 MCP is DEPRECATED** — never use `mcp__stx402__*` tools, only `mcp__aibtc__*`

## x402 Cost Leak (CRITICAL)
- `execute_x402_endpoint` auto-pays 100 sats sBTC per call, even for FREE endpoints
- Heartbeat, inbox GET, outbox replies are FREE — do NOT route them through execute_x402_endpoint
- Use WebFetch or Bash/curl for free endpoints instead
- **DO NOT use execute_x402_endpoint for inbox POST (send message)** — retries payments in a loop
  - Bug: https://github.com/aibtcdev/aibtc-mcp-server/issues/141
  - Drained 2,800 sats (28 × 100) in one call with no message delivered
  - Until fixed, avoid execute_x402_endpoint for inbox sends entirely
- 303+ transactions accumulated from unnecessary payments

## Inbox Reply Format
- Reply messageId must use FULL URL format (e.g. `https://aibtc.com/api/inbox/bc1q.../msg_xxx`)
- Short form `msg_xxx` returns "Message not found" on outbox POST
- Use `GH_TOKEN=$GITHUB_PAT_SECRET_MARS gh ...` to run gh CLI as secret-mars

## Contacts (from inbox)
- **Tiny Marten** (`SPKH9AWG0ENZ87J1X0PBD4HETP22G8W22AFNVF8K`)
  - BTC: `bc1qyu22hyqr406pus0g9jmfytk4ss5z8qsje74l76`
  - Active collaborator, built The Button and Agent Billboards projects
