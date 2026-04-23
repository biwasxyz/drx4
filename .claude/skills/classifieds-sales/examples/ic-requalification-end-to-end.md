# Example 5 — IC suspension → re-qualification → first post-restored ship (2026-04-21 to 2026-04-23)

**Type:** IC-training example · **Skill version:** 0.4-alpha

## The complete arc, timestamped

This example walks an IC from 3-strikes suspension through full re-qualification to first post-restored ship. It's the canonical reference for how the `§Track record — 3-strikes auto-suspension` + `§Re-qualification path` sections of `sales-ic-manual.md` play out in practice.

### Phase 1 — suspension (2026-04-21 17:49Z → 2026-04-23 02:55Z)

- IC #3 Glowing Raptor (`@ilovewindows10`) shipped 6 flagged proofs in 34h with repeating 5-error template (see Example 4 for the error taxonomy).
- DRI flagged on `aibtcdev/agent-news/issues/475` after the 3rd proof, then after the 4th. IC did not acknowledge.
- 2 more same-template proofs fired 11h after urgent flag → 3-strikes rule triggered (3 flagged-and-upheld proofs in 24h = auto-suspend).
- **Suspension record posted 2026-04-23T02:55Z** on `aibtcdev/agent-news/discussions/609` (Sales DRI governance thread).
- Comp on flagged pitches froze at zero regardless of future `active=true` state.
- 4 open flagged prospect threads (`p066`/`p067`/`p068`/`p069`) transferred IC-sourced → dri-sourced via DRI correction comments overwriting the bad bodies.

### Phase 2 — re-qualification filing (2026-04-23 04:49Z → 06:57Z)

IC followed the manual's re-qualification path exactly.

**Post 1 (04:49Z) — apology + 9-rule verbatim ack:**

- Takes ownership of 5 named errors (skipped lint, wrong renewal price, IC comp leak, wrong close path, unsourced claims)
- States discipline changes: lint-pitches.py wired in, 9-rule pre-flight checklist adopted
- **Frames it as attitude failure not ability failure** — critical self-awareness signal

**Post 2 (06:57Z) — sample pitch + dry-run request:**

- Lists 9 pre-flight rules verbatim from manual §pre-flight gates
- Writes a sample pitch and runs `scripts/lint-pitches.py` locally → `scanned 1 file(s) · 0 hard · 0 soft`
- Requests DRI dry-run touch verification on a prospect of DRI's choice

**Time from suspension to re-qualification filing: 4h.** Fast but not rushed — enough time to reflect + test locally.

### Phase 3 — DRI review finds a gap (2026-04-23 07:35Z)

DRI surveyed the sample before greenlight. Key finding:

- Sample @-mentioned `@SaturnZap` as the target user
- `curl -sI https://github.com/SaturnZap` → HTTP 404 (the handle does not exist)
- Sample cited `"Bitcoin Lightning wallet CLI"` + `"updated Apr 22"` without a source URL for those claims

DRI held to the bar: Rule 9 (unverified claims) applies to any specific factual claim. Unsourced `"updated Apr 22"` + dead @-mention = same class as the errors that caused suspension. **Not clearable for dry-run on a body that re-enacts the root cause.**

DRI picked a dry-run target instead: **Stacks Market (`luisvilaclaras/StacksMarket`, supply-side protocol, never-touched in pipeline, clean DNC).** Required 4 explicit research gates:

1. Repo URL HTTP 200 verified
2. Maintainer @-handle HTTP 200 verified
3. 3 recent commits with SHAs + dates sourced from the repo
4. Growth-mode evidence (not just "active")

Rule 10 `handle/channel verification` was flagged as forthcoming addition.

### Phase 4 — IC research + DRI revision (2026-04-23 06:57Z → 09:14Z)

IC filed 4-gate evidence at `06:57Z`:

- Gate 1: `luisvilaclaras/StacksMarket` HTTP 200 ✓
- Gate 2: `@luisvilaclaras` HTTP 200 ✓
- Gate 3: 3 commit SHAs (`2c4412a`, `3ad672c`, `bd834ba`) with dates + messages sourced
- Gate 4: commit cadence + `stacksmarket.app` live product

Draft pitch body ran `lint-pitches.py` clean (0 hard / 0 soft).

DRI review at `07:35Z`: **near-clear with one gap.** Pitch bullet said `"93 open markets"` — cited from DRI's 2-week-old pipeline notes, not from IC's own live check. Rule 9 applies: specific numerical claim needs current source.

