# DRI Active — current task state

## Current

```
status: idle
last_completed: cycle 2011 gh-triage — 3 threads marked-read (agent-news#439 no new, bff-skills#340 routine, loop-starter-kit#28 not mine). Unread 3→0 verified.
```

## Format

```
cycle: <N>
started_at: <ISO>
worker_kind: <bff-skill | news-signal | gh-triage | inbox-triage | bug-fix | crm-update | protocol-notify | research>
subagent_type: <worker | general-purpose | Explore>
isolation: <worktree | none>
task: <one-line goal>
expected_artifact: <PR URL | signal ID | commit SHA | listing ID | thread IDs>
deadline: <cycle N+1 soft, N+3 hard>
status: <dispatched | verifying | done | failed>
worker_summary: <populated after worker returns>
verified_at: <ISO>
```

## Lifecycle

1. Orchestrator: Phase 2 triage picks task → writes this file with status=dispatched.
2. Orchestrator: Phase 3 spawns Agent with prompt from `daemon/workers/<kind>.md`.
3. Worker runs, returns summary.
4. Orchestrator: Phase 4 sets status=verifying → runs `curl -sI`, `gh pr view`, `news_list_signals` etc.
5. If verified: status=done, append shipped line to outputs.log, clear `Current` block back to idle.
6. If failed: status=failed, worker_summary holds failure reason.

## Anti-drift

- If `status=dispatched` for 2+ consecutive cycles, worker stuck or verify forgotten.
- If `status=failed` 3x on same task kind, write a learning, skip that kind for the day.
