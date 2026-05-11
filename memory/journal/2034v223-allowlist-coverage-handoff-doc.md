# cycle 2034v223 — allowlist coverage timing + handoff doc 404 surfaced on #738

## Context
v222 sealed at 17:36Z. Next wake at 18:08Z (1800s). Polled cluster, confirmed:
- 4 non-trading-comp PRs merged since #754 filed (`#753`, `#749`, `#748`, `d486a78d` align-503)
- Trading-comp cluster still untouched

## Decision: hold the nudge, deepen the review instead
v222 set a threshold ("2-3 non-trading-comp PRs"). It's now 4. But posting a "ready when you are" on #738 is just noise — whoabuddy clearly knows about the cluster. Better use of the time: deeper code-read on #738's substrate.

## What I found
Deep-read of `lib/competition/allowlist.ts` on #738 branch:

1. **Allowlist coverage is 4/21+** — current `BITFLOW_ALLOWLIST` has:
   - 1 stableswap pool (source comment says 6 total in handoff doc)
   - 1 xyk-core
   - 1 xyk-swap-helper (the provider-arg one, correctly pinned via `PROVIDER_ATTRIBUTION_CONTRACTS`)
   - 1 dlmm-swap-router
   - 0 cross-DEX routers (source comment says 12 total at `SPQC38…`)
   Source comments at lines 38 + 70 explicitly say "remaining N pulled from the comp-attribution gist as a follow-up commit on this branch."

2. **PHASE-3.1-HANDOFF.md is referenced but missing** — PR body says `[PHASE-3.1-HANDOFF.md](./PHASE-3.1-HANDOFF.md)`. `allowlist.ts:9` cites it too. But `gh api git/trees feat/competition-read-routes` returns no match. Probably a local working doc that didn't get committed.

3. **ALEX/Zest framing in #510 PR description is scope-leaky but agent-surface-honest** — `competition.tools.ts:1-22` (the MCP tool description agents see) just says "P&L from on-chain trades", no protocol claim. The "Bitflow/ALEX/Zest" claim is only in #510's PR description. Confusion is internal-PR-context only, not external-tool-consumer.

## Posted as 1 comment on #738 (issuecomment-4423478754)
Two clarifying observations + ALEX/Zest framing note. Non-blocking — both are operational follow-ups a maintainer wants at merge time, not pre-merge fixups.

## Why post on #738 (not #754)
- Both findings are internal to #738's diff (allowlist scope + handoff doc).
- #754 is for cross-PR coordination (merge-order + collision); these are not cross-PR.
- Right surface for the maintainer who'll act on them.

## Posture observation
v222 hypothesized "Phase 2.5 cleanup before Phase 3.1 trading-comp" as whoabuddy's sequencing. v223 evidence: 4 inbox PRs merged in ~2h since #754. Strong support for the hypothesis. The merge of #738 will signal "Phase 2.5 closed, Phase 3.1 starting." Nothing to do but wait.

## Time
~6 min from boot to ship (poll → read allowlist source + tool description + handoff link check → write → comment → verify → sync).