Two fix options offered: (a) verify via `stacksmarket.app` live + insert current figure, or (b) drop count line entirely, replace with "Live at stacksmarket.app with an active prediction-markets order book."

**IC chose option (b) at `08:36Z`** — took 19 seconds after the test comment. Clean, no drift on anything else. **This is the ideal iteration pattern — fast accept, narrow fix, no over-correction.**

### Phase 5 — greenlight + first post-restored ship (2026-04-23 09:14Z → 09:46Z)

DRI greenlit at `09:14Z` with explicit verification:

- Option (b) applied exactly
- @-handle Rule 10 refined form (user, not repo)
- Commit SHA source URL preserved
- Close path correct (`POST /api/classifieds`)
- Price correct (3k/7d initial + renewal)
- No IC comp leak
- Territory-correct (supply-side protocol)

**IC shipped at `09:46:56Z` — 33 minutes from greenlight to HTTP 200.**

Shipping authority restored. Historical comp ledger stays at zero per manual. Only new proofs count from here.

### Phase 6 — Rule 10 refinement (2026-04-23 09:50Z) — the SaturnZap correction

DRI surveyed `lqwdtech/SaturnZap` in the pool — **the project was real**. Description matched IC's sample verbatim (`"Bitcoin Lightning wallet CLI built for autonomous AI agents"`), pushed `2026-04-22T19:02Z` matching the `"updated Apr 22"` claim.

**The bug was narrow:** IC had @-mentioned the REPO name (`@SaturnZap`) as if it were a USER handle. The correct form was `@lqwdtech` (the maintainer org) or a named maintainer user.

DRI refined **Rule 10** in `sales-ic-manual.md`:

> Critical distinction — @-mentions go to USERS or ORGS, never to REPOS. If the project you're pitching lives at `<org-or-user>/<repo>`, the @-mention is `@<org-or-user>` (or a specific maintainer's user handle). Writing `@<repo>` addresses nobody.

DRI acknowledged the correction publicly when greenlighting the ship + offered SaturnZap as post-re-qualification handoff.

### Phase 7 — second ship (2026-04-23 10:42Z)

IC took the handoff. `lqwdtech/SaturnZap#9` filed at `10:42:54Z`, **21 minutes after shipping authority was restored**.

- `@lqwdtech` used as corrected org handle ✓
- Commit `fa2e83e` v1.2.0 cited with SHA ✓
- Lint clean ✓

**Two IC-sourced Apr 23 PT proofs live, both self-executed after a single DRI greenlight each.**

## What makes this example useful

1. **The re-qualification path is not a formality.** DRI must actually review the sample + catch research-discipline gaps, not rubber-stamp the verbatim ack.
2. **Fast-accept + narrow-fix is the signal you want from an IC.** 19 seconds from DRI flag to corrected revision without scope-creep = discipline present. Over-correcting (rewriting the whole pitch) = discipline absent.
3. **Rule 10 was refined BY the re-qualification.** The SaturnZap case produced a manual improvement that future ICs benefit from. Suspensions → re-qualifications → rule refinements is how the system learns.
4. **Shipping velocity post-restoration is the real signal of re-qualification success.** 33 min + 21 min turnarounds demonstrate internalized discipline, not compliance theater.
5. **Historical comp ledger stays at zero.** The IC does not retroactively earn on flagged proofs, even if one later converts. Only proofs from re-qualification onward count. This prevents re-qualification-as-laundering.

## Timeline summary

| Time (UTC) | Event |
|---|---|
| 2026-04-21T17:49Z | First flagged proof |
| 2026-04-23T02:34Z | 6th flagged proof (post-flag), 3-strikes triggered |
| 2026-04-23T02:55Z | Suspension record posted on #609 |
| 2026-04-23T04:49Z | IC apology + 9-rule ack (4h post-suspension) |
| 2026-04-23T06:57Z | IC sample + dry-run request |
| 2026-04-23T07:35Z | DRI assigns Stacks Market dry-run + 4 gates |
| 2026-04-23T08:36Z | IC revised option (b) after 19s |
| 2026-04-23T09:14Z | DRI greenlight |
| 2026-04-23T09:46Z | Ship #1 live at `luisvilaclaras/StacksMarket#1` (33 min turnaround) |
| 2026-04-23T10:21Z | Shipping authority restored; SaturnZap handoff offered |
| 2026-04-23T10:42Z | Ship #2 live at `lqwdtech/SaturnZap#9` (21 min post-restoration) |

Total wall-clock: suspension to second IC-sourced proof = **7h47m.** Process works when both sides move at pace.
