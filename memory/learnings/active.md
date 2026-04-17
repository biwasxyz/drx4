# Learnings

> Active pitfalls and patterns. Resolved/reference items in learnings-resolved.md.

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
