# DRI Active — current task state

## Current

```
status: idle
last_completed: cycle 2014b (operator-initiated) — crm-dashboard-rewrite. Deployed version 82eb9f37. Plain-English + mobile-responsive. 7/7 verification checks passed (narrative, headings, plain-English column, no raw endpoint as primary, viewport meta, data-labels, /api/pipeline unchanged).
commitments_outstanding:
  - Nostr post #correspondent-guild referencing signal #144 + methodology (deadline 2026-04-15T13:43Z)
open_design_items:
  - Sales-DRI worker template (daemon/workers/sales-dri.md) + sales-pipeline.json schema — operator approved in principle, not yet built
```

## Format

```
cycle: <N>
started_at: <ISO>
worker_kind: <bff-skill | news-signal | gh-triage | inbox-triage | bug-fix | crm-update | protocol-notify | research | one-off>
subagent_type: <worker | general-purpose | Explore>
isolation: <worktree | none>
task: <one-line goal>
expected_artifact: <PR URL | signal ID | commit SHA | listing ID | thread IDs | deployed-worker-version>
deadline: <cycle N+1 soft, N+3 hard>
status: <dispatched | verifying | done | failed>
worker_summary: <populated after worker returns>
verified_at: <ISO>
```

## Lifecycle

1. Orchestrator: Phase 2 triage picks task → writes this file with status=dispatched.
2. Orchestrator: Phase 3 spawns Agent with prompt from `daemon/workers/<kind>.md` (or inline for one-offs).
3. Worker runs, returns summary.
4. Orchestrator: Phase 4 sets status=verifying → runs `curl -sI`, `gh pr view`, `news_list_signals` etc.
5. If verified: status=done, append shipped line to outputs.log, clear `Current` block back to idle.
6. If failed: status=failed, worker_summary holds failure reason.

## Anti-drift

- If `status=dispatched` for 2+ consecutive cycles, worker stuck or verify forgotten.
- If `status=failed` 3x on same task kind, write a learning, skip that kind for the day.
- If a worker returns "skipped with reason" on a task kind 2x in a day, treat that target as blocked and pick a different one next cycle.
- Worker-made commitments in outgoing messages MUST be mirrored in NORTH_STAR backlog immediately with deadline, or they get lost in context compaction.
- Operator-initiated mid-cycle tasks count as cycle output — log them with a "b" suffix (e.g., cycle 2014b) to preserve timeline continuity.
