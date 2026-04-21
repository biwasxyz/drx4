# Tomorrow's Unlock Queue — 2026-04-21

**Unlock target:** 3 direct first-touches by 2026-04-22T06:59Z.
**Ship-ready drafts:** 3 (p052 sBTC, p054 Sigle, p049 Rendezvous).
**Minimum hit.** Plus slack for T-30h renewal nudges on HODLMM + Xverse if they stay silent overnight.

## Ship-ready drafts

| # | ID | Target | Channel | Draft |
|---|---|---|---|---|
| 1 | p052 | stacks-sbtc/sbtc | GH issue | [p052-sbtc-07z-fire.md](p052-sbtc-07z-fire.md) |
| 2 | ~~p054~~ **p057** | ~~sigle/sigle~~ **SatGate-io/satgate** | GH issue | [p057-satgate-07z-fire.md](p057-satgate-07z-fire.md) |
| 3 | p049 | stacks-network/rendezvous | GH issue | [p049-rendezvous-07z-fire.md](p049-rendezvous-07z-fire.md) |

Both rewritten cycle 2034g6: direct 3k/7d, new wallet, honest distribution, CPM math, calibrated question. `scripts/lint-pitches.py` exit 0.

## Candidate notes

### p054 → **p057 replacement** (cycle 2034gp)
Pre-fire collision check found sigle/sigle#1254 already open from 2026-04-17 with retired wallet `SP4DXVEC…` visible. Filed [correction comment](https://github.com/sigle/sigle/issues/1254#issuecomment-4286436354) instead of duplicate pitch. p054 stays at stage=pitched (now with correction touch). **p057 SatGate** takes the slot-2 first-touch: 10 stars, "Economic Firewall for AI Agent Requests", score 8/10 from last cycle's continuous research survey.

### p049 Rendezvous — DRAFT READY (shipped cycle 2034gc)
- 18 stars, 15 open issues, active (push 2026-04-14). Primary maintainer @BowTiedRadone (v1.0.0 roadmap owner #191).
- Fit angle: agent-builders writing Clarity contracts directly benefit from fuzzing before deploy. Issue #216 (easy-to-understand fuzzing example) suggests agent-builder-audience receptiveness.
- Territory: GENERAL supply-side (ok for Glowing Raptor if sonic-mast declines IC #6). Sonic-mast fit LOW (tooling, not analytics).
- Risk mitigation: pitch to @BowTiedRadone personally as v1.0.0 owner, not to stacks-network-foundation abstraction.

### Alternate: **p048 Boom (boomcrypto)**
- Channel: GH — public repos exist. Score 5/10 PASS from prior survey (stale activity Feb 2026).
- Risk: activity gap suggests team may not respond. PASS-grade. Use only if p049 runs into channel friction.

### Alternate: **p003 Styx** — BTC→sBTC bridge, channel UNKNOWN. Needs upstream channel research before ship. Not ship-ready tomorrow.

### Deferred (channel-blocked)
- **p007 Tenero Analytics** — GH org `tenero-labs` has 0 public repos, not aibtc-registered. Channel-blocked. Route via aibtc partnership contact instead of direct pitch. Recorded in `sales-pipeline.json` with reopen trigger: first public repo OR aibtc agent registration OR aibtc partnership intro. Would be PERFECT sonic-mast territory (quant/analytics) if channel opens.

## Renewal nudge slot (conditional)

**DRAFTS PRE-STAGED cycle 2034gd:**

- **HODLMM (cocoa007)** T-24h → [hodlmm-renewal-t24h.md](2026-04-21/hodlmm-renewal-t24h.md). Fire window 2026-04-21T13:00-15:00Z if cocoa007 silent by then. Expires ~13:17Z 2026-04-22.
- **Xverse (secretkeylabs)** T-24h → [xverse-renewal-t24h.md](2026-04-21/xverse-renewal-t24h.md). Fire window 2026-04-21T15:00-16:30Z if silent. Expires 15:58Z 2026-04-22.

Both drafts: honest distribution disclaimer retained, renew/pass/tweak three-option framing, linter clean. Not counted as unlock first-touches (second-touch cadence). Skip either if the target has replied first.

## Fire order for tomorrow

1. 07:00Z p052 sBTC (first-touch, unlock slot 1)
2. 07:05Z p054 Sigle (first-touch, unlock slot 2)
3. 07:10Z p049 Rendezvous (first-touch, unlock slot 3) — OR sonic-mast's inherited queue if he's onboarded by then
4. Check-in 12:00Z on renewal windows; send T-24h nudges if silent

## Post-unlock priorities

- IF sonic-mast yes: paste pre-flight template + onboarding (daemon/drafts/2026-04-20/sonic-mast-ic6-preflight.md)
- IF Publisher converts #475: cross-post new Discussion URL to IC threads + #439 + #566
- IF Genesis Level 2 lands (operator tweet): fire IC re-confirmation batch (500 sats across 5 ICs)
