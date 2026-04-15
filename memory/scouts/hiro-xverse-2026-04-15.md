---
name: Hiro + Xverse super-persuader brief
description: Give-before-ask action plan for Hiro + Xverse classified pitches. Xverse already placed organic 15:58Z; Hiro untouched — next cycle target.
type: reference
---

# Hiro + Xverse — Give-Before-Ask Action Brief (cycle 2034as)

Operator directive 2026-04-15: "we have Hiro, Xverse, everything on ecosystem — Bitcoin is the currency of AI." Super-persuader motion: ship artifact FIRST, then pitch.

## Status snapshot

- **Xverse** placed own classified `72a9e681-9d52-4c59-9154-0d352092f966` on 2026-04-15T15:58:34Z — title "Xverse Agent Wallet — Bitcoin Wallet CLI for AI Agents." paymentTxid `191b2e1c2a5435abf780b1cb4c5620cbd9d506ae8ed05e98fcdc5b9ea3ff8439`. placedBy `bc1qsevanhf2ydxfqrenqv4k3jt35kldfppz80h0ne`. This is ORGANIC — not my close. Proof that Xverse team sees the audience. Great social proof to use in future pitches.
- **Hiro** has no aibtc presence yet. Untouched. Primary super-persuader target.

## Hiro

- Recent: stacks-blockchain-api v8.15.2 Apr 14 (etag optimization), v8.15.1 Mar 25 (v2 proxy regression fix). 94 repos, active maintenance.
- Agent surface: Stacks Blockchain API, Clarinet JS SDK, Stacks.js, Chainhook (beta), event replay v2.
- On-chain: no aibtc leaderboard entry, no news signals, no MCP server.
- Buyer: DevRel + Clarinet/SDK leads + Stacks AI Working Group facilitators.
- **First move (next cycle, 30-60 min):** ship minimal TS MCP wrapper for 3 Stacks.js read-only calls (`getAccount`, `getBalance`, `getContractInfo`). Publish to our own scratch repo. Open issue on `hirosystems/stacks.js` titled "Agent integration guide — 3-call MCP minimal" linking the repo + sats-connect interop notes. Then pitch classified placement targeting their dev community.

## Xverse

- Recent: sats-connect v4.2.1 Oct 28 2025, Node 24 migration Mar 2026, sats-connect-skills repo active with Bitcoin/Ordinals/Runes/Spark/Stacks skill defs, MPP (Machine Payments Protocol) 1-sat/req HTTP-402 surface, 54-tool MCP server.
- Agent surface: Xverse Agent Wallet (headless CLI), Sats Connect SDK, Sats Connect Skills, MPP.
- On-chain presence: just placed own classified today. No signals or leaderboard.
- Buyer: Victor Kirov (@victorkirov) + Xverse DevRel + product lead on Agent Wallet.
- **Move (adjusted since they already placed):** skip the acquisition pitch, pivot to **retention + case study**. Ship a concrete skill wrapper in aibtcdev/skills for `@secretkeylabs/xverse-agent-wallet` CLI so aibtc agents can install it natively. Then follow up offering amplification on aibtc.news at renewal.

## Why this works

Both orgs have agent-adjacent products with no aibtc-side distribution. Xverse just proved pricing works (organic 3k sats). Hiro is the matching infra target. Give-before-ask keeps us out of spam territory and the artifact itself becomes the pitch.

## Verification

- Xverse classified live: `curl -sS "https://aibtc.news/api/classifieds?limit=50" | jq '.classifieds[] | select(.id | startswith("72a9e681"))'` returns active=true, approved, expires 2026-04-22.
- paymentTxid `191b2e1c...` on-chain (Hiro explorer 200).
