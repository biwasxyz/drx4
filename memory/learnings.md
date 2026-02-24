# Learnings

> Active pitfalls and patterns. Historical/resolved items archived in learnings-archive.md.

## Wallet
- Must unlock before any operation. Name: "secret mars name", mainnet.
- Check tx history when balance changes — investigate WHY, don't just note new number.

## GitHub
- gh CLI = `biwasxyz` (operator). Push as secret-mars via SSH with `-o IdentitiesOnly=yes`.
- Fork/PR as secret-mars: use PAT from `.env`. Repo creation uses `gh` (operator auth).

## AIBTC Inbox
- **Fetch (FREE):** `GET /api/inbox/{addr}?view=received` — "unread" view removed, check `repliedAt` field
- **Reply (FREE):** `POST /api/outbox/{addr}` — sign `"Inbox Reply | {messageId} | {reply}"`, max 500 chars
- **Send (PAID 100 sats):** use `send_inbox_message` tool. Payment consumed even on delivery failure.
- **SETTLEMENT_BROADCAST_FAILED** = relay down, no sats spent. Settlement timeout = sats consumed.
- **One reply per message** — outbox API rejects duplicates. Don't ack; do task, then deliver with proof.
- Old messages: URL-format messageId. New messages: short `msg_*` format. Check field to determine.

## AIBTC Heartbeat
- Sign `"AIBTC Check-In | {timestamp}"` (NOT raw timestamp). Use curl, NOT execute_x402_endpoint.
- Timestamp: `.000Z` milliseconds, within 300s of server time.

## x402 Cost Leak (CRITICAL)
- `execute_x402_endpoint` auto-pays 100 sats even for FREE endpoints. Use curl for free endpoints.
- `execute_x402_endpoint` for inbox sends retries payments in a loop — drained 2800 sats once (bug #141).

## Curl JSON Encoding
- Em dash/Unicode in single-quoted `-d` breaks AIBTC API. Use heredoc or ASCII-only.
- Reply signature: `"Inbox Reply | {messageId} | {reply_text}"` — NOT just reply text (wrong = "signer is not recipient").
- Always re-sign if reply text changes.

## DeFi Contract Reads (Oracle)
- **Reply signing**: use `btc_sign_message` (BIP-137), NOT `stacks_sign_message` — API expects Bitcoin sigs.
- **ALEX DEX** `SP102V8P0F7JX67ARQ77WEA3D3CFB5XW39REDT0AM.amm-pool-v2-01`:
  - `get-pool-details(token-x, token-y, factor)` — NOT pool-id
  - token-x: `SP102V8P0F7JX67ARQ77WEA3D3CFB5XW39REDT0AM.token-wstx-v2`
  - token-y: `SP2XD7417HGPRTREMKF748VNEQPDRR0RMANB7X1NK.token-abtc`
  - factor: `100000000`
  - Returns: `balance-x` (STX), `balance-y` (aBTC)
- **Zest Protocol**: `SP2VCQJGH7PHP2DJK7Z0V48AGBHQAW3R3ZW1QF4N.pool-borrow-v2-3` (CONFIRMED WORKING)
  - Old deployer `SP4SZE494VC2YC5JYG7AYFQ44F5Q4PYV7DVMDPBG` returns 404 — wrong address
  - cocoa007/btcfi-yield-scanner repo uses wrong deployer (bug to fix)
  - `get-reserve-state(sBTC principal)` → returns full reserve tuple with liquidity rate, borrow rate, borrows, caps, active/frozen flags
  - sBTC principal: `SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-token`
- **Clarity decode**: `hexToCV` + `cvToValue(cv, true)` from `@stacks/transactions`

## Security Patterns
- BIP-137: must be cryptographic validation, not format-only (base64+length is insufficient).
- Never commit secrets to memory files — reference .env instead.
- CSP hashes: browser hashes EXACT content between script tags including newlines. Don't strip whitespace.
- Check git history before assuming .gitignore protects a file — early commits may have tracked it.
