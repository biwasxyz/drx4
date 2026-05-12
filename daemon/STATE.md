# State -- Inter-Cycle Handoff
## cycle 2034v242 — lp#765 NonceDO trigger-semantics distinction (poll vs event driven)

cycle: 2034v242
at: 2026-05-12T03:12Z
status: shipped

## OPERATOR DIRECTIVE (active — /start args 2026-05-11)
> "we need to closely look into the prs and updates on the trading competition on both mcp and landing-page so we need to keep looking into the PRs review them test them using the preview url focus your 100% on those okay file an issue tag whoabuddy/arc"

## v242 ship
**lp#765 comment** (issuecomment-4427022875, verified 200) — biwasxyz filed #765 at 02:46Z (DO-alarm scheduler bridge follow-up to #738) cc'ing me + arc + whoabuddy. arc commented at 02:59Z covering subrequest budget, pattern consistency, cursor migration test, HTTPS shim keep. My value-add: anchoring my #764 v220 NonceDO-trigger-semantics finding (issuecomment-4426399994):
- NonceDO ACTIVE/IDLE is **event-driven** (deposit lands → pre-fetch work → ACTIVE schedule); verifier is **poll-driven** (no inbound event; every tick is same chunked sweep)
- So "find-rate adaptive interval" must be encoded from prior tick output (last_tick_new_swaps), not pending-work-in-storage
- Concrete trigger gate suggested: `interval = last_tick_new_swaps >= ACTIVE_GATE ? ACTIVE_MS : IDLE_MS` or EWMA
- Acceptance-criterion language tightening: "IDLE→ACTIVE after one tick with ≥X new swaps; ACTIVE→IDLE after K consecutive empty ticks" — producer/consumer-symmetric so impl can't diverge read+write sides
- +1 arc's explicit-migration-test + keep-HTTPS-shim (bed7cd0 ingestion-path-symmetry posture)

## Pending on resume (v240 carryover updated v242)
- whoabuddy/biwasxyz response on **lp#651** scope question (v241 comment 4426889296 surfaced 3 drifts)
- whoabuddy/biwasxyz/arc response on **lp#765** verifier-DO trigger-semantics finding (v242 comment 4427022875)
- **#738 merge** (bed7cd0 just landed comp-start gate; CLEAN mergeable) — primary cluster gate
- **biwasxyz rework** of #651 per #764 architecture (still pending)

## v242 boot SHA-compare
- lp#738 → `bed7cd0` (advanced from 37f53c6a — comp-start gate added)
- lp#765 → NEW (filed 02:46Z)
- lp#764 → unchanged, my 2 comments still standing
- lp#651 → unchanged since my v241 comment (head still d711c3a1)
- mcp#510/512/513 → unchanged
- main HEAD → unchecked this cycle

## Cadence
- 1800s. Tighten to 900s if engagement on #651/#765/#738.
