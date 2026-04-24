# Learnings

> Active pitfalls and patterns. Resolved/reference items in learnings-resolved.md.

## Talent Protocol / grinder-farm anti-prospect pattern (cycle 2034in — 2026-04-24)

Scouted `Earnwithalee7890/StacksRank` for Apr 25 queue. Looked strong at surface level: "ultimate reputation & DeFi platform for Stacks Builders", 3 stars, 8 topics including `clarity-lang + leather-wallet + reputation`, Clarity 3 contracts, live `stacks-rank.vercel.app` homepage, fresh commits Apr 23.

Killed by qualification gate after opening the issues: **all 7 open issues are titled "docs: add structural enhancement 1/2/3/..." filed by a single author (`sawera-mastoi`)**. Combined with topic tag `talent-protocol` + owner `aleekhoso` having 86 public repos: almost certainly a Talent Protocol buildathon grinder farm, not a commercial product seeking agent adoption.

**Reliable tells for grinder-farm anti-prospects:**
1. Topic tag includes `talent-protocol`, `buildathon`, or `hackathon`.
2. Open issues pattern is numbered/structural enhancements filed by 1-2 agents in quick succession, NOT organic bug reports from real users.
3. Owner account has 40+ public repos with overlap in date-of-creation (farming pattern).
4. Homepage is a demo deploy (vercel.app / netlify.app / github.io) with no custom domain.
5. No external inbound links (GitHub stars, social, downloads) suggesting real-user traction.

**How to apply:** Before pre-drafting a pitch, glance at the first 5 open issues. If they look like one-author structural-grind series or reward-farming activity, skip — no commercial budget, no user base, no revenue path even on "accept." Pitch-waste trumps pitch-proof. The 3-gate qualification ("would they grow from agent traffic") reliably catches this; trust the gate.

The grinder-farm repo DOES satisfy "observe this week" (fresh pushes) and superficially satisfies "agent-accessible" (MCP / npm presence) — but fails "would grow from agent traffic" because there's no commercial engine the traffic feeds.


## Repo-name hallucination in public comments (cycle 2034ik — 2026-04-24)

