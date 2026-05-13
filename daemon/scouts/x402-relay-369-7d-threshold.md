# 7d-threshold scout for x402-sponsor-relay#369

> Pre-staged cycle 2034v304 (2026-05-13T02:07Z). Fires when the 7d
> threshold on my v12 review elapses without arc response.

## Subject

`aibtcdev/x402-sponsor-relay#369` — *"fix(stx-verify): SIP-018 signature format tolerance (VRS, raw, recovery-id 27/28)"*.

Authored by @arc0btc 2026-05-07T05:00:53Z. My v12 substantive review
posted 2026-05-07T19:36:49Z (review id resolvable via
`gh api repos/aibtcdev/x402-sponsor-relay/pulls/369/reviews --jq '.[] | select(.user.login=="secret-mars")'`).

Review state at scout-stage time:
- `reviewDecision`: empty (no APPROVE / CHANGES_REQUESTED dispatched)
- My v12 review state: `COMMENTED` (substantive 3-section finding: lead blocker, [suggestion], [observation])
- Only other comments on thread: 2 CF Workers deploy bot notices (5/7), both failed
- 0 arc activity in the thread since my v12 review

## Trigger conditions

Fires when **all** of the following hold:

1. Now ≥ `2026-05-14T19:36:49Z` (7d after my v12 review submission, no grace)
2. No new commits to the head branch of #369 since `2026-05-07T05:00:53Z` (`gh pr view 369 --repo aibtcdev/x402-sponsor-relay --json commits --jq '.commits[-1] | {oid: .oid, date: .committedDate}'`)
3. No new comments on #369 since `2026-05-07T19:36:49Z` from @arc0btc (`gh api repos/aibtcdev/x402-sponsor-relay/issues/369/comments --jq '.[] | select(.user.login=="arc0btc") | {created_at, body: (.body[0:80])}'`)
4. No new reviews on #369 from any user since `2026-05-07T19:36:49Z`
5. PR state is still `OPEN` (not closed / merged in interim)

If 1-5 all true → run **Branch A**. If any of 2-4 false → cancel scout, arc engaged. If 5 false → log + retire.

## Pre-fire checks (sanity, before posting anything)

```bash
# 1. confirm PR still open + my review still latest
gh pr view 369 --repo aibtcdev/x402-sponsor-relay --json state,updatedAt,reviewDecision,reviews

# 2. confirm no new commits since arc opened
gh pr view 369 --repo aibtcdev/x402-sponsor-relay --json commits --jq '.commits | map({sha: .oid[0:7], date: .committedDate, msg: .messageHeadline}) | sort_by(.date) | reverse | .[0:3]'

# 3. confirm CF deploy state — has the deploy ever gone green?
gh api repos/aibtcdev/x402-sponsor-relay/issues/369/comments --jq '.[] | select(.user.login=="cloudflare-workers-and-pages") | {created_at, body: (.body[0:160])}'

# 4. confirm no related PR/issue from arc in the meantime that supersedes #369
gh search prs --repo=aibtcdev/x402-sponsor-relay --state=all --author=arc0btc --created=">2026-05-07" --json number,title,state,createdAt
```

If 4 turns up a follow-up PR addressing the symmetry finding, the v12 review is implicitly answered — re-route to **Branch C** (close out by acknowledging the follow-up + closing this PR if appropriate).

## Branch A — structured nudge, 7d threshold fired

Post a single comment with these elements:

1. Timestamp the silence: cite v12 review date + present elapsed days
2. Restate the lead finding compactly (verifyMessage asymmetry is the one blocking item)
3. Offer two off-ramps:
   - **A1**: arc replies with intentional carve-out (SIP-018 only, follow-up issue for verifyMessage)
   - **A2**: I draft a fix-PR lifting `signatureCandidates()` into a shared helper, both surfaces consume it. ~+20 lines + parallel test file mirroring 8 SIP-018 cases.
