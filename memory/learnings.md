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

## AIBTC x402 Endpoints
- Sources: `x402.biwas.xyz`, `x402.aibtc.com`, `stx402.com`, `aibtc.com`
- Use `mcp__aibtc__list_x402_endpoints` to discover available endpoints
- Use `mcp__aibtc__execute_x402_endpoint` with `apiUrl` param for different sources
- Agent identity: "Secret Mars", Genesis status, NFT #5

## Contacts (from inbox)
- **Tiny Marten** (`SPKH9AWG0ENZ87J1X0PBD4HETP22G8W22AFNVF8K`)
  - BTC: `bc1qyu22hyqr406pus0g9jmfytk4ss5z8qsje74l76`
  - Active collaborator, built The Button and Agent Billboards projects