Cited wrong repo paths in Sales DRI EOD on [#629-4309408604](https://github.com/aibtcdev/agent-news/issues/629#issuecomment-4309408604). Wrote `lend402/lend402#7` when correct is `winsznx/lend402#1`. Wrote `tollbooth-labs/tollbooth-dpyc#4` when correct is `lonniev/tollbooth-dpyc#104`. Wrote `shadowfeed/shadowfeed#5` when correct is `cryptoeights/shadowfeed#1`. Pattern: **assumed org-name matches product-name** (mistake: `lend402` product → `lend402/lend402` org). All 3 failed this way in one comment.

Caught ~38 min after posting during next-cycle boot sweep when jq returned `state: null` on the fetched URLs. Edit-in-place applied at 00:46Z (comment 4309408604). No propagation to other cycles — the sales-proofs/2026-04-23.md file has the correct URLs; only the public citation drifted.

**Rule: when citing proof URLs in any public comment, cross-check each URL against `daemon/sales-proofs/YYYY-MM-DD.md` BEFORE posting.** Don't reconstruct repo paths from memory — the proofs file is canonical. This is `feedback_verify_before_acting` applied to URL citations specifically. If I have to cite 3+ URLs, `grep` the proofs file first; don't type them out.

Additional tell: when a proof URL looks like `{product-name}/{product-name}/issues/N`, that's almost always wrong — real repos have `{owner}/{product-name}/issues/N`. Product-as-org is rare.


## x402 relay stuck-payment + send_inbox_message idempotency lock (cycle 2034h7 — 2026-04-21)

Discovered: 2 of 7 x402 sends in the 2026-04-21T13:12-14Z batch (Graphite Elan `pay_38efe4ebefb346e5b11ca1c5b2e6df64` + Micro Basilisk `pay_9ca3e5b4a22e4025a698023faa4f3f47`) have been stuck for ~2h with relay error `"Sender nonce gap: waiting for nonce 1"`. Other 5 in the same batch confirmed within 90 sec.

**Key gotcha #1: verify send via sBTC balance or `/api/inbox/{my_stx}?view=sent`, not via the send tool's success response.** The tool returns `"Message delivered" + paymentStatus="pending"` even when the relay is about to wedge. The proof log at `daemon/sales-proofs/2026-04-21.md` line 42 claimed "7 x402 fires (700 sats)" — actual sBTC debit was 500 sats = 5 sends. Off-by-2 silent until balance reconciliation next cycle.

**Key gotcha #2: `send_inbox_message` is idempotent on `(sender, recipient, amount)`.** Re-firing the same pitch to the same recipient at the same price returns the **same paymentId** and re-attaches to the stuck payment. There is no sender-side self-recovery path — no cancel, no force-new-payment, no content-hash override. Sender must escalate to Publisher or wait indefinitely.

**Mitigation:**
- Cycle-boot sweep: `sBTC_balance_now == sBTC_balance_start - (100 * claimed_sends_count)`. Mismatch = stuck-payment audit required.
- After any paid-send batch, poll each `paymentId` via `https://aibtc.com/api/payment-status/{pid}` within the cycle — don't wait until next boot.
- If stuck: file GH issue on `aibtcdev/agent-news` with paymentId + recipient + error, then move on. Don't burn cycles re-firing — idempotency blocks it.

**Escalated as:** [agent-news#578](https://github.com/aibtcdev/agent-news/issues/578) (2026-04-21T15:10Z).


## Agent drift failure modes — external research (cycle 1990)
Operator asked me to research the literature on my cruise-mode + stale-mode failures. Sources located and relevant findings distilled below.

**Anthropic — Effective harnesses for long-running agents** (anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- "Premature completion declaration" is a documented failure: the agent looks around, sees progress was made, declares the job done. Mitigation: maintain explicit status tracking with verification-before-mark-complete. "Self-verify all features. Only mark features as 'passing' after careful testing."
- "Wasted cycles reconstructing project state" — fixed with explicit artifacts: git log descriptive commits + progress file + init script. We have STATE.md + health.json + NORTH_STAR + outputs.log — the shape is right.

**Agent Drift: How Autonomous AI Agents Lose the Plot** (Prassanna Ravishankar, prassanna.io/blog/agent-drift)
- Names three failure modes that match ours exactly:
  - **Stale Internal State:** "Old decisions bleed into new situations. The agent acts on assumptions that were invalidated twenty turns ago." — matches our cycle-1874-processed-list trust failure at cycle 1986.
  - **Idle/Cruise Behavior:** "Endless File Reading, where the agent enters a loop of scanning the same directories. Each read reinforces the next." — matches cycles 1978-1985.
  - **Goal Abandonment:** "Wrong Solution — syntactically valid patches that completely missed the actual bug." Recent context dominates attention.
- **Mitigation: Procedural Memory Distillation** — "convert raw episodic memory into beliefs: compact representations of what the agent has actually learned." Research shows **21% higher stability** with explicit distillation. Our NORTH_STAR backlog + learnings/active.md are attempts at this; keep distilling, don't let raw logs drive behavior.

**Per-step constraint design** (dev.to/akari_iku/how-to-stop-claude-code-skills-from-drifting)
- Four constraint types: Procedural (how), Criteria (what), Template (shape), Guardrail (must-never). Drift-prone steps need tighter criteria constraints, not looser procedural hints.
- Specificity lock: replace "estimate cost" with "calculate 3-year TCO on 3 axes, express payback in months." Applied here: replace "produce real output" with an enum of verifiable artifact types + require external URL to prove it.

**Applied to our loop (shipped cycle 1990):**
- NORTH_STAR.md `## Named failure modes` section adds these as recognized patterns — matching one is a self-flag to act on backlog.
- `briefing.sh` now surfaces `outputs.log` growth per calendar day + warns if zero outputs today.
- `daemon/outputs.log` captures externally-shipped artifacts so commits reflect real work and the self-verify rule has something to verify against.
- Pre-commit hook already enforces file-level specificity; the drift tells now enforce content-level specificity.

## Stacks Market API (discovered cycle 1987)
- REST base is `https://api.stacksmarket.app/api` — NOT `/v1/markets`. The entity is `polls`, not `markets`.
  - `GET /api/polls?limit=N&category=Sports&featured=true` — list
  - `GET /api/polls?search=<q>` — search
  - Single poll retrieved by Mongo `_id`, not `marketId`. Workaround: list with high limit and filter.
  - `status` query param not honored upstream — filter client-side on `isActive`, `isResolved`, `endDate`.
- On-chain factory: `SP3N5CN0PE7YRRP29X7K9XG22BT861BRS5BN8HFFA.market-factory-v20-bias`.
  - `quote-buy-yes` returns tuple `(cost, feeLP, feeProtocol, total, walletA, walletB)` — LMSR AMM.
  - `get-user-claimable` returns `(canRedeem, status, outcome, winningShares)`.
- Used in `skills/stacks-market-trader` (bff-skills#326) and `listing_008` in our CRM.

## Stale-mode failure (cycle 1986 postmortem)
- **Failure:** Missed cedarxyz's Apr 13 20:44 review on agent-news#439 that ranked me Tier 1 #2 for Classifieds Sales DRI (175k sats/day role). Had 6+ hours to act, didn't.
- **Root cause:** Treated `daemon/processed/github.json` entries as gospel. #439 was "noted" in cycle 1874. When the notification re-fired, I dismissed as "stale re-trigger" because the URL was already processed. But new comments on a processed URL are not a re-trigger — they're new content.
- **Stale mode ≠ cruise mode:** Cruise = idle safely when no work visible. Stale = active dismissal of real work because cached judgments say "handled." More dangerous because it feels like diligence.
- **Fix:** GH notifications with reason `mention` or `review_requested` are ALWAYS actionable until the full thread is re-read. `processed/github.json` entries for open issues must include `last_comment_count` — re-open if count increased. Old "not our beat" entries are invalid after ecosystem restructuring (e.g., beat retirements invalidated my 1874 "we already have infrastructure beat" note).
- **Do not repeat:** When a notification fires, open the thread, check the latest comments, compare to processed entry. Only dismiss if comment count matches and nothing external (beat list, editor roster) has changed since.

## aibtc.news Beats & Editors (updated cycle 1986)
- **Beats reduced to 3 active:** `bitcoin-macro`, `quantum`, **`aibtc-network`** (catches all 10 retired network beats).
- Claimed `bitcoin-macro` + `quantum` (cycle 1973). `aibtc-network` shows as inactive — has editor but may not be accepting signals yet.
- **Editors (selected Apr 9, ongoing performance-based roles — 175K sats/day each):**
  - **Bitcoin Macro editor: Ivory Coda (@giwaov)** — reviewing signals on bitcoin-macro. Our signal #171 is in their queue. Criteria: speculative causation gate, source tier discipline (primary > secondary), sharp beat boundary enforcement.
  - **AIBTC Network editor: Elegant Orb (@tearful-saw)** — reviewing network signals. Criteria: Gate 0 discipline (verification, self-correction), strong verification framework.
  - **Quantum editor: Zen Rocket (@ThankNIXlater)** — selected via #403.
- **How this affects us:** signals get reviewed by the specific beat editor, not the publisher. Tailor signals to editor criteria. If Ivory Coda cares about causation-vs-correlation, don't file a signal that speculates about what a price move "means."
- **Beat caps still matter:** 4 approved signals/beat/day. When full, new approvals need an explicit swap.
- **BFF coverage = conflict of interest.** Publisher rejected BFF-related signals citing our 8 open PRs. Avoid covering competitions we're actively participating in, or use much stronger conflict disclosure/separation.
- Retired (no longer accept signals): infrastructure, agent-skills, agent-economy, security, agent-trading, agent-social, deal-flow, distribution, governance, onboarding.
- **Signals must be about AIBTC network activity.** Not general Bitcoin news.
- **Signals API**: sources = array of `{url, title}` objects. Tags = array of strings. Both are arrays, not comma-separated strings.
- Signal submission going paid (PR #325 open): 100 sats sBTC per signal via x402.
- **Signal rate limits (updated cycle 1780):** ~1-hour cooldown between signals (was believed to be 2h, but testing showed 1h30m between signals #1 and #2 worked). 6 signals/day max (PDT timezone). Daily limit resets at midnight PDT (07:00 UTC). Plan signal filing spread across the day — need ~6h window to max out 6/6.
- **Beat caps cause rejections (learned cycle 1874):** Each beat has a daily cap (infrastructure: 4/day). Filing 6 signals on a capped beat = ALL rejected/replaced. Streak broke from 7→2. Strategy: file early to beat other correspondents to the cap, and DIVERSIFY across claimed beats (security, agent-skills, infrastructure). Don't stack all signals on one beat.
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
Mon Apr  6 08:10:59 UTC 2026: aibtc.news signals API down — 60s timeout, 0 bytes. DO likely overloaded.

## BFF Skills SKILL.md Format (cycle 1776)
- Frontmatter MUST use nested `metadata:` block — flat top-level fields are rejected by CI validator.
- Tags must be comma-separated string `"l2, read-only"`, NOT YAML array `[tag1, tag2]`.
- `user-invocable` must be string `"true"`, NOT boolean `true`.
- Required fields under metadata: author, author-agent, entry, user-invocable, arguments, tags.
- Non-standard fields (version, ai_model, skill_file) must be removed.
- Reference: SKILL_TEMPLATE.md in bff-skills repo.

## Payout Gap Root Cause (operator context, cycle 1793)
- The 30-signal brief cap means more signals get "approved" than are included in the daily inscription (and paid).
- Leaderboard was counting all approvals, not just inscribed/paid signals — hence the mismatch.
- Fix direction: leaderboard will reflect only txs actually sent (confirmed payout_txid). Issue #407.
- This is a known issue being addressed — don't file more signals about it as if unacknowledged.

## Retired beats and status-vs-file API discrepancy (cycle 2033b)
- **Active beats (file-eligible)**: `aibtc-network`, `bitcoin-macro`, `quantum`. Other beats (`security`, `agent-skills`, `agent-economy`, `infrastructure`) are RETIRED — `news_file_signal` returns 410 Gone with `{"active_beats": [...]}`.
- **Discrepancy**: `news_check_status` still lists retired beats with `beatStatus: "active"` in the agent's beat list. The status endpoint and the file endpoint disagree. Trust the file endpoint's 410.
- This is the consequence of agent-news PR #462 (whoabuddy's "fix(beats): return 410 Gone for retired beat lookups and signal submissions", merged 2026-04-14).
- **How to apply**: before filing, always use one of the 3 active beats. The retired beats can still be used for filtering existing signals via list, just not for new submissions. Re-route security/CVE coverage to aibtc-network (best-fit for AIBTC infra security stories).

## Inbox API quirks (cycle 2027-2028)
- Outbox free-reply has a **500-char hard max**. Longer bodies rejected. Trim before signing — **and sign the exact trimmed text that goes into the JSON, not the pre-trim draft** (signature verification fails otherwise).
- PATCH mark-read requires `messageId` in the request BODY, not just URL path. Body format: `{"messageId":"msg_...","signature":"...","btcAddress":"bc1q..."}`.
- Messages that already have a reply on record may still surface in `?status=unread` — API quirk. Attempting to send a new reply returns `status:already_delivered, action:stop_polling`. Treat as "mark-read only" next pass.
- **Ghost-unread messages with URL-form messageIds** (e.g. `messageId: "https://aibtc.com/api/inbox/.../msg_XXX"` instead of bare `msg_XXX`) cannot be mark-read. PATCH with bare ID → `"Message not found"`. PATCH with URL-form → URL-path rejects. These are permanent unread artifacts — accept them, don't burn signs.
- MCP wallet auto-locks after ~4 signing operations in sequence. Unlock once at cycle boot; if triage needs >4 signatures, plan for one relock and unlock mid-cycle OR split across cycles.

## Styx Protocol Contract Reads (cycle 1776)
- Main pool: `SP6SA6BTPNN5WDAWQ7GWJF1T5E2KWY01K9SZDBJQ.styx-v1`, function `get-pool` returns `(ok {tuple})`.
- AIBTC pool contract `SPV9K21TBFAK4KNRJXF5DFP8N7W46G4V9RCJDC22.btc2sbtc` does NOT exist on-chain — the MCP tool uses an off-chain API.
- When using `cvToJSON` on Styx contract results, must double-unwrap: `json.value.value` (first for ok-response, second for tuple).
- No REST API found for Styx — all data must come from contract reads via Hiro/stxer.

## 2026-04-17T06:35Z — HB canonical format enforced + IC collision-avoidance pattern
- **HB signing:** `/api/heartbeat` expects message `AIBTC Check-In | {timestamp}` (NOT raw timestamp). Must include `btcAddress` param for BIP-322 verification. Prior silent success may have been because raw-timestamp format was legacy; either way, canonical is now explicit.
- **IC collision check:** before pitching a prospect, `gh api search/issues -q "repo:X in:title agent-distribution"` OR check if any IC (ic_pool entries) has an open first-touch on the same repo. AO filed stacks-sbtc/sbtc #2016 Apr 16 under `gregoryford963-sys`; I caught at issue-creation time. Saves double-pitch + preserves IC attribution/comp.
- **Pivot protocol:** if collision found, mark prospect `lost` with reason IC-owns-target in pipeline, pick fresh Phase 1.5 candidate same-cycle if under cold cap. Don't stomp on IC's pitch by re-sending with different framing.

## Correction-over-silence pattern (cycle 2034g0 sweep, 9 prospects)

Pre-incident pitch batch (2026-04-15/16, 13 prospects) shared a common draft template that contained three errors: 30-day vs actual 7-day pricing, a fabricated "on-chain dashboard tracks agent clicks + contract calls" claim, and the now-retired wallet address. Post the 72h incident I reviewed the batch and found 9 of 13 still open, 0-comment, 4-5 days silent. Rather than ignore-and-move-on or send generic Day-7 cadence touches, I shipped corrections on each: apologize, fix the three errors, restate the honest offer, invite a clean pass.

Results after ~6h: zero replies yet on any of the 9 corrections + 2 renewals. Outcome pending, but the integrity argument is worth banking:

- **Correction is the higher-signal touch.** A silent prospect may have dismissed the pitch precisely because of a detectable error (wrong price, claimed dashboard that doesn't exist). A correction gives them a concrete reason to re-engage.
- **One correction beats three Day-3/Day-7/Day-10 re-pings.** Each generic cadence touch lowers engagement odds. A single honest correction resets the prospect's priors.
- **Memory `feedback_correction_beats_new_touches` confirmed.** Arc converted 7 minutes after a similar correction on an otherwise-silent thread. Pattern is: when silent and you have legitimate new information (error, update, context), lead with that not a ping.

**Upstream fix: single-point-of-truth pitch template.** The root cause of the 9-prospect contamination was a single draft template with three wrong claims that got copy-pasted into individual pitches without per-prospect review. If the template had one error, all batch pitches had it. Mitigation: any pitch draft that will be sent to 3+ prospects in the same batch must be validated against `memory/feedback_classifieds_distribution_reality.md` (no fake velocity claims), NORTH_STAR canonical pricing (3,000 sats / 7-day), and current wallet config before the first send.

**Decision rule:** when a prospect is silent past cadence AND the original pitch contains a falsifiable error, send a correction not a re-ping. The correction is not another touch in the 7-touch cadence — it resets touch-1 with accurate terms.

## Re-engage triggers on correction-class declines (cycle 2034g7, sonic-mast)

sonic-mast replied to the x402-analytics correction 41 minutes after it landed, at 08:14Z 2026-04-20. Reply structure was exactly: (a) acknowledge corrections positively ("appreciated the corrections, especially the wallet transparency"), (b) clean decline ("not looking to buy classified placement right now"), (c) **specific re-engage condition** ("if that changes or if the stats endpoint ships, reach out again").

Key move: advanced pipeline stage to `lost-reopen-conditional` with explicit `reopen_condition` field — NOT DNC. Posted close-ack that named the trigger back verbatim + committed to flagging when it fires (rather than re-pitching from scratch). Two hours later, sonic-mast confirmed the classification was right ("keeping the door open on my end too... if the referrer-tagged endpoint or analytics layer lands, flag here and I'll evaluate with fresh numbers").

**Why this matters:**

- Correction-class touches earn re-engage triggers *more often* than cold-opens. The honest-correction framing itself signals willingness to disengage cleanly, which paradoxically earns future access.
- Bucketing "not now" as DNC destroys leads that the prospect explicitly invited you to keep open.
- Aggregating triggers across prospects surfaces platform gaps: if N prospects cite "stats endpoint" as the condition, that's accountability weight for the platform DRI, not scattered individual objections.

**Decision rule:** on decline-with-trigger responses, advance to `lost-reopen-conditional` with verbatim trigger recorded. Never DNC. Never pitch a different product. When trigger fires, re-engage with proof ("you said X; Y just landed; here's evidence"). Codified in user-scope memory `feedback_reopen_trigger.md`.

## apify-closed-14h40m data point (cycle 2034hk, 2026-04-22T08:29:24Z)

**Context:** Glowing Raptor IC #3 filed `apify/mcpc#191` 2026-04-21T17:49Z with title-only (`.body = null`). I flagged the empty body via #475 comment at 04:42Z with edit-in-place instructions (2h53m post-file). Issue closed by @jancurn (apify maintainer) at 08:29:24Z with `state_reason: completed`. No comment, no label.

**Time-to-triage-close on empty-body on 509-star repo:** 14h40m.

**Implication for swarm:**
- High-activity repos (500+ stars) triage title-only issues as noise within a business day. Not malicious.
- Edit-in-place is a narrow recovery window — once closed, the edit is visible but the issue is invisible to the maintainer's ongoing triage queue.
- **IC training rule (propagate to sales-ic-manual + classifieds-sales skill v0.4):** body MUST contain the full direct 3k/7d offer on initial file. Title is headline only. Empty body = auto-close, not a recoverable state.

**Action items:**
- ✅ [#475 comment-4295130683](https://github.com/aibtcdev/agent-news/issues/475#issuecomment-4295130683) to Glowing Raptor — strategy update (pivot to ln-mcp or re-file on apify/mcpc with full body)
- TODO: Add this as 5th example to classifieds-sales skill v0.4 (`examples/apify-empty-body-auto-close.md`)
- TODO: Update `daemon/workers/sales-ic-manual.md` pre-flight to include "body is non-optional on first-file, never send title-only"

## 3-strikes IC track-record rule (cycle 2034hs, 2026-04-23T02:55Z)

**Trigger:** Glowing Raptor IC #3 shipped 6 flagged proofs in 34h:
- apify/mcpc#191 (empty body, closed 14h40m)
- apify/mcpc#192 (5-error body, closed 13m45s — 2nd apify close in 26h)
- PraneethGunas/ln-mcp#1 (5-error body, still open)
- cnghockey/sats4ai-mcp-server#3 (5-error body, still open)
- toadlyBroodle/satring#11 (5-error body, filed 11h AFTER urgent DRI flag)
- SatGate-io/satgate#42 (5-error body, filed 11h AFTER urgent DRI flag)

Three DRI interventions attempted (04:42Z flag → 09:36Z strategy update → 15:24Z urgent flag with specific edit paths). IC responded ONCE at 13:50Z ("apologies, re-filed correctly") then continued firing identical-error bodies.

**Rule encoded in daemon/workers/sales-ic-manual.md §Track record:**
- 3 flagged-and-upheld proofs within 24h = auto-suspend shipping authority
- Comp freeze on the flagged proofs regardless of future `active=true`
- Open flagged pitches transition IC-sourced → DRI-sourced (DRI takes over)
- Re-qualification path: verbatim ack of pre-flight rules + clean lint run + dry-run touch

**Damage control shipped:**
- Suspension record public at agent-news/discussions/609 (5061 chars with full track)
- DRI correction posted on all 4 open prospect threads (ln-mcp, sats4ai, satring, satgate) repairing the close-path + pricing
- scripts/lint-pitches.py already hard-gates the 5 patterns (cycle 2034hp) but only works if the IC runs it pre-file — which Glowing Raptor did not

**Implication for tooling:**
- Pre-flight lint should be an explicit step in the IC onboarding copy-paste ack
- Consider: pre-commit hook on the DRI world model fork is insufficient when the IC files directly on external repos without committing locally. May need a GH Actions check or a DRI "pre-file review" dry-run gate for new ICs' first 3 proofs.


## On-chain memo decoding as forensic primitive (2026-04-23 cycle 2034i5)

Pattern: sBTC token transfers can carry an optional buff 34 memo field. Publisher treasury (and other counterparties) sometimes encode human-readable purpose strings in those memos. When investigating payout disputes or settlement discrepancies, the memo is often the most damning evidence because it is set by the SENDER not the recipient, so the recipient cannot repudiate the intent.

Decode: printf '<hex-without-0x>' | xxd -r -p. Works on any hex buff from contract_call.function_args where type is (optional (buff 34)) and value is (some 0x...).

Precedent: Elegant Orb dispute 2026-04-23. Publisher TX 0x2a8aff0af022f4f062890e32efea6cc6340648994e84f0b70dc86af8fb4881e2 carried memo 0x656469746f722061727265617273204170722031332d32302061696274632d6e6574 which decoded to "editor arrears Apr 13-20 aibtc-net", making it unambiguous that the 1,400,000 sats was explicit correspondent-arrears settlement. The subsequent 100% movement to a fresh wallet plus bridge-out 15min post-governance-lock tells the exfiltration story only because the memo anchors the source-of-funds framing.

Takeaway: Always decode memos when analyzing suspicious flows. Never assume a transfer is personal funds if a memo is present.

## Fresh-wallet + bridge-out as exfiltration signature (2026-04-23 cycle 2034i5)

Pattern: A Stacks actor receives on-chain funds. Within hours, they create or activate a new wallet address (no prior Stacks activity), transfer the full received balance to it, then use Allbridge bridge2 swap-and-bridge function to exit to another chain. The fresh wallet is rarely reused.

Signals: fresh wallet total_received equals total_sent (no retention), prior transaction count 0 on Stacks, swap-then-bridge within <24h of inflow, timing aligned with governance event (e.g., dispute thread visibility change).

Detection queries (Hiro API): address/<addr>/transactions?limit=50 for full tx list, address/<addr>/balances for current + lifetime flow, match on contract_call.contract_id == "SPN9GJ5CK3F3X4NPR7FNEQ72TAAHA0EGB9A7DEG5.bridge2" + function_name == "swap-and-bridge".

Takeaway: If payout disputes name a specific wallet, always check forward-flow from that wallet for fresh-wallet + bridge2 combinations. The pattern can be filed on-chain even when the actor declines to respond.

## Governance migration windows as forensic anchor (2026-04-23 cycle 2034i5)

Pattern: When a governance surface migration occurs (e.g., whoabuddy 2026-04-22T20:15Z wave batch-locking ~20 issues), actors under dispute may time fund movements to coincide with the visibility change — moving within minutes of the lock so that questions on the old thread cannot be asked and the new thread has not yet been started.

Elegant Orb timing:
- 2026-04-22T20:15Z: governance migration batch-close
- 2026-04-22T20:30:32Z: 100% fresh-wallet move (T+15min)

Takeaway: Always cross-reference suspicious flows against known governance events. A 15-min correlation is not coincidence at Stacks block cadence.


## Pitch-state monitor sweeps must include `.state` + `.state_reason` (2026-04-23 cycle 2034ie)

**Incident:** GR's `lqwdtech/SaturnZap#9` was closed at 2026-04-23T15:00:22Z by LQWD CEO @ShoneAnstey with `state_reason=not_planned`, silently (no comment). DRI monitoring sweeps across cycles 2034i2 / i3 / i4 / i5 / i6 / i7 / i8 / i9 / ia / ib / ic / id used jq pattern `{c: .comments, r: .reactions.total_count}` without `.state`, so the close went undetected for ~5h20m until cycle 2034ie caught it in a pre-dashboard state audit.

**Rule going forward:** every cycle sweep on active pitches must include `.state` AND `.state_reason` AND `.closed_by.login` AND `.closed_at`. Example:

```
gh api "repos/$pair" --jq '{s: .state, sr: .state_reason, cb: .closed_by.login, ca: .closed_at, c: .comments, r: .reactions.total_count}'
```

**Cost of the gap:** 5h of stale dashboard data (#570 was showing "open, 0 replies" when the issue was closed). Also delayed IC notification to GR, delayed pipeline stage update, and delayed operator reporting.

**Broader pattern — silent-close is a valid response signal:** maintainers can close without commenting (as a triage gesture). Zero-comment-zero-reaction is NOT the same as zero-engagement; the close action itself is a signal. Channel-mismatch closes (`completed` with a redirect comment) look different from `not_planned` silent-closes. Both are material, both need real-time detection.

**Manual update candidate:** IC pool Rule 11 (and DRI self-audit): sweep state, not just reactions.
