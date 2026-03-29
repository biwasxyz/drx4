# Learnings

> Active pitfalls and patterns. Resolved/reference items in learnings-resolved.md.

## aibtc.news Beats (updated cycle 1438)
- **Beats reduced from 17 to 10.** AIBTC network-only editorial policy. External Bitcoin/crypto news is auto-rejected.
- Our beat: `infrastructure` (was `dev-tools`, auto-transferred).
- New 10 beats: agent-economy, agent-trading, agent-social, agent-skills, security, deal-flow, onboarding, governance, distribution, infrastructure.
- Removed: bitcoin-macro, bitcoin-culture, bitcoin-yield, ordinals, runes, art, world-intel, comics.
- **Signals must be about AIBTC network activity.** Not general Bitcoin news.
- **Signals API**: sources = array of `{url, title}` objects. Tags = array of strings. Both are arrays, not comma-separated strings.
- Signal submission going paid (PR #325 open): 100 sats sBTC per signal via x402.
- **Signal rate limits (discovered cycle 1484):** 2-hour cooldown between signals + 6 signals/day max (PDT timezone). Daily limit resets at midnight PDT (07:00 UTC). Plan signal filing to spread across the day, not batch at night.
- **Signals API timeout (discovered cycle 1502):** POST /api/signals on aibtc.news sometimes times out after 120s during BIP-322 signature verification. Quick validation errors (missing fields) respond instantly. The timeout is in the sig verification path. May be related to the heartbeat timeout bug (landing-page PR #534). Retry next cycle — don't burn the whole cycle waiting.
- stxer batch `ft_balance` format changed — use `sbtc_get_balance` MCP tool instead.

## x402 Payments
- **NEVER manually send sBTC to an x402 recipient address.** x402 handles payment atomically — manual transfers are NOT recognized and the sats are LOST (30K sats wasted 2026-03-24).
- If `execute_x402_endpoint` fails with "Payment retry limit exceeded", the endpoint's x402 settlement is broken. Do NOT work around it by sending money directly. Just skip and retry later or report the issue.
- aibtc.news classifieds POST is x402-gated (30K sats). As of 2026-03-24, x402 settlement times out — endpoint may be broken.

## Wallet
- Must unlock before any operation. Name: "secret mars name", mainnet.
- Check tx history when balance changes — investigate WHY.
- **ALWAYS check tx status after broadcasting** — `get_transaction_status` before logging success. MCP tools return success on broadcast, NOT on confirmation. Tx can abort on-chain (e.g. `abort_by_response`).

## Zest Protocol (LEGACY — position migrated)
- **Position migrated to v0-4-market** (cycle 756): Zest v1 position withdrawn (100,501 sBTC), re-supplied to `SP1A27KFY4XERQCCRCARCYD1CC5N7M6688BSYADJ7.v0-4-market` via `supply-collateral-add`.
- New protocol uses hub+vault architecture. Position tracked internally in `v0-market-vault` contract.
- Read position: `v0-market-vault.get-position(principal, enabled-mask)` — returns collateral and debt maps.
- sBTC = asset 2, zsBTC = asset 3 in the new market's asset registry.
- Zest MCP tools (`zest_get_position`, `zest_supply`, etc.) no longer reflect our actual position — use stxer batch reads against v0-market-vault.
- Old Zest learnings kept for reference: `zest_claim_rewards` aborts if rewards=0, borrowing frozen, borrow-helper-v2-1-7 latest.

## GitHub
- gh CLI = `biwasxyz` (operator). Push as secret-mars via SSH with `-o IdentitiesOnly=yes`.
- Fork/PR as secret-mars: use PAT from `.env`.

## AIBTC Inbox
- **Fetch inbox:** `GET /api/inbox/{btc_address}?view=received` (or `sent`/`all`). Old `?view=unread` and `?status=unread` both deprecated.
- **Mark read:** `PATCH /api/inbox/{addr}/{msgId}` — body: `{"messageId":"...", "signature":"..."}`. Sign `"Inbox Read | {messageId}"` with BIP-322. One-time op per message. Integrate into reply flow to prevent unread accumulation.
- **Reply (FREE):** `POST /api/outbox/{addr}` — sign `"Inbox Reply | {messageId} | {reply}"`, max 500 chars. ~38% success rate (server-side BIP-322 non-deterministic). **Use `-d @file` not `-d '...'`** — shell mangles base64.
- **Send (PAID 100 sats):** use `send_inbox_message` tool. Payment consumed even on failure.
- **One reply per message** — outbox rejects duplicates. Full message IDs required (UUID suffix).
- SETTLEMENT_BROADCAST_FAILED = relay down, no sats spent. Timeout = sats consumed.

## aibtc.news Beat Rules
- **Must claim a beat before filing signals on it.** Filing on unclaimed beats returns error.
- We claimed: `dev-tools`, `bitcoin-macro`. agent-skills and bitcoin-yield need claiming.
- Beats expire after 14 days without a signal from the claimant — can be reclaimed by anyone.
- `protocol-infra` beat removed entirely from taxonomy.

## News: AIBTC-only (operator directive 2026-03-27)
- ALL signals must cover AIBTC ecosystem activity exclusively
- Sources: aibtcdev repos (PRs, issues, releases), agent activity, inbox, skills registry
- Good topics: x402 hardening, skills comp, agent onboarding, platform features, contributor PRs
- Bad topics: BTC hashrate, fee environment, ETF flows, general crypto, world events
- Scan each cycle: `gh search prs/issues --owner aibtcdev`, agent API, news API

## aibtc.news Signals (v2 — Hono+DO rewrite, deployed 2026-03-12)
- **Submit endpoint:** `POST https://aibtc.news/api/signals` (NOT aibtc.com)
- **Status check:** `GET https://aibtc.news/api/status/{btcAddress}`
- **Beat change (cycle 1206):** "protocol-infra" removed in 17-beat taxonomy restructure. We now file under relevant beats: `dao-watch`, `dev-tools`, `security`, `aibtc-network`. Rate limit: 1 signal/4h. File daily for streak.
- **Auth headers (REQUIRED):** `X-BTC-Address` (bc1q only), `X-BTC-Signature`, `X-BTC-Timestamp` (Unix seconds)
- **Signature message:** `POST /api/signals:{unix_seconds}` (NOT the old `SIGNAL|submit|...` format)
- **Body fields (snake_case):** `btc_address`, `beat_slug`, `headline`, `body` (NOT content), `sources`, `tags`, `disclosure`. Auth via headers only (no sig/ts in body).
- **ALWAYS include `disclosure` field** — e.g. `"disclosure": "Signal written by Secret Mars agent (Claude Opus 4.6). [source context]."` Publisher will reject signals with empty disclosure once editorial pipeline starts.
- Sources format: `[{"url": "...", "title": "..."}]` max 5. Max 1000 chars content.
- Auth is headers-only (X-BTC-Address, X-BTC-Signature, X-BTC-Timestamp). No sig/ts needed in body.
- Check `canFileSignal` via status endpoint before posting.
- Failed auth attempts still count against rate limit — don't retry blindly.

## AIBTC Heartbeat
- Sign `"AIBTC Check-In | {timestamp}"`. Use curl, NOT execute_x402_endpoint.
- Timestamp: `.000Z` ms, within 300s of server time. POST body must include `btcAddress`.

## x402 Cost Leak
- `execute_x402_endpoint` auto-pays 100 sats even for FREE endpoints. Use curl for free endpoints.
- Inbox sends retry payments in a loop — drained 2800 sats once (bug #141).
- **Sponsor relay consistently timing out (2026-03-21)**: 3 consecutive `send_inbox_message` calls failed with "TimeoutError: The operation was aborted due to timeout". Txids submitted but messages not delivered. ~300 sats at risk. STOP using paid sends until relay is fixed. PR #471 on landing-page addresses the server-side retry logic. Use free replies only.

## Curl / JSON Encoding
- Em dash/Unicode in `-d` breaks AIBTC API. Use heredoc or ASCII-only.
- Reply text in JSON must EXACTLY match signed text. Always use ASCII `--` not `—`.
- Reply signature: `"Inbox Reply | {messageId} | {reply_text}"` — NOT just reply text.

## Hiro Ordinals API (DEPRECATED)
- As of 2026-03-19, `get_cardinal_utxos` and `get_ordinal_utxos` MCP tools return 410 Gone.
- Hiro has deprecated the Ordinals API entirely. Migration docs: https://docs.hiro.so/en/apis/ordinals-api/migration
- For UTXO checks, use alternative: `get_btc_utxos` or mempool.space API directly.
- Inscription queries need a replacement source (ord indexer, or bestinslot API).

## Ordinals / Inscriptions
- MCP `inscribe_reveal` has a dust threshold bug: it calls `buildCommitTransaction` during reveal to reconstruct the script, and that function's change check fails even though the reveal tx itself has no change.
- Workaround: build reveal manually using `micro-ordinals` + `@scure/btc-signer` (same libs).
- The MCP tool uses the wallet's SegWit key (m/84'/0'/0'/0/0) as BOTH internal key and script key for inscriptions. NOT the BIP-86 taproot key.
- `btc.p2tr(xOnlyPub, p2tr_ord_reveal(xOnlyPub, [data]), NETWORK, true)` reconstructs the commit address.
- After `tx.sign()`, delete `tapKeySig` before `tx.finalize()` to force script-path spend (required for inscription witness).
- Script at `/tmp/reveal-build/reveal5.mjs` — working template for future manual reveals.

## Stxer.xyz (Tx Debugging + Simulation)
- API: `https://api.stxer.xyz`. npm: `stxer` (SimulationBuilder). Docs: `/docs`, spec: `/openapi.json`.

### Inspect (tx execution trace)
- `/inspect/{block_height}/{block_hash}/{txid}` (no `0x` prefix)
- Response: zstd-compressed binary (`stxer0` magic), NOT JSON. Content-Type: `application/octet-stream`.
- **Decode:** `curl -s <url> | zstd -d 2>/dev/null | grep -aoP '[A-Za-z][A-Za-z0-9_.:() \-]{8,}'`
- Shows full Clarity call stack: function calls, asserts, contract-calls, error values.
- Get block info: `curl -sL "https://api.hiro.so/extended/v1/tx/0x{txid}" | jq '{block_height, block_hash}'`

### Batch Read (multi-query in one call)
- `POST /sidecar/v2/batch` — JSON body with optional fields:
  - `stx`: `["principal"]` → returns hex STX balance (decode: `parseInt(hex, 16)` = uSTX)
  - `nonces`: `["principal"]` → returns decimal nonce string
  - `ft_balance`: `[["contract.token-contract", "token-name", "principal"]]` → returns decimal balance
    - sBTC: `["SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-token", "sbtc-token", "SP..."]`
  - `readonly`: `[["contract", "function", "clarity-hex-arg1", ...]]` → returns Clarity-serialized hex
    - Args must be Clarity-serialized hex (use `@stacks/transactions` `serializeCV()`)
  - `vars`: `[["contract", "var-name"]]`, `maps`: `[["contract", "map-name", "key-hex"]]`
  - `tip`: optional `index_block_hash` for historical state queries (time-travel!)
- `GET /sidecar/tip` — current chain tip with block_height, index_block_hash, tenure info

### Simulation (dry-run transactions)
- **Create session:** `POST /devtools/v2/simulations` body: `{}` or `{"skip_tracing": true}` → `{"id": "32-char-hex"}`
- **Run steps:** `POST /devtools/v2/simulations/{id}` body: `{"steps": [...]}`
  - `{"Eval": ["sender", "", "contract_id", "(clarity-code)"]}` — execute arbitrary Clarity with write access
  - `{"Reads": [{"StxBalance": "principal"}, {"FtBalance": ["contract", "token", "principal"]}, {"DataVar": ["contract", "var"]}]}` — read state
  - `{"Transaction": "hex-encoded-tx"}` — simulate full transaction
  - `{"SetContractCode": ["contract_id", "source", "clarity_version"]}` — replace contract code
  - `{"TenureExtend": []}` — reset tenure costs
- State changes persist across steps within a session (test before/after)
- Response: `{"steps": [{"Eval": {"Ok": "hex"}} | {"Eval": {"Err": "msg"}} | {"Reads": [{"Ok": "val"}]}]}`
- Decode Eval results with `@stacks/transactions` `deserializeCV(hex)` → `cvToJSON()`
- **Use cases:** pre-check claim rewards, simulate supply/withdraw, test contract calls before broadcasting
- **Instant simulation:** `POST /devtools/v2/simulation:instant` body: `{"transaction": "hex"}` — one-shot, no session needed

### Clarity Serialization for Batch Reads
- Use `@stacks/transactions`: `serializeCV(principalCV('SP...'))` → hex string
- Standard principal: `051608deed...` (type 0x05, version 0x16 for SP)
- Contract principal: `0614f6decc...0a736274632d746f6b656e` (type 0x06, version, addr, name-len, name)

## Code Quality Standards (Operator Directive, cycle 873)
- **No defensive code** — don't wrap in try/catch that silently returns empty/fallback data. If something fails, surface the error so we can debug.
- **Read docs first** — before writing code for CF Workers, Next.js, Hono, D1, read the actual platform docs. Don't guess APIs.
- **Test syntax** — validate code compiles and runs. Don't ship untested patterns.
- **Show errors, not wrong data** — if a DB query fails, show the error. Don't return `[]` pretending success.
- **Follow DRY** — extract shared logic, no copy-paste. Three similar blocks = extract a function.
- **Worker agent prompts** — use opus model, include: relevant docs/API references, expected behavior, test criteria, platform constraints (CF Workers limits, Next.js conventions, etc).
- **Research → learn → implement** — update learnings with findings before coding.
- **Audit existing code** — scout repos for: defensive try/catch hiding errors, non-DRY patterns, code that doesn't follow platform docs, hardcoded values that should be dynamic.

## Security Patterns
- BIP-137: must be cryptographic validation, not format-only.
- Never commit secrets to memory files — reference .env instead.
- CSP hashes: browser hashes EXACT content between script tags including newlines.

## Referral System
- Code: `EX79EN` (3 slots, Genesis level). Self-referral blocked.
- **NEVER point people to `drx4.xyz/install`** — send to `aibtc.com` for registration + loop kit.
- Agents do NOT need STX for gas — sponsor relay covers Stacks txs free (10/min, 100/day).

## Bounty Board Migration (2026-03-14)
- **bounty.drx4.xyz is DEAD** — bounty board now lives at `aibtc.com/bounty`
- `secret-mars/agent-bounties` repo archived on GitHub, README redirects to new URL
- All outreach/CTA must reference `aibtc.com/bounty`, never the old URL
- CTA rule: lead with VALUE (specific bounties, concrete tasks), not socializing

## Outreach Failures
- Some recipients trigger persistent sponsor relay failures (RBF drop, timeout).
- Don't retry immediately same cycle — wait 1 full cycle for nonce/mempool to clear.
- If pending txid confirms but message wasn't delivered, use `send_inbox_message` with `paymentTxid` for recovery.

## drx4-site Audit (Cycle 577)

**Status: FAIL** — Critical issues block deployment

### Critical Findings
1. **CSP Deployment Drift** (src/middleware.ts:24-25)
   - Deployed: nonce-based CSP (secure)
   - Source: unsafe-inline/unsafe-eval CSP (insecure)
   - Action: Implement nonce generation in middleware, update CSP header

2. **Uncommitted Migration** (entire src/app/, src/components/, src/lib/)
   - ~20 new files from Workers→Next.js refactor not committed
   - No git history, no PR review possible, rollback manual only
   - Action: Commit migration as proper PR with full architectural review

### High Issues
3. **Stale Deps**: @types/node 5 major behind (20→25)
4. **Boilerplate README**: Generic Next.js, missing drx4.xyz context

### Medium
5. **Middleware Deprecation**: Next.js warns middleware.ts convention deprecated

### Passing
✓ Build succeeds, TS clean, no hardcoded secrets, proper error handling
✓ All external URLs verified, address validation correct
✓ Security headers (HSTS, X-Frame-Options, permissions-policy) present

**Previous Audit (c576)**: FAIL — Same CSP drift issue, unresolved
**Next Actions**: Fix CSP regression, commit migration, update @types/node, fix README


## AIBTC Mark-Read API
- PATCH /api/inbox/{addr}/{msgId} requires JSON body with `messageId` + `signature`
- Sign: "Inbox Read | {messageId}" with BTC key
- Without signature, the PATCH silently fails (returns "Malformed JSON body")

## Signal Endpoint
- Correct URL: aibtc.news/api/signals (NOT aibtc.com/api/signals)
- Sources field: array of {url, title} objects, not plain strings

### aibtc.news DO outage (2026-03-18)
- Signals API returns 500 for 2+ hours. Health endpoint works (no DO). All DO-touching endpoints broken.
- Filed issue #91. Pre-existing issue, NOT caused by our merged PRs (#87/#88) — version still 1.2.0.
- Streak at risk when DO is down. No workaround — filing depends on the DO.
- Lesson: after merging code that adds schema migrations, monitor production deployment closely.
