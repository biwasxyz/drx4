# Workers — the dispatch layer

The orchestrator (`.claude/loop.md`) does NOT do domain work. It triages and dispatches. Each domain task lives in a throwaway worker session spawned via the `Agent` tool so deep context (PR threads, signal research, codebase reads, CRM schema) stays out of the orchestrator's context window.

## Why

Compaction eats context. After 3-4 cycles of pulling GH threads + signal drafts + CRM JSON + inbox messages into one session, the orchestrator starts forgetting mid-cycle. Workers solve this by isolating heavy reads into sessions that return only a summary + verified artifact URL.

## Worker kinds

| Kind | Template | Agent type | Isolation | Typical output |
|---|---|---|---|---|
| `bff-skill` | `bff-skill.md` | worker | worktree | PR URL on BitflowFinance/bff-skills |
| `news-signal` | `news-signal.md` | general-purpose | none | Signal ID from news_list_signals |
| `gh-triage` | `gh-triage.md` | general-purpose | none | Summary of threads handled + read count |
| `inbox-triage` | `inbox-triage.md` | general-purpose | none | messageIds processed/marked |
| `bug-fix` | `bug-fix.md` | worker | worktree | PR URL on external repo |
| `crm-update` | `crm-update.md` | general-purpose | none | listing_id or route_id + diff |
| `protocol-notify` | `protocol-notify.md` | general-purpose | none | GH issue/comment URL |
| `research` | — | Explore | none | Findings summary |

## Orchestrator contract

1. **Pick ONE task.** Write it to `daemon/dri-active.md` BEFORE dispatching.
2. **Spawn via the Agent tool** (Claude Code native subagent dispatch — it's in the orchestrator's tool list, not a shell command). Set `subagent_type`, `isolation` (when code changes), `description`, and `prompt` (loaded from `daemon/workers/<kind>.md` with `{{variables}}` substituted). Fallback to `claude --print -p` via Bash only if the Agent tool is unavailable.
3. **Wait for return.** Worker summary includes: what shipped, artifact URL/ID, any failures.
4. **Verify externally.** Don't trust summary — `curl -sI` the URL, `gh pr view`, or `news_list_signals` before writing `shipped:`.
5. **Update state + clear dri-active.**

## What workers can do that orchestrator can't

Workers hold the entire context of their task. Examples:
- Read 5+ files to understand a bug before fixing
- Chase a GH thread through 40 comments to find the actual reviewer ask
- Pull primary sources for a signal and verify each URL
- Walk a failing test stack trace through imports

Orchestrator should never do these. If a task requires reading more than 1-2 files for context, dispatch it.

## What orchestrator ALWAYS does directly

- Briefing (`scripts/briefing.sh`)
- Heartbeat (1 sig + POST)
- Read STATE.md, health.json, NORTH_STAR.md
- Count unread inbox/GH (not content)
- Pick next task
- Verify artifact URLs
- Write STATE.md, health.json, dri-active.md
- Git commit + push
- TG report
- ScheduleWakeup

## Daily minimums tracked by orchestrator, shipped by workers

The orchestrator checks daily-minimum output gaps (BD / signal / BFF / distribution) and dispatches the right worker. It never drafts signal bodies or writes skill code itself.
