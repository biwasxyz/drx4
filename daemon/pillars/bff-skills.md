# Pillar: BFF Skills (PRIMARY — daily submission)

Submit 1 quality DeFi skill per day to `BitflowFinance/bff-skills`. Win daily $100 + HODLMM bonus.

**Repo:** `/home/mars/bff-skills/` (fork)
**Format:** `/skills/{skill-name}/` containing `SKILL.md`, `AGENT.md`, `{skill-name}.ts`
**PR title:** `[AIBTC Skills Comp Day X] Skill Name`
**Deadline:** 11:59 PM PDT daily

## Skill Development Pipeline

1. **Research (30 min):** Read protocol docs, check existing submissions (no dupes), understand the DeFi primitive. WebFetch protocol APIs, read contract source.
2. **Build (60 min):** Write `.ts` implementation with:
   - `doctor` command (env/wallet checks)
   - `run` command (core execution)
   - `install-packs` command (if applicable)
   - JSON output: `{status, action, data, error}`
   - Real safety controls IN CODE (spend limits, confirmation gates, refusal logic)
3. **Test (30 min):** Run all commands locally. Get on-chain proof (real mainnet tx).
4. **Document:** Fill SKILL.md (frontmatter + description + safety) and AGENT.md (decision order + guardrails).
5. **Submit:** PR with smoke test output, frontmatter validated, on-chain proof linked.

## SKILL.md Format (CRITICAL — CI rejects bad format)

- Frontmatter MUST use nested `metadata:` block (not flat top-level)
- Tags: comma-separated string `"l2, read-only"` (NOT YAML array)
- `user-invocable`: string `"true"` (NOT boolean)
- Required under metadata: author, author-agent, entry, user-invocable, arguments, tags
- Reference: SKILL_TEMPLATE.md in bff-skills repo

## Quality Rules

- Build from real usage. Every skill from something we actually do on-chain.
- On-chain proof mandatory. Real tx hash.
- Safety controls in code. Not just docs.
- Test before submit. All commands produce clean JSON.
- Research the protocol. Read actual contract source.

## Day Tracking

Compute day from start date (2026-03-25). Check `project_bff_skills_comp.md` before submitting.
Update health.json: `bff_skills.submitted_today`, `total_submitted`.

## HODLMM-Eligible Ideas (bonus $100)

- Bitflow HODLMM position manager
- HODLMM yield optimizer
- HODLMM risk monitor
