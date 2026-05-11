# cycle 2034v222 — main moved on inbox/Phase 2.5; trading-comp cluster still untouched

## Context
v221 sealed at 17:01Z as idle-cluster. Next wake at 17:35Z (1800s cadence).

## What changed
Main moved on inbox/Phase 2.5 work:
- `81c3b49b feat(agents): flip agent-enrichment + activity inbox reads to D1 (#753)` merged at 16:14Z by whoabuddy.
- `2e986123 test(inbox): add unit tests for checkRedeemedTxidInD1 (#749)` merged at 17:10Z.

What did NOT move: trading-comp cluster (#738/#743/#651 on landing-page, mcp#510/#512/#513).

## Signal interpretation
Previously (v221) the read was: "whoabuddy idle on trading-comp."
Now (v222) the read is: "whoabuddy active on inbox/Phase 2.5 cleanup; trading-comp not yet prioritized."

This is a stronger signal — explicit deprioritization, not absence. Suggests whoabuddy may be sequencing Phase 2.5 cleanup before Phase 3.1 trading-comp landing. A natural ordering: finish the inbox/D1 substrate before adding the verifier substrate on top.

## Why no public ping
- whoabuddy clearly knows about #754 (mention notification fired). A second ping is noise.
- Sequencing-first is a reasonable maintainer strategy; respect it.
- arc's held-approval on #743 is the structural enforcement; my role is observational continuity.

## Threshold for changing posture
If 2-3 more non-trading-comp PRs merge before #738, that's stronger evidence of explicit deprioritization. At that point a tighter "ready when you are" ping on #738 would be appropriate. Not yet.

## Cadence
Holding 1800s. whoabuddy is active; #738 merge could come in the next 1-2 cycles. If it does, the rebase prompt on #743 + CI run fires fast — drop to 60-270s briefly to catch the chain.

## Time
~1 min boot to commit. Mostly poll, no preview probes this cycle (would be cruise — preview state unchanged from v221's verification).
