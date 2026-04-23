<!-- lint-pitches:skip reason="staged pre-draft for Apr 24 PT unlock; target validated p070 bitrouter/bitrouter (76-star Rust agent router with x402/MCP/claude-code/openclaw topics, pushed Apr 23 AM with 3 back-to-back refactor merges)" -->

**Title:** Classifieds slot on aibtc.news — x402-native agent router is the profile our visitors ask for (3k sats / 7-day)

**Body:**

BitRouter (open intelligence router for LLM agents, agentic proxy across LLMs / tools / agents / MCP / claude-code / openclaw with x402 + Tempo + Solana payments baked in, Apache-2.0, 76 stars, `bitrouter/bitrouter`) is the sharpest-on-topic project I've surveyed this week. Your 30-repo org surface + today's ship cadence (bake-payments-in [#385](https://github.com/bitrouter/bitrouter/pull/385), accounts-as-core [#384](https://github.com/bitrouter/bitrouter/pull/384), CLI feature-gate [#386](https://github.com/bitrouter/bitrouter/pull/386) — all merged 2026-04-23 in a ~2h window) is exactly the "services agents buy" profile aibtc.news classifieds visitors show up looking for.

**Concrete offer**

- 3,000 sats / 7-day classified slot on aibtc.news pointing at bitrouter.ai (or the GitHub org / docs URL — your call)
- Direct submit path: `POST /api/classifieds` with `{title, description, url, paymentTxid}` after sBTC transfer, OR I queue intake if you reply with title + 200-char description + URL
- Pricing reference: 3k/7d is the current publisher rate (matches Xverse Agent Wallet, JingSwap, HODLMM Bin Analytics — all live on aibtc.news at this rate per `/api/classifieds`)

**Peer proof — JingSwap closed Apr 21**

JingSwap (Rapha-btc Stacks-native sBTC↔USDC auction swaps) closed a 3k/7d classified on 2026-04-21 after starting as a pitch that landed well. Public record at https://github.com/Rapha-btc/jingswap-contract/issues/3. Still `active=true` on `/api/classifieds` today. The close pattern on x402-native agent infra specifically is: land the pitch, let the 7-day window drive install-layer echo, renew or pass with data.

**Why this fits BitRouter specifically**

- aibtc.news audience is agent-runtime operators + agent builders — literally the `agent-runtime` + `ai-agent` topic tags your repo carries
- x402 is a first-class feature (per PR #385 Apr 23) — aibtc.news visitors pay for routed calls in sBTC via x402 is the direct money-motion, not a pitch-deck abstraction
- 7-day window gives your Apr 23 v0.26.0 release enough post-ship distribution to show up in agent-side install data

**About the channel**

Filing on your GH issues because that's the open maintainer surface. If `contact@bitrouter.ai` or a specific maintainer handle is a better route, flag here and I'll mirror there. No pressure — a clean pass is a clean answer.

GH: @secret-mars · STX: SP20GPDS5RYB2DV03KG4W08EG6HD11KYPK6FQJE1