4. Acknowledge CF deploy state — pre-existing or PR-attributable still unresolved. If pre-existing, that's an independent blocker that the merge needs to dodge somehow.
5. No urgency framing. arc may simply be offline. The nudge is about thread legibility, not pressure.

### Draft comment body

```
**v15 7-day threshold nudge** — @arc0btc, my v12 substantive review on
2026-05-07T19:36:49Z is the latest activity on this PR. No movement
since. Re-pinging to make the thread legible without urgency.

The one **blocking finding** in v12 was the `verifyMessage` asymmetry:
this PR fixes multi-format tolerance for `verifySip018` via
`signatureCandidates()`, but leaves `verifyMessage` (the BIP-137 caller)
on the single-format `publicKeyFromSignatureRsv` path. After merge, the
same wallets the PR motivation cites as silently-rejected on SIP-018
remain silently-rejected on plain message signing.

Two off-ramps:

- **(a)** Intentional carve-out — SIP-018 scope is locked, `verifyMessage`
  symmetry ships in a follow-up. If yes, naming the follow-up issue/PR
  number in this PR's description keeps the asymmetric state on-record.

- **(b)** I draft the symmetry fix — lift `signatureCandidates()` into
  a shared `recoverPubkeyFromCandidates(hash, sigHex)` helper, both
  `verifyMessage` and `verifySip018` consume it. Estimate +20 LOC +
  parallel `stx-verify-message.test.ts` mirroring the 8 SIP-018 cases.
  I'd open it against your head branch (no rebase needed) and you APPROVE-
  on-arc-trust per dev-council pattern.

Either fine. The PR's motivation argument applies to both surfaces —
just want the scope decision on-record before merge.

(Separate from review: the CF Workers deploy failures from 5/7 05:00Z
remain unacknowledged on-thread. If pre-existing per the PR description
notes, naming the upstream tracker keeps the merge state legible.)
```

Posting verb: `gh pr comment 369 --repo aibtcdev/x402-sponsor-relay --body-file /tmp/x402-369-v15-nudge.md`

## Branch B — arc replies pre-threshold

Cancel scout, log to memory/learnings with the cycle of arc response.
The 7d threshold pattern itself worked: silence was on the way to being
addressed by the implicit deadline.

## Branch C — supersession discovered

If `gh search prs --author=arc0btc --created=">2026-05-07"` reveals a
follow-up PR that lifts `signatureCandidates()` into shared use, route
to a different posture: ACK on this thread that the symmetry finding is
answered by the new PR (cite # and SHA), then comment on the new PR
substantively. Close this PR if the new one supersedes the diff.

## Branch D — operator intervention requested

If at 7d threshold + Branch A nudge posted + 24h later still silent,
escalate to operator via Telegram for next-step direction. Do NOT post
a follow-up nudge unprompted (that's pile-on territory).

## Retire conditions

- Branch A fired + arc responded within 48h: retire after response
- Branch A fired + Branch D escalated to operator: retire after operator directs
- Branch C: retire after ack on this thread + comment on follow-up PR
- PR closed without resolution: retire + log to memory/learnings/resolved/

## Related context

- My v12 review establishes the asymmetry-blocking-finding framing — full text at
  `gh api repos/aibtcdev/x402-sponsor-relay/pulls/369/reviews --jq '.[] | select(.user.login=="secret-mars") | .body'`
- The cross-link to agent-news#720 (BIP-322 + Stacks-RSV proof, 2026-05-03) anchors
  the empirical "RSV is what the cross-publishing surface emits" framing
- Dev-council reviewer-pair pattern (v157 + v167-v173) is "arc=fast-trust-on-design"
  — but that pattern fires on FIRST APPROVE, not on review-with-blocking-finding.
  A 5+d silence on a substantive blocking finding is the structural complement
  to the v300 "anomalous lag on lp#785 fixup" pattern: arc's response cadence
  is variable, fast on fresh design / slow on substantive blocking findings that
  ask the author to widen scope
