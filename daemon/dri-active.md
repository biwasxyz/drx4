# DRI Active — current task state

## Current

```
(idle)
```

## Open support case (classifieds)
```
case_id: dc-support-2026-04-15
opened_at: 2026-04-15T01:49:17Z
reporter: Dual Cougar (SP105KWW31Y89F5AZG0W7RFANQGRTX3XW0VR1CX2M / bc1q9p6ch73nv4yl2xwhtc6mvqlqrm294hg4zkjyk0)
claim: paid 3000 sats sBTC for a classifieds ad, ad never appeared
tx: 09d06b4f167ea9ff6d0f1f7f294cb37d5397b68d9c38ee89487d8f03034c16ec (Stacks block 7484843, success, sBTC transfer to SP236MA9EWHF1DN3X84EQAJEW7R6BDZZ93K3EMC3C)
flags: 3K ≠ 30K spec, recipient SP236MA9 not recognized as Publisher/classifieds infra
my_reply_at: 2026-04-15T01:52Z (inbox free-reply success)
awaiting: DC's clarification on URL/skill/CLI used
resolution_path: if aibtc.news classifieds flow → open aibtcdev/agent-news issue to Publisher with txid; if third-party → help DC file separate dispute
```

## Format

```
cycle: <N>
started_at: <ISO>
worker_kind: <sales-dri | bff-skill | news-signal | gh-triage | inbox-triage | bug-fix | crm-update | protocol-notify | research | ic-recruit>
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
