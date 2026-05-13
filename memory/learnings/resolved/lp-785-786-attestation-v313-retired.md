# Content-equivalent attestation scout for lp#785 + lp#786

> Pre-staged cycle 2034v306 (2026-05-13T02:49Z). Fires at 8h-since-fixup
> crossing if PRs still OPEN with stale arc APPROVE on prior heads.

## Subject

Two open PRs of mine, both arc-APPROVED on a prior head, both with green
CI on the fixup commit, both waiting on whoabuddy to merge:

| PR | Fixup at | Threshold (8h) | Diff vs arc-APPROVED head |
|---|---|---|---|
| **lp#785** (fix Robotbot69#771 KV claim fallback) | 2026-05-12T19:31:53Z | 2026-05-13T03:31:53Z | 1 commit · 1 file · 10+/27- in `lib/cache/agent-profile.ts` |
| **lp#786** (Forge edge-cache PR checklist) | 2026-05-12T20:40:25Z | 2026-05-13T04:40:25Z | 1 commit · 1 file · 5+/4- in `docs/edge-cache-pr-checklist.md` |

## Trigger conditions

Per-PR; either or both may fire.

For lp#785:
1. Now ≥ `2026-05-13T03:31:53Z`
2. `gh pr view 785 --repo aibtcdev/landing-page --json mergedAt,state` reports `state: OPEN, mergedAt: null`
3. No new arc / whoabuddy activity since `2026-05-12T19:31:53Z` (verifies stale state)
4. CI still green (`Lint: SUCCESS, Test: SUCCESS, Build: SKIPPED`)

For lp#786:
1. Now ≥ `2026-05-13T04:40:25Z`
2. Same state/movement/CI checks against `2026-05-12T20:40:25Z`

## Content-equivalent claim — empirical verification

### lp#785

Diff between arc-APPROVED `9df091f6` and current `56c770a3`:

```
fix(771): apply arc [suggestion] != null + trim JSDoc per [nit]
lib/cache/agent-profile.ts | 10+/27-
```

Substantive change:

```diff
   return (
-    agent !== null &&
-    d1Claim === null &&
-    agent.erc8004AgentId !== null &&
-    agent.erc8004AgentId !== undefined
-  );
+  return agent !== null && d1Claim === null && agent.erc8004AgentId != null;
```

Logic IS identical: `!== null && !== undefined` ≡ `!= null` for the
`erc8004AgentId` field (single coerced check). The 27 deletions are
JSDoc paragraph trimming, not logic removal. Function signature
unchanged. Return shape unchanged. Type-guard semantics unchanged.

### lp#786

Diff between arc-APPROVED `aafe76ff` and current `89458b94`:

```
docs(782): apply arc [nit] + Field 1 clarification
docs/edge-cache-pr-checklist.md | 5+/4-
```

Documentation file only. Removed stray `"Closes #782."` directive from
the doc body (arc's [nit]) + restructured Field 1 so `caches.default`
appears once with two clearly-marked branches (arc's clarification).
No code paths touched.

## Branch A — 8h crossing, ship attestation per PR

For lp#785:

```bash
gh pr comment 785 --repo aibtcdev/landing-page --body "$(cat <<'EOF'
Heads up @whoabuddy — fixup `56c770a` is content-equivalent to arc-APPROVED `9df091f`. Diff: applied arc's `!= null` [suggestion] (single coerced null-or-undefined check; `erc8004AgentId == 0` is a valid uint per the on-chain registry, so truthy-check would incorrectly skip it) + JSDoc trim per [nit]. Logic identical: same `shouldFallBackToKVClaim` predicate, same return shape, same type-guard semantics. CI green (Lint + Test SUCCESS, Build SKIPPED). Ready when the queue allows.
EOF
)"
```

For lp#786:

```bash
gh pr comment 786 --repo aibtcdev/landing-page --body "$(cat <<'EOF'
Heads up @whoabuddy — fixup `89458b9` is content-equivalent to arc-APPROVED `aafe76f`. Diff: applied arc's [nit] (removed stray "Closes #782." from doc body) + Field-1 restructure (caches.default appears once with two clearly-marked branches per arc's clarification ask). Docs change only; CI green. Ready when the queue allows.
EOF
)"
```

## Branch B — merged before threshold

If `state: MERGED` at trigger-check, retire the row from this scout +
update outputs.log with `pr_merged` event. No attestation needed.

## Branch C — arc re-engages with re-review

If arc re-approves on current head (`reviews[-1].commit.oid = current
head SHA`), the stale-on-prior-head condition is cleared. Skip the
attestation comment; whoabuddy will merge on the fresh APPROVE per
dev-council pattern.

## Branch D — fixup head changes again

If `headRefOid` changes from `56c770a3` (lp#785) or `89458b94` (lp#786)
before threshold, re-verify content-equivalent claim before posting.
The attestation body cites the specific SHA, so a head change invalidates
the message.

## Retire conditions

- Branch A fires for both PRs → retire after attestation posted
- Both PRs merged before threshold → retire
- Either PR closed without merge → retire + log
- 24h after attestation posted without merge: escalate to operator via
  Telegram for direction (don't pile on with a second nudge)

## Related context

- v300 pattern: "lp#785 head 56c770a3 OPEN — arc APPROVE stale on prior
  9df091f6 (~5h since fixup, anomalous lag)" — flagged but not resolved
  at v300 stop time
- v303 board v24 inline patch documented the lag table
- v304 explicitly named the 8h threshold + content-equivalent attestation
  as the next-step shipping artifact when threshold crosses
- Dev-council convention (v141, v144): arc=fast-trust-on-design /
  whoabuddy=fast-merge-on-arc-APPROVE. The pattern fires on FIRST
  APPROVE, not on re-approves on fixups. The attestation is the
  structural complement to that gap — restates the prior APPROVE
  substantively still applies, so whoabuddy can merge without re-review

## v286 pre-stage scout pattern lineage

- scouts/743 → fired Branch A clean v280
- scouts/651 → fired Branch A clean v280 (closure-as-superseded)
- scouts/738 → fired Branch A clean v300 (Phase 3.1 deploy verified)
- scouts/x402-relay-369-7d-threshold → pre-staged v304, fires ~17h
- scouts/lp-785-786-attestation → pre-staged v306, fires ~43min (lp#785)
  + ~1.85h (lp#786)
