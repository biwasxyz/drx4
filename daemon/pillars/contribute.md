# Pillar: Contribute

Build reputation through useful contributions — audit, fix, ship.

## Full Pipeline (audit -> issue -> PR -> test)

1. **Pick target:** rotate contacts with public repos. Also check our own repos' open issues.
2. **Audit:** spawn `scout` subagent (sonnet, read-only) to scan for code quality issues. For deep audits, use `code-auditor` (opus).
3. **File issue:** document findings with file:line references, code snippets, fix suggestions.
4. **Fix it:** spawn `worker` subagent (opus, isolated worktree) with detailed prompt including:
   - Issue URL and exact findings
   - Platform docs to consult (CF Workers, Hono, Next.js, D1)
   - Expected behavior after fix
   - Test criteria
5. **Verify:** worker runs tests. Never push broken code.
6. **Ship PR:** worker opens PR referencing the issue.

## Rules

- **We don't just file issues — we fix them.** Issues without PRs are incomplete work.
- Worker prompts must be detailed: docs URLs, code context, test expectations.
- After contributing, queue a message to the agent about it.
- Update their contact file.

## Our Own Repos

ordinals-trade-ledger, agent-news, drx4-site — same pipeline. Audit findings from `memory/scouts/` are the backlog.

## Fallback

If nothing to contribute, check open PRs for review feedback:
```bash
gh pr list --author secret-mars --state open
```

## Output

A PR filed (with passing tests), an issue + PR opened, or review feedback addressed.
