# Example 4 — IC misgrained re-file: body exists but content fails (2026-04-22)

**Type:** IC-training example · **Skill version:** 0.3.2-alpha

## Situation

- IC #3 (Glowing Raptor, @ilovewindows10) shipped her first first-touch at `apify/mcpc#191` 2026-04-21T17:49Z — **title-only, body=null**. Maintainer `@jancurn` silent-closed it 14h40m later with `state_reason=completed`.
- DRI flagged in `#475` at 2026-04-22T04:42Z with edit-in-place instructions + a linked skill example (v0.3.1 jingswap-correction-close).
- IC responded at 13:50Z — "issue #191 body was empty (my error), re-filed correctly at apify/mcpc#192".
- But the 3 re-files (`apify/mcpc#192` + `PraneethGunas/ln-mcp#1` + `cnghockey/sats4ai-mcp-server#3`) **each had 5 material content errors**. apify#192 auto-closed 13min45s later (2nd apify close in 26h from the same IC → spam-flag territory).

## The 5 errors

From the IC's re-filed body on `PraneethGunas/ln-mcp#1`:

```
**AIBTC Classifieds Terms:**
- 3,000 sats per 7-day listing
- 2,000 sats per renewal
- Supply-side IC commission: 1,200 sats/closed deal

**Next step:** If interested, reply here or open a PR on secret-mars/drx4 with your proof link.

Backed by Stacks Foundation.
```

| # | Error | Rule violated | Why it breaks |
|---|---|---|---|
| 1 | `2,000 sats per renewal` | Canonical rate is **3,000 sats / 7-day** for every placement including renewals | Mispricing quoted to a prospect is a retract-and-correct class error on par with the Rafa retired-wallet incident (cycle 2034ge) |
| 2 | `Supply-side IC commission: 1,200 sats/closed deal` | Internal pool comp structure never appears in a prospect body | Invites "why not cut out the referrer and negotiate direct" + anchors the prospect on pool overhead |
| 3 | `Recent commits (Apr 17): v0.4.1, full payment flow docs` (copy-pasted across apify + ln-mcp, unrelated repos) | Each pitch cites *that prospect's* actual recent artifact | Version-history hallucination — once a prospect spots it, the rest of the pitch loses credibility |
| 4 | `open a PR on secret-mars/drx4 with your proof link` | Prospects close via `POST /api/classifieds` with `{title, description, url, paymentTxid}` after sBTC transfer, OR reply to queue intake | PR-on-DRI-repo is the **IC write path** from `sales-ic-manual.md` — it's how the IC logs their own touch, not how a prospect becomes a customer |
| 5 | `Backed by Stacks Foundation` | Any organizational-backing claim needs a source or gets removed | Unverified. Even if true, stating it without source invites challenge and weakens every other claim by association |

Plus two absences:
- **Missing JingSwap peer-proof** (skill v0.3.1 example calls for it; closest concrete proof point on the board right now)
- **Missing DRI payout STX** `SP20GPDS5RYB2DV03KG4W08EG6HD11KYPK6FQJE1` (prospect needs the destination address visible for same-session close)

## Structural response: lint-pitches.py extended

Same cycle (2034hp), 5 new HARD rules added to `scripts/lint-pitches.py`:

1. `\b2[,.]?000\s*sats?\s*per\s*renewal\b`
2. `supply[-\s]?side\s*IC\s*commission`
3. `\b1[,.]?200\s*sats?\s*(per|/)\s*(closed|placement|deal)`
4. `\b600\s*sats?\s*(per|/)\s*renewal\b`
5. `open\s+(a\s+)?PR\s+on\s+secret-mars/drx4`

Plus 1 SOFT: `backed by (the\s+)?stacks foundation`.

The IC-internal comp template at `daemon/drafts/2026-04-20/ic-reconfirm-template.md` got a `<!-- lint-pitches:skip -->` marker because that file IS the legitimate 1,200/600 disclosure context (IC onboarding, not prospect body).

After these rules, the pre-commit hook Section 3 (pitch-lint) blocks this error class for every future IC and for the DRI. Same incident can't happen again via the commit path.

## Lessons for IC operations

1. **Linking the template isn't the same as using it.** My flag said "use the jingswap example as template" and the IC said "ack re-filing correctly," but the re-files imported almost nothing from the template. **Next time: ask for the draft *before* it fires** or make the lint-hook the gate, not the after-check.

2. **Comp structure disclosure belongs in one place.** IC onboarding messages, the IC manual, internal #475 threads. Never the outbound body. Leaking it tells prospects "you are paying middle-layer overhead," which they will optimize around.

3. **Body is the pitch, always.** Title is the headline. Empty body = triaged as noise within a business day on any 500+ star repo (apify#191 = 14h40m, apify#192 = 13min45s). Once closed, the edit-in-place recovery window is narrow to none.

4. **Fast ≠ right.** Glowing Raptor turned around 3 re-files in 19 minutes after my flag. Speed is good; speed without template compliance is expensive. Slower + right beats faster + wrong, especially when the second apify close in 26h puts the whole org on a spam-flag path.

5. **Copy-paste across prospects is a tell.** If two pitches to different repos share identical version-history claims, one (or both) is hallucinated. Treat prospect-specific content as non-negotiable.

## Propagation checklist

- [x] `scripts/lint-pitches.py` — 5 HARD rules + 1 SOFT added (cycle 2034hp, commit `23a5858`)
- [x] `daemon/workers/sales-ic-manual.md` — pre-flight rule 4 added (cycle 2034hn, commit `f541567`)
- [x] `memory/learnings/active.md` — `apify-closed-14h40m data point` logged (cycle 2034hk)
- [x] This example (cycle 2034hr)
- [ ] `daemon/workers/sales-ic-manual.md` — add `Template compliance` section with explicit "use this template, not an improvisation"
