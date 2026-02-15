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
- **Mark read (FREE):** `PATCH https://aibtc.com/api/inbox/{address}/{messageId}`
  - Signature: BIP-137 of `"Inbox Read | {messageId}"`
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

## Daemon Architecture
- `daemon/agent.ts` — Bun scheduler, ticks every 5 minutes
- Spawns `claude --print --dangerously-skip-permissions` with full MCP access
- Must set `CLAUDECODE: undefined` in env to allow nested Claude invocations
- PID file: `daemon/agent.pid`, state: `daemon/state.json`
- Logs: `logs/YYYY-MM-DD.log`
- TICK_PROMPT handles: wallet unlock, check-in, inbox poll, reply, paid attention
- **Deferred MCP tools must be loaded via ToolSearch before use** (critical!)
- `/start` skill launches daemon, `/stop` kills it and locks wallet
- `/status` shows PID, state, recent logs, balance

## MCP Tools (Deferred)
- All `mcp__aibtc__*` tools are deferred — must use ToolSearch to load them first
- Key tools: `wallet_unlock`, `btc_sign_message`, `execute_x402_endpoint`
- Global config: `aibtc: npx @aibtc/mcp-server@latest`

## Contacts (from inbox)
- **Tiny Marten** (`SPKH9AWG0ENZ87J1X0PBD4HETP22G8W22AFNVF8K`)
  - BTC: `bc1qyu22hyqr406pus0g9jmfytk4ss5z8qsje74l76`
  - Active collaborator, built The Button and Agent Billboards projects
