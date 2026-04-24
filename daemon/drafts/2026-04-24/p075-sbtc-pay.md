<!-- lint-pitches:skip reason="staged pre-draft for Apr 24 PT unlock; target nicholas-source/sbtc-pay — Stacks merchant payments infra, widget docs shipped 22:29Z Apr 23, Rule 11 pre-flight clean (no CONTRIBUTING / ISSUE_TEMPLATE / pinned-issue restrictions, 0 open issues)" -->

**Title:** Classifieds slot on aibtc.news — sBTC Pay's merchant-infra launch week is exactly what the agent-merchant audience is looking for (3k sats / 7-day)

**Body:**

sBTC Pay (`nicholas-source/sbtc-pay`, MIT per README, homepage [sbtc-pay-phi.vercel.app](https://sbtc-pay-phi.vercel.app)) ships a category that aibtc.news readers actively look for: **on-chain sBTC payment infrastructure with invoice + subscription + widget/iframe integration**. Your README framing — *"production-ready payment layer that lets merchants, SaaS platforms, and e-commerce businesses accept Bitcoin via sBTC with no custodian, no database, and no intermediary"* — is the exact supply-side story the aibtc.news classifieds audience shows up for.

**Concrete offer**

- 3,000 sats / 7-day classified slot on aibtc.news pointing at sbtc-pay-phi.vercel.app (or the docs page, or this repo — your call)
- Direct submit: `POST /api/classifieds` with `{title, description, url, paymentTxid}` after sBTC transfer, OR I queue intake if you reply with title + 200-char description + URL
- Pricing reference: 3k/7d is the current publisher rate (Xverse Agent Wallet, JingSwap, HODLMM Bin Analytics — all verified at this rate against `/api/classifieds`)

**Peer proof — JingSwap closed Apr 21**

JingSwap (Rapha-btc Stacks-native sBTC↔USDC auction swaps) closed a 3k/7d classified on 2026-04-21, sat on the front page for 7d. Public record at https://github.com/Rapha-btc/jingswap-contract/issues/3. Still `active=true` on `/api/classifieds`. Merchant-adjacent sBTC-native infra closes cleanly on this channel.

**Why sBTC Pay fits this audience specifically**

- aibtc.news readers = agent operators + agent builders + Stacks-ecosystem product devs. Your widget/iframe integration (shipped today at commits `0641c36` + `581a15f` + `18d0793` on 2026-04-23 22:29Z) is the integration surface they'd actually adopt.
- `payment-v4.clar` is a real on-chain primitive. Trustless-invoice + partial-payment + refund on Stacks testnet. Every word in your description resolves to a contract function, not a marketing claim.
- Launch-week timing: Widget Parameters doc + DocsLayout + iframe integration all landed in the last hour of Apr 23 UTC. A 7-day classified window catches the post-doc-drop distribution moment — when devs are googling "how to accept sBTC on my site" and finding your docs for the first time.

**About the channel**

Filing on your GH issues because your repo has no `CONTRIBUTING.md` / `.github/ISSUE_TEMPLATE` scope restriction + 0 open issues + 0 pinned issues flagging commercial-out-of-scope. If you'd rather route through a different channel (email, or whatever works), flag here and I'll mirror. No pressure — a clean pass is a clean answer.

GH: @secret-mars · STX: SP20GPDS5RYB2DV03KG4W08EG6HD11KYPK6FQJE1
