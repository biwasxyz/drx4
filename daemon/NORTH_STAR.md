# North Star — Read at every cycle boot

## Mode (effective 2026-05-07T06:35Z): cross-repo contributions, no role label

**Operator pivot 2026-05-07T06:35Z (post cycle 2034uc seal):** Sales DRI motion is fully retired — not paused, retired. The agent now ships across the aibtc ecosystem — code reviews, fix PRs, issue files, cross-repo routing, partnership work with @arc0btc. **Don't take on titles.** No "manager," no "developer," no role-y self-descriptions on artifacts. Just an agent doing work where the leverage is. The aim is for aibtcdev to read like a coordinated github organization — visible coordination, hygienic backlogs, substantive PR reviews — not for the agent to brand a role for itself.

**Out:** classifieds Sales DRI seat, daily 3-fire unlock, IC pool ops, x402 cold pitches, BD energy budget, cold-count cap, weekly close target, fire-queue scripts, pitch-lint as a sales gate. All `daemon/sales-*` files become historical artifacts (preserved, not active).

**In:** cross-repo state awareness; PR code review (substantive); issue filing on observed bugs; cross-thread routing; triage hygiene (labels, milestones, stalled-thread nudges); partnership with arc; strategic Bitflow swaps under Phase 4 sizing rules.

## Goal

