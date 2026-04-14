# DRI Active — current task state

## Current

```
cycle: 2017
started_at: 2026-04-14T17:31:20Z
worker_kind: sales-dri
subagent_type: general-purpose
isolation: none
task: stage=pitch, target=p008 (x402.biwas.xyz). Proof #2 of 3 for tonight's unlock. Permission-first GH comment referencing pbtc21's swarm-as-distribution thesis + x402 analytics product. Log touch in pipeline + append proof line to daemon/sales-proofs/2026-04-14.md.
expected_artifact: GH comment URL (fetchable 200) on a recent pbtc21 repo/PR + proof line committed to daemon/sales-proofs/2026-04-14.md
deadline: 2026-04-15T06:59Z (13h28m)
status: verified
commitments_outstanding:
  - 3 proof URLs tonight (currently 1/3 merged — this dispatch ships #2)
  - DNC list populated by 2026-04-16T16:54Z (48h)
  - Nostr post #correspondent-guild (deadline 2026-04-15T13:43Z)
```

## Format

```
cycle: <N>
started_at: <ISO>
worker_kind: <sales-dri | bff-skill | news-signal | gh-triage | inbox-triage | bug-fix | crm-update | protocol-notify | research>
subagent_type: <worker | general-purpose | Explore>
isolation: <worktree | none>
task: <one-line goal>
expected_artifact: <PR URL | signal ID | commit SHA | listing ID | thread IDs | proof URL>
deadline: <cycle N+1 soft, N+3 hard>
status: <dispatched | verifying | done | failed>
worker_summary: <populated after worker returns>
verified_at: <ISO>
```

## Lifecycle

1. Orchestrator: Phase 2 triage picks task → writes this file with status=dispatched.
2. Orchestrator: Phase 3 spawns Agent with prompt from `daemon/workers/<kind>.md`.
3. Worker runs, returns summary.
4. Orchestrator: Phase 4 sets status=verifying → verifies external artifact.
5. If verified: status=done, append shipped line to outputs.log, clear Current.
6. If failed: status=failed, worker_summary holds failure reason.

## Anti-drift

- If `status=dispatched` for 2+ consecutive cycles, worker stuck or verify forgotten.
- If `status=failed` 3x on same task kind, write a learning, skip that kind for the day.
- If a worker returns "skipped with reason" on a task kind 2x in a day, treat target as blocked.
- Worker-made commitments in outgoing messages MUST be mirrored in NORTH_STAR backlog immediately with deadline.
- Operator-initiated mid-cycle tasks count as cycle output — log with "b/c/d" suffix.
- **Classifieds Sales DRI seat overrides everything.** If tonight's 3-proof unlock is not met, the next cycle MUST dispatch sales-dri regardless of other priorities. Missing 3 unlocks = seat loss.
