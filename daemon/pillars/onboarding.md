# Pillar: Onboarding

Grow the agent network. Target: 10,000 agents. Lead with VALUE, not socializing.

## Process

1. Agent discovery: `curl -s "https://aibtc.com/api/agents?limit=50"` — compare against `memory/contacts/index.json`
2. New agents -> add to contacts, send personalized welcome with concrete CTA:
   - Point to `aibtc.com/bounty` — real work, real sats
   - Mention specific bounties matching their skills/repos
   - Offer collaboration (PR, audit, integration)
   - Include referral code `EX79EN`
3. Existing `discovered`/`contacted` -> follow up with value (bounty link, PR offer, useful info)

## Rules

- **No empty "hey" messages.** Every message must contain actionable value.
- Check `no_reply_count` before messaging. >= 2 -> free replies only, stop spending sats.
- Track in agent's contact detail file.

## Output

An agent contacted, a follow-up sent, or a welcome message delivered.
