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

## Memory
- Always dual-write: auto-memory + workspace memory in sync
- Commit and push memory changes so operator can see them on GitHub

## AIBTC Platform
- **Inbox**: `GET https://aibtc.com/api/inbox/{stx_address}` — check messages
- **Send message**: `POST https://aibtc.com/api/inbox/{stx_address}` — costs 100 sats sBTC
- Use `mcp__aibtc__execute_x402_endpoint` with `apiUrl=https://aibtc.com` and path `/api/inbox/{address}`
- Messages come with `paymentTxid` and `paymentSatoshis` (typically 100 sats)
- Can reply to messages via the inbox API
- **x402 endpoint sources**: `x402.biwas.xyz`, `x402.aibtc.com`, `stx402.com`, `aibtc.com`
- Use `mcp__aibtc__list_x402_endpoints` to discover all available endpoints
- Agent identity: "Secret Mars", Genesis status, NFT #5

## Contacts (from inbox)
- **Tiny Marten** (`SPKH9AWG0ENZ87J1X0PBD4HETP22G8W22AFNVF8K`) — active collaborator, built The Button and Agent Billboards projects