Make aibtcdev — and its partner repos under arc0btc, Robotbot69, secret-mars — read like a coordinated github organization. Concretely:
- Open PRs across watched repos receive substantive reviews within 2 cycles of `review_requested`
- Open issues get triaged, labeled, linked to related work
- Stalled threads (7d+) get a nudge or close-with-verification
- Cross-repo routing happens (don't ask about X on repo A when X is solved on repo B)
- arc + I have a visible coordination thread; commitments tracked in `daemon/arc-coordination.md`
- Weekly: org-wide repo board (`daemon/repo-org-board.md`) reflects current truth

## Watched repos (canonical)

**aibtcdev/* active:**
- `agent-news` (85 open) — primary platform
- `aibtc-mcp-server` (20)
- `loop-starter-kit` (32)
- `landing-page` (22)
- `aibtc-projects` (15)
- `skills` (11)
- `agent-contracts` (10)
- `x402-sponsor-relay` (6), `x402-api` (6), `erc-8004-stacks` (5)
- `tx-schemas` (1), `agent-runtime` (1), `agent-hub` (1), `docs` (2), `branding` (1), `appleseed` (0), `ordinals-market` (0), `agent-sociology` (0), `erc-8004-indexer` (0)

**Partner repos:**
- `arc0btc/arc-starter` (13), `arc0btc/agents-love-bitcoin` (2), `arc0btc/arc0me-site` (6), `arc0btc/arc0btc-worker` (5), `arc0btc/aibtc-genesis-gate` (0)
- `Robotbot69/aibtc-distribution-log`
- `1btc-news/news-client` — added v103 (2026-05-09T20:40Z); pbtc21 org running quantum bounty #33; cross-source pending-sats consolidation thread spans here + agent-news#818 + loom@; my v103 partnership ack at issuecomment-4413622966
- `secret-mars/drx4` — mine

Mutable list — new repos get added as they enter active development.

## Drift tells

- Same repo gets all my attention 3+ cycles → tunneling, rotate
- `repo-org-board.md` >4 cycles since rewrite → stale snapshot, refresh
- arc commitment unshipped past stated deadline → block on the cycle that follows
- Notifications unread count >50 going into a new cycle → I'm not marking read consistently
- 3+ consecutive cycles with only `comment_shipped` events (no PR reviews / issue files / board refreshes) → drifted into commenter mode, ship something else
- 7d without a partnership-thread artifact with arc → coordination is silent, fix it
- **PR description contains a behavioral claim ("idempotent," "preserved," "handled") with no test asserting it end-to-end** — added v137 after 3-instance threshold (`#705` ON CONFLICT idempotency, `#510` POST /trades idempotency, `#706` cross-page replay survival) in <24h. For incoming reviews: grep test file for the claim's keyword; if no match, surface as non-blocking finding. For my own outgoing PRs: every description-level claim should link the specific test name that asserts it. See `memory/learnings/active.md` v137 entry for full pattern + mitigation proposal.

## Backlog (concrete open deliverables — keep ≥5 items active)

> Refreshed cycle 2034v97 (2026-05-09T16:35Z). Prior v68 backlog had 3 items (#665 RFC merge, Phase 1.2 scout, Phase 1.2 review-prep) that have since shipped — moved to "Recently shipped". Major movement v68→v97: 4 PRs merged (#665 RFC + #668 Phase 1.2 + #670 helper + #672 Phase 1.3); 1 PR APPROVE-pending (#674 d1-pk helper); RFC clarification issue #673 filed and addressed; multi-PR coord drift named as new dev-council failure mode.

### Coordination
1. **Dev-council reviewer pattern with @arc0btc + @whoabuddy on landing-page** — fully validated v92→v95 chain. Pattern: maintainer ships PR + flags open question → arc + me both review pre-merge → SWE-agent fixups apply suggestions verbatim → re-review APPROVE → merge. ~17min fastest read-ahead-to-merge (#664/#670); ~21min fastest review-to-fix-to-APPROVE (#672); ~48min full multi-PR sequence (v92→v95).
2. **arc partnership active surfaces (current):** x402-sponsor-relay#369 (my v12 review still awaiting arc response, 7d threshold ~2026-05-14), landing-page#674 (both APPROVE current on c7498063, awaiting maintainer merge).
3. **Multi-PR coord drift watch (new)** — named v95: when arc + I review in parallel and a non-blocking suggestion gets implemented twice (once via fixup commit, once as new PR), the duplicate must be caught pre-second-merge. Pattern: cross-check the fixup commit shape before opening a new PR for the same surface.

### PR review queue (always live)
4. **landing-page#674** — APPROVED on c7498063; awaiting whoabuddy/arc merge. Path A cleanup (remove dup REPLY_D1_PK_PREFIX from constants.ts + switch route.ts imports to d1-pk helper) needs follow-up PR on main post-#674-merge — offered to file if asked, default arc handles.
5. **landing-page Phase 1.4 reconciliation** — empirical drift recipe ready (v54/v55 + v96 2-sample baseline; same +1 drift magnitude 22h apart at same address). N≥3 sampling recommended to filter cold-cache flap. Phase 2.5 forward-link: `SELECT COUNT(*) FROM inbox_messages WHERE to_btc_address = ? AND is_reply = 0 AND read_at IS NULL`.
6. **landing-page Phase 0.5** — pending; awaiting Bitflow upstream side-issues resolution.
7. **aibtc-mcp-server #487 follow-on** — Gap 1 (#504) APPROVED by arc + ~26h since v51 maintainer-merge ping; patient cooldown until ≥7d since ping or until merge. Gap 2 + Gap 3 scouts (`daemon/scouts/487-gap{2,3}.md`) sequenced after #504 merge.
8. **mcp-server#509/#508** — duplicate fast-uri CVE bumps awaiting whoabuddy to merge one and close the other. Same CI-green-then-maintainer-stall pattern as #504.
9. **x402-sponsor-relay#369** — arc ~58h+ silent on my v12 verifyMessage asymmetry finding; 7d threshold ~2026-05-14.
10. **mcp-server#497 closure path** — Phase 2.5 read-flip is the load-bearing fix; substrate landed in main via #672 merge. Watch for whoabuddy commit pattern in landing-page Phase 2.5 to mirror or improve in mcp-server.

### Watching surfaces (low priority observation-only)
11. **agent-news platform** — paused via #818 EIC trial end. Joint v4 Publisher Liability proposal forming on #818 (3 surfaces converging: signal filings, editor settlements, classifieds). Robotbot69 may consolidate to loom@. Cross-source coordination also lives at 1btc-news/news-client#33 (Iskander's quantum-bounty thread; my v103 ack folded my Sales DRI side into the venue without taking consolidator role).
11a. **1btc-news/news-client#33** — quantum bounty thread; pending-sats consolidation cross-references agent-news#818. ThankNIXlater 5/8 21:24Z named me; v103 ack shipped 2026-05-09T20:40Z (caught 22h late). No further action unless Robotbot69 consolidates AND requests my data, or arc/Iskander/ThankNIXlater @-tag with a substantive ask.
12. **arc-starter#23 maintainer-merge soft-poll** — shipped v54; no movement; rising-leviathan HTTP 202 fix-PR still pending. Patient.
13. **skills#378** (BFF Comp Day 30 dog-intelligence port) — diegomey or LimaDevBTC may push my v87-corroborated fixes (CI requires field, pulse fetchMultiple kraken path). Per v89 scout, the requires-field omission isn't a systemic ports-pattern (#379 has it correctly) — per-PR routing remains the right approach.
14. **agent-news#821 / #818 / #822** — observe; no @-tag pending.

### Strategic trading (small-capital, infrequent)
15. **Bitflow swap thesis** — only when bitflow_get_quote vs alex_get_quote shows ≥0.5% better AND <2% slippage AND a real reason. Per-trade max 1,000 sats sBTC. Daily cap 3. **No active thesis.**

## Recently shipped (cycles 2034v68–v97, 2026-05-09)

- **landing-page#665 D1 RFC MERGED** at 01:44Z 5/9 (mergeCommit `40146774`) after 3 fixup rounds via dev-council pattern (arc + me both APPROVE all rounds; whoabuddy attribution-cited each catch).
- **landing-page#668 Phase 1.2 D1 provision MERGED** at 14:06:42Z 5/9 (mergeCommit `dd001e8`) by whoabuddy. arc + my v74 APPROVEs (both pre-merge); 7 migrations 001–007 landed. Cloudflare credentials gate resolved 35h+ after PR open.
- **landing-page#670 Phase 0.3 helper extraction MERGED** at 14:36:47Z 5/9. v67→v76 read-ahead → implementation loop closed (~17h from v67 review flag to merge). Validates "pre-position substantive read-ahead suggestions land as code via dev-council loop" pattern (codified in `memory/learnings/active.md` v80).
- **landing-page#672 Phase 1.3 KV→D1 backfill route MERGED** at 15:47:48Z 5/9 (initial PR open 14:48Z, my v92 review 15:11Z, Copilot SWE Agent fixups 15:23Z + 15:27Z, my v93 APPROVE 15:32Z, merge 15:47Z = ~36min review-to-merge full cycle). My v92 unique catch (msg.replyTo dropped on inbound) + v92 non-blocking suggestion (REPLY_D1_PK_PREFIX as constant) both landed verbatim.
- **landing-page#673** RFC clarification issue filed by whoabuddy at v92 (15:18Z) capturing my non-blocking constant-lift suggestion as a deliverable spec.
- **landing-page#674 d1-pk helper PR** opened by arc at 15:29Z 5/9 implementing #673 spec. APPROVED on `c7498063` at v95 with Path A timing correction (#672 already merged so cleanup is follow-up PR on main). Awaiting maintainer merge.
- **agent-news#818 partnership @-tag from arc** at v91 (14:43Z 5/9) explicitly cross-linked my v33 cross-revenue-surface naming into joint v4 Publisher Liability framing for loom@. My v91 ack confirmed pattern, offered Sales DRI side data for consolidation.
- **mcp-server#497 v54/v55 → v96 drift hypothesis stable** — same address, +1 magnitude reproduced 22h apart pre/post-#672 merge. 2-sample baseline pre-positioned for Phase 1.4 reconciliation review.
- **arc-coordination.md** updates v66, v73, v76, v95 (full v92→v95 timeline), v97 (NORTH_STAR refresh).
- **repo-org-board.md** v9 → v10 → v11 → v12 inline patches (v47/v52/v56/v58/v60/v65/v66/v79/v88).
- **memory/learnings/active.md** new entries: v80 (read-ahead → implementation loop pattern), v92 (read full thread before reviewing — v57 re-applied), v95 (multi-PR coord drift named as new failure mode in dev-council pair).

## Recently shipped (cycles 2034v40–v68, 2026-05-08)

- **landing-page#664 (mine)** — Phase 0.6 IP-bucket rate-limit on inbox mark-read PATCH; merged 22:45Z (8min open-to-merge record); arc + whoabuddy APPROVE; followed by #666 hardening migration that preserved my fail-closed semantics + strictly improved preview-env security
- **landing-page#665 D1 schema RFC** — APPROVED v66 with empirical #497 closure validation via v54/v55 scout (3-sample +1 drift) + Phase 2.5 dual-write reply-write coverage + Q1/Q2/Q3 votes + link rot suggestion. Re-APPROVE ack v68 on fixup b7a9b8f (all dev-council suggestions applied verbatim).
- **landing-page#666 hardening bundle** — APPROVE v67 with 4-row NODE_ENV→DEPLOY_ENV migration matrix verifying #664 mark-read fail-closed semantics survive; merged 23:29Z (1m39s before my review submitted — codified as new learning v68: check merge state right before submit).
- **landing-page Phase 0 review pipeline** — substantive reviews on #654 / #656 / #658 / #662 / #664 / #666 over 5h window; pile-on-avoidance discipline; review-bot integration learning (v57 refined: review bots are NOT skippable, only status/CI bots are).
- **mcp-server#497 v54/v55 scout** — 3-sample drift table establishing off-by-one hypothesis empirically; cited in #665 RFC as Phase 1.4 acceptance-test recipe.
- **#504 v51 maintainer-merge ping** (mcp-server) — 25h50m post-arc-APPROVE polite request; codified citation discipline learning (never fabricate issuecomment IDs).
- **arc-coordination.md** — v52 (#23 close + #654 review-to-merge), v60 (Phase 0.2 56min), v66 (#664 8min loop + #665 dev-council pattern).
- **repo-org-board.md** — v9 (cycle 2034v47); refreshed inline at v52, v56, v58, v60, v65, v66.
- **5 active learnings codified in `memory/learnings/active.md`**: v48 (CI-green-then-stall), v50/v57 (read full thread + bot reviews are not skippable), v51 (citation discipline), v60 (minor-nit-flag-discipline), v68 (check merge state pre-review).

## Archived backlog (pre-2026-05-08 pivot, mostly `[superseded-by-#818]`)

> Preserved for reference; not active work. The agent-news editorial pipeline is paused via #818 EIC trial end; the items below are archived rather than actively pursued.

- **agent-news#697 / #607 / #813 / #811 / #720 / #634 / #818 / #820 watching** — all `[paused-by-#818]` or `[superseded-by-#818]` per v23 backlog.
- **agent-news Nuval999 cohort** — 2 unreviewed remained at v23; status moot under pause.
- **loop-starter-kit cohort nudge** — shipped 2034uo; no maintainer response.
- **Cross-repo label hygiene proposal** — de-prioritized v23.

## Source citation rule

When citing external URLs, run `curl -sI "$url"` and confirm `HTTP/2 200` BEFORE listing the source. An unchecked URL is not a source; it's a guess.

## Pre-commit hook

Still active. Cruise-mode block + secret scan still apply. Pitch-lint section becomes a no-op since drafts are no longer being added.

## When this file changes

- Backlog item ships → mark in "Recently shipped" footer or remove
- New surface emerges → add to backlog
- Watched-repo set changes → update both this file AND loop.md
- Mode shifts → update header + this file's preamble
- Major platform-state events (e.g., #818 pause) → annotate affected items with `[paused-by-X]` / `[superseded-by-X]` / `[moot-under-X]`
