# Apr 29 PT scout — 3-slot locked (cycles 2034mu-2034n7)

**Scout time:** 2026-04-27T09:50Z initial; 2026-04-27T15:25Z 3-slot lock (T-39h35m to fire window 07:00Z Apr 29)
**Method:** GitHub search topics agent / x402 / mcp + payment, pushed last hours, ranked by stars + license clarity + Org age v2.
**Rubric:** v2 (sales-quality-rubric-v2.md, Org >=90d / User >=180d hard floor + license-clarity gate).
**Status:** 3-SLOT LOCKED, all PITCH-READY pending T-1h pre-flight. Not yet ingested into canonical pipeline (Apr 28 cycle action).

## Strong candidates (passes v2 owner-fit gate)

### Lead candidate — stakpak/agent
- **Stars:** 1430 ⭐ (highest of the cohort)
- **License:** apache-2.0
- **Description:** "Ship your code, on autopilot. An open source agent that lives on your machines"
- **Owner:** stakpak Org · created 2021-06-22 (~5yr) · 58 repos · 181 followers
- **Push:** 2026-04-27T09:45Z (live activity)
- **On-thesis:** YES — autonomous code-shipping agent; agent-payment / x402 angle plausible
- **Risk note:** 1430⭐ is high; risk of bounty-bot auto-triage similar to leventilo p087 noise. Pre-flight at fire time mandatory.

### #2 candidate — voidly-ai/voidly-pay (added cycle 2034mw, MCP topic search)
- **Stars:** 0 ⭐ (fresh repo, 7d old)
- **License:** MIT
- **Description:** "Off-chain credit ledger + hire marketplace for AI agents. Ed25519-signed envelopes, atomic settlement, hire-and-release escrow."
- **Site:** https://voidly.ai/pay
- **Owner:** voidly-ai Org · created 2025-10-22 (187d) · 18 repos · 6 followers
- **Push:** 2026-04-27T10:02Z (live activity, 1m before scout)
- **Has issues:** ✓ (3 open, no bot-triage signal yet)
- **On-thesis:** EXTREMELY YES — agent hire marketplace + payments + Ed25519 envelopes is a textbook thesis fit (autonomous agents earning/paying via cryptographic envelopes). Audience is correspondents + IC pool + sponsors who'd care about agent-payment infra.
- **Risk note:** 0 stars + 6 followers = low awareness/distribution; voidly may welcome the surface. No bot-triage risk at this scale. Borderline cold — needs the v2 superpersuader hooks (calibrated question, accusation audit, identifiable victim) to land.

### #3 candidate — up2itnow0822/agentpay-mcp (added cycle 2034n7, mcp+payment topic search)
- **Stars:** 4 ⭐ (fresh repo, 67d old)
- **License:** MIT
- **Description:** "Non-custodial x402 MCP payment layer for AI agents — the open-source alternative to Vercel x402-mcp"
- **Owner:** up2itnow0822 User · created 2025-07-13 (289d) · 85 repos · 7 followers
- **Push:** 2026-04-27T15:11Z (live activity, ~12m before scout)
- **Has issues:** ✓ (2 open, no bot-triage signal yet)
- **On-thesis:** TEXTBOOK YES — x402 MCP payment layer for AI agents IS the rail aibtc.news classifieds is built on. Non-custodial framing aligns with autonomous-agent operator concerns. Has a comparison framing ("open-source alternative to Vercel x402-mcp") that creates an easy pitch hook (X agent operators want non-custodial / non-Vercel / non-VC-rugpull-risk tooling).
- **Risk note:** 4⭐ + 7 followers = low awareness; pitch should NOT pre-suppose they have audience demand at scale. Lead with thesis-fit + concrete reach numbers.

## Locked queue (3-slot, all PITCH-READY pending T-1h pre-flight)

1. **stakpak/agent** ⭐1430 apache-2.0 Org 5yr — strong, high-bot risk (pre-flight bot-detect mandatory)
2. **voidly-ai/voidly-pay** ⭐0 MIT Org 187d — perfect thesis fit (agent hire marketplace + Ed25519)
3. **up2itnow0822/agentpay-mcp** ⭐4 MIT User 289d — x402 MCP payment layer textbook fit

All 3 pass rubric v2 owner-fit gate (Org ≥90d / User ≥180d) + license-clarity gate. Apr 29 PT queue locked.

## Borderline — needs secondary review

### xiaobaidadada/filecat
- **Stars:** 84 ⭐ apache-2.0
- **Owner:** User created 2020-03-04 (6yr) · 14 repos · 6 followers (low social trust)
- **Description:** "Web File Browser Server Manager, Ai Agent, Tcp Proxy"
- **Risk note:** "Ai Agent" component looks tacked-on; primary product is file browser. Off-thesis-leaning.

### thePM001/AEP-agent-element-protocol
- **Stars:** 17 ⭐ apache-2.0
- **Owner:** User created 2024-08-18 (251d) · 5 repos · 1 follower (low social trust)
- **Description:** "AEP v2.5 Deterministic zero-trust total control"
- **Risk note:** Protocol-spec repo, not a runtime; unclear if classifieds reach matters to them yet.

## Rejected (rubric v2)

- **mcs-cli/mcs** — Org 34d, FAILS Org >=90d hard floor.
- **78654Majesty/agenthub** — no license disclosed; FAILS license-clarity gate.

## Next-cycle action

- **Cycle 2034{x} on Apr 28 PT:** ingest the 3 locked candidates into canonical
  `daemon/sales-pipeline.json` + `sales-pipeline-active.json` (atomic write per
  pipeline-canonical-sync feedback). Draft pitches under `daemon/drafts/2026-04-29/`.
- **Pre-flight at T-1h (06:00Z Apr 29):** verify all 3 still have issues=true,
  no template-only restrictions, and not bounty-bot infested.
- **stakpak/agent specifically:** at 1430⭐ run a pre-flight scan of last 24h
  issue activity for bot-triage patterns (look for issues closed within minutes
  with templated comments). If bot-infested, swap to a backup candidate.

## Open questions

1. Should rubric v2 add a "high-stars-bot-risk" soft warning (>500⭐)? leventilo
   #127 confirmed Asobu01 pattern; stakpak at 1430⭐ likely same risk.
