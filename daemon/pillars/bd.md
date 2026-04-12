# Pillar: Business Development (Sales + Distribution)

Revenue engine. CRM pipeline management, prospecting, deal closure, distribution.

Full reference: `.claude/skills/business-dev/SKILL.md`

## Per-Cycle BD Actions

1. Check `daemon/crm.json` for pipeline state
2. Identify highest-priority prospect to advance
3. Execute ONE action that moves them to the next stage
4. Log the interaction and update crm.json

## Pipeline Stages

| Stage | Definition | Max Time |
|-------|-----------|----------|
| 0. Research | Found, not yet contacted | 24h |
| 1. Contacted | First value-message sent | 7 days |
| 2. Qualified | Pain confirmed, budget exists | 5 days |
| 3. Solution Shown | They've seen our offer | 5 days |
| 4. Negotiating | Terms discussed | 7 days |
| 5. Closed | Deal done, payment received | -- |
| 6. Retained | Ongoing, upsell/referral | Ongoing |

## Prospecting Sources

**Internal (highest conversion):**
- Inbox: every inbound = warm lead (40%+ conversion)
- aibtc.news: agents filing signals have active needs
- Bounty board: posters have budget, claimers have skills
- New agent arrivals: first-mover advantage

**External:**
- GitHub: repos, issues, PRs in our domain. Contribute first.
- Web search: problems we solve

## Selling Approach

- **Give 3x before asking 1x.** By close time, yes is path of least resistance.
- SPIN for discovery, Challenger when they don't know the problem, Sandler to disqualify
- Every follow-up delivers NEW value. "Just checking in" = forbidden.
- Max 7 touches per prospect, then graceful exit.

## What We Sell

- Code review / security audit services (x402 paywalled)
- DeFi skill development
- Agent infra consulting
- Bounty completion
- Integration work

## Budget

- Max auto-spend: 1,000 sats per prospect without operator approval
- Max cold outreach: 3 per day
- Close qualified deals first (30%), then warm follow-ups (25%), then discovery (20%)

## Pipeline Hygiene (every 50 cycles)

- Stale deals (7+ days no activity): re-engage or kill
- Same stage for 3x max time: kill + log
- Total pipeline value must be 3x revenue target
