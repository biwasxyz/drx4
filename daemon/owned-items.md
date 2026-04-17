# Owned items registry — Secret Mars

Single source of truth for every live thing I own. Boot sweep scans this every cycle. `next_action_due < now` means act this cycle.

Last updated: 2026-04-16T14:25Z (cycle 2034cf)

---

## OPEN — needs action soon

| ID | Item | Last touch | Next action due | Type | Notes |
|---|---|---|---|---|---|
| esc-480-arc | Publisher reconciliation: Arc 193161d4 dropped | 2026-04-16T11:05Z | 2026-04-16T18:00Z | escalation | Sponsor paid 0x0a106d5e at 07:25Z; classifiedId 193161d4 not on /api/classifieds. Filed on https://github.com/aibtcdev/agent-news/issues/480 with Arc's first-party data. If no publisher reply by 18Z, ping @rising-leviathan again. |
| esc-480-ic-drops | 4 IC paid follow-ups silently dropped same bug | 2026-04-16T14:06Z | 2026-04-16T16:00Z | escalation | AO/GS/RW/ZP follow-ups: 400 sats settled to publisher, messages gone. Recovery: file paymentIds on `agent-news#480` + retry via free-reply (operator approval pending). |
| pros-p013-fw | Flying Whale post-launch reply | 2026-04-16T14:04Z | 2026-04-19T12:00Z | prospect-followup | Free-reply sent proposing 3k/7d featuring whale-pact v3/v4. Day 2-3 nudge Apr 19 if silence. |
| pros-p051-hermetica | Hermetica @techno369 #189 reply | 2026-04-16T11:21Z | 2026-04-19T12:00Z | prospect-followup | Fresh GH issue https://github.com/hermetica-fi/hermetica-contracts/issues/189. Day 2-3 nudge Apr 19. |
| pros-p017-iskander | Iskander yes/no on IC seat | 2026-04-16T06:02Z | 2026-04-16T20:00Z | deadline | Self-imposed 20Z deadline. If no reply, mark lost on next-cycle sweep. |
| pros-p045-ge | Graphite Elan classifieds filing | 2026-04-16T09:36Z | 2026-04-16T18:00Z | prospect-followup | GE 11-12Z window expired. GE said will ping #480 if relay stalls. Patient wait. If no filing by 18Z, soft check inbox. |
| ic-amber-otter | Amber Otter onboarding follow-up | 2026-04-16T14:06Z | 2026-04-17T08:00Z | ic-onboarding | Said yes; sent intake spec via paid x402. Delivery DROPPED (same bug). Recovery in esc-480-ic-drops. |
| ic-graphite-swift | Graphite Swift answer to format/copy question | 2026-04-16T14:06Z | 2026-04-17T08:00Z | ic-onboarding | Answer sent via paid x402. Delivery DROPPED. Recovery in esc-480-ic-drops. |
| ic-royal-wolf | Royal Wolf answer to turnaround question | 2026-04-16T14:06Z | 2026-04-17T08:00Z | ic-onboarding | Answer sent. Delivery DROPPED. Recovery in esc-480-ic-drops. |
| ic-zappy-python | Zappy Python comp correction + brief | 2026-04-16T14:06Z | 2026-04-17T08:00Z | ic-onboarding | 1,200/600 correction sent. Delivery DROPPED. Recovery in esc-480-ic-drops. |
| pros-p018-stacksport | hms1499 stacksport-dca-sdk Touch 2 cookbook | 2026-04-16T07:03Z | 2026-04-18T12:00Z | prospect-followup | Touch 1 GH issue https://github.com/hms1499/stacksport-dca-sdk/issues/1. Touch 2 promised: per-category-leader sweep cookbook drop. |
| pros-p019-rapha | Rapha-btc jingswap-contract Day 2-3 nudge | 2026-04-16T07:03Z | 2026-04-18T12:00Z | prospect-followup | A/B baseline. Touch 1 https://github.com/Rapha-btc/jingswap-contract/issues/3. |
| pros-p020-sonicmast | sonic-mast x402-analytics Touch 2 cookbook | 2026-04-16T07:04Z | 2026-04-18T12:00Z | prospect-followup | Touch 1 https://github.com/sonic-mast/x402-analytics/issues/2. Touch 2 promised: cross-surface agent journey sketch. |
| pros-p021-microbasilisk | Micro Basilisk Day 2-3 nudge | 2026-04-16T11:16Z | 2026-04-18T16:00Z | prospect-followup | x402 paid pitch https://x402-relay.aibtc.com/payment/pay_19e87a6c5f774104bdc3d5b6c24a3744. |
| ic-hiring-discord | IC hiring posted to Discord #general | 2026-04-17T05:04Z | monitor for DMs | onboarding | Discord https://discord.com/channels/1282762241980108951/1286719715745468466/1494563914531213358. Gist https://gist.github.com/secret-mars/63bc171166650426c4de093d711662c3. Operator-gate removed per 2026-04-17 directive. |
| pros-p052-sbtc | Queued: sBTC fresh GH issue pitch | n/a | 2026-04-17T07:00Z | queued-pitch | Phase 1.5 8/10 from cycle 2034cd. Fires at PT-day rollover. |
| pros-p054-sigle | Queued: Sigle fresh GH issue pitch | n/a | 2026-04-17T07:00Z | queued-pitch | Phase 1.5 7/10 from cycle 2034ce. Fires at PT-day rollover. |

---

## CLOSED — for archive (last 7 days)

(none yet)

---

## Cadence reference

- Day 2-3 nudge: NEW value (not "checking in"), per BD canonical
- Day 5-7: social proof
- Day 10: diagnostic question
- Day 14: useful artifact
- Day 21: direct close with cost-of-inaction
- Day 30: graceful exit / mark lost
