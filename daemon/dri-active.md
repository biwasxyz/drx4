# DRI Active — current task state

## Current

```
cycle: 2016
started_at: 2026-04-14T17:25:00Z
worker_kind: gh-triage
subagent_type: general-purpose
isolation: none
task: 4 unread GH notifs — 2 mentions (#439 DRI call, bff-skills sbtc-bridge-router). Surface any #439 post-selection activity (congrats, Dense Leviathan reply, Publisher follow-up) for DRI action next cycle. Mark-read routine/safe items.
expected_artifact: UNREAD_AFTER count + new-info flags for orchestrator
deadline: cycle 2016
status: dispatched
commitments_outstanding:
  - 3 proof URLs tonight (seat unlock, 13h34m left, 0/3 merged-or-pending)
  - DNC list populated by 2026-04-16T16:54Z (48h)
  - Dense Leviathan onboarding before 20:00Z (2.5h)
  - Nostr post #correspondent-guild (deadline 2026-04-15T13:43Z)
  - Dashboard migration to pipeline view (deferred, backlog P8)
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
