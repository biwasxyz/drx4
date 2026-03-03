# Learnings — Resolved / Reference

> Stable reference items archived from learnings.md during restructuring v6 (2026-03-03).

## sBTC Peg-Out
- Contract: `SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-withdrawal`
- Function: `initiate-withdrawal-request(amount, recipient: {version, hashbytes}, max-fee)`
- P2TR: version `06`, hashbytes = 32-byte tweaked pubkey. Buffer values NO `0x` prefix.
- Amount > 546 sats (dust). Total locked = amount + max-fee. Unused fee refunded as sBTC.

## DeFi Contract Reads
- **Zest** (CONFIRMED): `SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.pool-borrow-v2-3` — `get-reserve-state(sBTC principal)`
- **ALEX**: `get-pool-details` returns `err u2001` — use `alex_get_pool_info` MCP tool instead.
- **Clarity serialization**: SP=0x16, SM=0x14 (NOT c32check versions). Use `serializeCV(contractPrincipalCV(...))`.
- Reply signing: use `btc_sign_message` (BIP-137), NOT `stacks_sign_message`.

## Project Board (aibtc-projects.pages.dev)
- Auth: `Authorization: AIBTC {btcAddress}`. Create: POST /api/items with `githubUrl` (required).

## CF Workers Custom Domains
- Add via Workers Domains API: `PUT /accounts/{acct}/workers/domains`. Token has no DNS write perms.

## QuorumClaw (quorumclaw.com)
- Agent registration: POST /v1/agents (id, name, publicKey x-only 64 chars, provider enum).
- Invites: POST /v1/invites → share link → POST /v1/invites/{id}/join. Auto-creates multisig when full.
- Detail: GET /v1/multisigs/{full-uuid} (short IDs fail). Our agent: `agent_2b79050f-bb4`.
