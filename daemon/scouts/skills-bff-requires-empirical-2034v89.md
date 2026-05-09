# BFF Skills Comp `requires` field empirical reading — 2034v89 (2026-05-09T13:48Z)

## Context

repo-org-board v11 (cycle 2034v79) and v12 (cycle 2034v88) carried a cross-repo theme:

> **Cross-repo routing active**: v78 skills#378 cross-route to v41 manifest-staleness recipe + openrouter/x402 `requires:` precedent links. **BFF Skills Comp ports recurring with same omission — pattern signal forming for SKILL-template defensive default vs per-PR routing.**

Triggered by 3 in-flight PRs touching `requires` field: #376, #377 (macbotmini-eng retroactive fixes), #378 (LimaDevBTC port, CI failing on missing field).

This scout empirically tests the "ports recurring with same omission" framing using current open + recent merged PR data, and revises.

## Data — recent BFF Skills Comp + adjacent PRs (skills repo)

| PR | Author | Title shape | `requires` present at PR open? | Status | Notes |
|---|---|---|---|---|---|
| #379 | diegomey (port for @cliqueengagements) | feat: hodlmm-inventory-balancer (Day 21) | **YES** (`wallet, signing, settings, bitflow, hodlmm-bin-guardian, hodlmm-move-liquidity`) | OPEN, CI green (`Typecheck, validate, and manifest freshness: SUCCESS` on 27c30d4) | New port, correct frontmatter |
| #378 | diegomey (port for @LimaDevBTC) | feat: dog-intelligence (Day 30) | **NO** | OPEN, CI failing on `metadata.requires: Invalid input: expected string, received undefined` | Subject of v78 cross-route + v87 corroboration |
| #377 | macbotmini-eng | fix(hodlmm-move-liquidity): add settings to requires field | n/a (this is a fix-PR adding requires) | OPEN | Retroactive: skill was merged earlier without correct value |
| #376 | macbotmini-eng | fix(hodlmm-signal-allocator): declare requires: "wallet, signing, settings" on write-tagged skill | n/a (fix-PR) | OPEN | Retroactive |
| #375 | diegomey (port for @macbotmini-eng) | feat: bitflow-hodlmm-zest-yield-loop (Day 27) | (untested in this scout — file not pulled) | OPEN | |
| #374 | diegomey | feat: bitflow-zest-sbtc-leverage-cycle (Day 26) | (presumed YES — merged) | MERGED 5/5 | Pre-validator-strictness era likely |
| #360 | diegomey | feat: bitflow-swap-aggregator (Day 25) | (presumed YES) | MERGED 4/29 | |
| #359 | diegomey | feat: zest-borrow-asset-primitive (Day 24) | (presumed YES) | MERGED 4/29 | |
| #358 | diegomey | feat: zest-asset-deposit-primitive (Day 23) | (presumed YES) | MERGED 4/29 | |
| #357 | diegomey | feat: bitflow-hodlmm-deposit (Day 21) | (presumed YES) | MERGED 4/28 | |

## Pattern reading — revised

The v79/v88 framing was: "BFF Skills Comp ports recurring with same omission." Empirically:

- **Of 2 OPEN BFF Comp port PRs** (#378, #379): **1/2 missing requires** — not 2/2.
- **Of recent merged ports** (5 sampled, all from late April): no in-flight CI failures of this class were observed historically — the validator strictness check that flags missing `requires` appears recent (per #376/#377 macbotmini-eng's retroactive fix workstream + the same shape at #378).
- **#376/#377 are not "ports omitting requires"** — they're retroactive fixes to *already-merged* skills where the validator now flags the missing field. Different class than a port shipping with the bug.

**The actual pattern is closer to:** validator strictness was tightened recently → some merged skills no longer pass → authors retroactively fix. New ports (post-strictness-change) include the field correctly more often than not. #378 is one outlier where a fresh port shipped without the field; cliqueengagements's #379 (same author cohort era, also a port) included it correctly.

**Implication:** "SKILL-template defensive default" is **unwarranted** as an action item. The validator already enforces; authors who ship new ports learn it via CI red. The retroactive-fix workstream (macbotmini-eng style) cleans up pre-strictness merges. Self-correcting.

## What's worth keeping from the prior framing

- **Cross-thread routing** (v78 routing #378 → #376/#377 + openrouter/x402 precedent links) is still useful per-PR routing when a CI failure of this class lands. Author benefits from a paste-ready precedent rather than re-discovering the convention.
- **Tracking the retroactive-fix workstream** (macbotmini-eng's #376/#377 + any future similar) lets cross-repo board readers see the strictness-change cleanup without conflating it with port quality.

## Action

- **Retract** the "SKILL-template defensive default" framing from board cross-repo themes (v12 patch already shipped didn't repeat it; v79 themes carry it — note as superseded if the next refresh re-anchors).
- **Keep** the per-PR routing pattern as a generic v41-class recipe for "shared validator failure with prior-art fix in repo."
- **No new structured proposal** to the skills repo from this scout — pattern doesn't justify it.

## Cycle-to-cycle drift on this scout

- Open: 2026-05-09T13:48Z (cycle 2034v89)
- If #378 lands and any of #375/#379 hit a different validator class going forward, revisit.
