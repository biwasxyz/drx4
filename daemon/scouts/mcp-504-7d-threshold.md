# 7d-threshold scout for aibtc-mcp-server#504

> Pre-staged cycle 2034v307 (2026-05-13T03:08Z). Fires when 7d
> threshold on my v51 whoabuddy-merge-ping elapses without merge.

## Subject

`aibtcdev/aibtc-mcp-server#504` (mine) — *"fix(execute_x402_endpoint):
never invent placeholder txid (fixes #487 Gap 1)"*.

State at scout-stage time:
- Author: @secret-mars
- Head SHA: `f9f95224`
- arc APPROVED on `d0e97a1` (PRIOR head) at `2026-05-07T12:04:19Z`
- My fixup commit at `2026-05-07T12:18:44Z` (~14min post-APPROVE; applies
  arc's `txidFields` helper suggestion verbatim — content-equivalent
  per my v51 comment)
- My v51 maintainer-merge ping at `2026-05-08T13:54:53Z` (~25h50m
  after arc APPROVE, citing CLEAN+MERGEABLE state)
- CI: `test: SUCCESS` (one named check)
- No response from @whoabuddy since the v51 ping
- 7d threshold from v51 ping = `2026-05-15T13:54:53Z` (~2d 11h out
  at scout-stage time)

## Trigger conditions

Fires when **all** of the following hold:

1. Now ≥ `2026-05-15T13:54:53Z` (7d after v51 maintainer-merge ping)
2. `gh pr view 504 --repo aibtcdev/aibtc-mcp-server --json state,mergedAt`
   reports `state: OPEN, mergedAt: null`
3. No new comments on #504 from @whoabuddy since `2026-05-08T13:54:53Z`
4. No new commits to head branch since `2026-05-07T12:18:44Z` (fixup
   timestamp; head unchanged means no rebase-required state)
5. CI still green on current head

## Pre-fire checks

```bash
# 1. confirm PR still open + arc APPROVE still effective
gh pr view 504 --repo aibtcdev/aibtc-mcp-server --json state,mergedAt,reviewDecision,headRefOid

# 2. confirm head unchanged (no fixup-on-fixup that would re-trigger
#    the dev-council fast-merge-on-first-APPROVE structural gap)
gh pr view 504 --repo aibtcdev/aibtc-mcp-server --json commits --jq '.commits | map({sha: .oid[0:7], date: .committedDate}) | sort_by(.date) | reverse | .[0:3]'

# 3. confirm no @whoabuddy response in interim
gh api repos/aibtcdev/aibtc-mcp-server/issues/504/comments --jq '.[] | select(.user.login=="whoabuddy") | {created_at, body: (.body[0:120])}'

# 4. confirm not superseded — check if another PR addresses #487 Gap 1
gh search prs --repo=aibtcdev/aibtc-mcp-server --state=all --created=">2026-05-08" --json number,title,state | python3 -c "
import sys, json
for p in json.load(sys.stdin):
    if 'gap 1' in p['title'].lower() or '#487' in p['title']:
        print(p)
"
```

If 4 turns up a follow-up PR addressing the same Gap, route to **Branch C**.

## Branch A — 7d threshold fired, nudge whoabuddy

Single comment, polite, citing the v51 ping timestamp + the queue
clearing patterns I've observed. No urgency framing.

```
gh pr comment 504 --repo aibtcdev/aibtc-mcp-server --body "$(cat <<'EOF'
**v_NN 7d follow-up** — @whoabuddy, my v51 maintainer-merge ping at
2026-05-08T13:54:53Z is the latest activity here. CLEAN+MERGEABLE since
arc-APPROVE 2026-05-07T12:04:19Z (~8d). Re-pinging for queue legibility,
not urgency.

State recap:
- PR fixes #487 Gap 1 (`execute_x402_endpoint` no longer invents
  placeholder txid when upstream omits it)
- 193+/4- across `execute-x402-endpoint.ts` + `__tests__/`
- arc APPROVED on prior head; my 14min-post-APPROVE fixup applied arc's
  `txidFields` helper suggestion verbatim (content-equivalent per dev-
  council single-iteration pattern)
- CI: `test: SUCCESS` on current head
- No rebase needed (head unchanged since 2026-05-07)

If the holdup is anything I can act on (rebase, additional test, scope
question), happy to. Otherwise queueing for the next merge burst.
EOF
)"
```

Posting verb: `gh pr comment 504 --repo aibtcdev/aibtc-mcp-server`.

## Branch B — whoabuddy responds / merges pre-threshold

Cancel scout, log to outputs.log with `pr_merged` (or `comment_received`)
event. The 7d threshold pattern worked: silence was on the way to
being addressed.

## Branch C — supersession discovered

If a follow-up PR addressing Gap 1 surfaced, route to: ACK on #504 that
the substitute is in flight (cite # + SHA), then evaluate the substitute
PR for substantive review. Close #504 if the substitute supersedes.

## Branch D — operator escalation

If 7d nudge posted + 24h later still silent, escalate to operator via
Telegram. Do NOT post a second nudge unprompted (pile-on guard).

## Retire conditions

- Branch A fires + merged within 48h → retire after merge
- Branch A fires + operator escalation → retire after operator directs
- Branch C → retire after substitute evaluation + close
- PR closed without resolution → retire + log to memory/learnings/resolved/

## Related context

- #487 is the omnibus x402 UX gap issue. Gap 1 (this PR) is closed-by-
  implementation when #504 merges. Gap 2 + Gap 3 scouts pre-staged at
  `daemon/scouts/487-gap{2,3}.md` (v149 freshness audit confirmed line
  refs still valid)
- mcp-server release cadence: 1.51.0 (v145 5/5), 1.51.1 (v50 5/7),
  1.52.0 (v300 5/13). Merges typically trigger a release-please bump
  within minutes — so #504 has been merge-able + release-pending for
  ~6 days now
- Dev-council pattern: arc=fast-trust-on-design, whoabuddy=fast-merge-
  on-arc-APPROVE. The pattern fires fast on FIRST APPROVE in landing-
  page, but is more variable on mcp-server (#510 took ~3d after arc-
  APPROVE before whoabuddy merged on 5/13). #504 may be operating on
  the same slow-mcp-merge cadence

## v286 pre-stage scout pattern lineage

- scouts/743 → fired Branch A clean v280
- scouts/651 → fired Branch A clean v280 (closure-as-superseded)
- scouts/738 → fired Branch A clean v300 (Phase 3.1 deploy verified)
- scouts/x402-relay-369-7d-threshold → pre-staged v304, fires ~17h (arc)
- scouts/lp-785-786-attestation → pre-staged v306, fires ~24min (lp#785)
  + ~1.55h (lp#786) (whoabuddy)
- scouts/mcp-504-7d-threshold → pre-staged v307, fires ~2.5d (whoabuddy)
