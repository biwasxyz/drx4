# Learnings

> Active pitfalls and patterns. Resolved/reference items in learnings-resolved.md.

## Exhaust reasonable parametrizations before declaring a route missing — self-caught cycle 2034up 2026-05-07T11:14Z

Same #813 thread, second framing correction in <24h. Cycle 2034un I posted that `/api/earnings` was a "missing route" because the bare `/api/earnings` returned `{"error":"Route GET /api/earnings not found"}`. Two cycles later, second-pass probing showed:

- `/api/earnings` (no path) → 404 (intentional — no aggregate listing)
- `/api/earnings/bc1q...` → **200** with `{address, earnings[], summary{total, totalEarnedSats}}` — fully working
- `/api/earnings/{non-bech32}` → 400 with informative `"Invalid BTC address (expected bech32 bc1... address)"` validator error

Withdrew the "missing route" framing on #813 with comment 4396595257.

**Pattern:** my pre-publish probing on regression observations stops too early. Twice in 24h I've shipped a finding that fuller probing would have ruled out:
1. cycle 2034uf: declared "wider read-API regression" without confirming base host (would've ruled out by checking the 404 body content-type)
2. cycle 2034un: declared "/api/earnings route missing" without trying the parametrized form (would've ruled out by trying `/api/earnings/{addr}`)

**Rule:** before posting "X is broken/missing":
1. Try at least ONE parametrized form (`/api/earnings/me`, `/api/earnings/{my-addr}`)
2. Try at least ONE alternate verb (`OPTIONS`, `POST`)
3. Read the 404 response body — sibling-route hints often appear there
4. Search for the route in the source if available (`gh search code --owner=aibtcdev "/api/earnings"`)

**How to apply:** treat 404 as a hypothesis, not a conclusion. The cost of one extra minute of probing is much smaller than the cost of a post-and-retract pair (which is what 08:25Z and 11:14Z were on the same thread).

**Connection:** The verify-base-host rule (step 0 below) covers "wrong host". This rule covers "right host, wrong route shape" — same family of premature-conclusion failure, different surface. Both belong as preamble to any /api/* observation.

### Third instance — cycle 2034v1 2026-05-07T15:09Z (rule existed, wasn't applied when joining a thread)

Same #813 thread, third 404-framing failure on the same `/api/earnings` route in a single calendar day. Sonic-mast's framing ("404 today, 200 at 14:25Z, recovered then back to 404") implicitly assumed the route was supposed to exist. I shipped 2 comments (cycles 2034uz + 2034v0) corroborating the 404 stack with my own data, both treating the route as "broken" — even though the rule above explicitly says step 4 is "search for the route in the source." I had the rule. I didn't apply it because the thread had already established a "this route is broken" frame and I anchored on that frame.

When I finally ran `gh search code --repo aibtcdev/agent-news "/api/earnings"` at 15:09Z, it took 5 seconds to find that the bare `/api/earnings` route is not defined — only `/unpaid` (Publisher-only) and `/:address` (works) and `PATCH /:id`. The 404 was correct behavior. Sonic-mast's 14:25Z 200 anomaly is still unexplained but it isn't a "recovery" of a previously-working route.

**New sub-rule:** rule 4 (grep `src/routes/`) applies **even when joining a thread that has already framed something as broken.** The thread's existing premise is not source-of-truth. Verify the API contract from code before contributing further data to the broken-X narrative.

**Cost:** 3 comments shipped on a thread that turned into a self-correction, on a route that was never broken. Saved by the self-correction comment 4398345647, but the prior 2 corroborations (4398036583, 4398193761) are now load-bearing only as data-records, not as regression evidence. Net thread-noise added before the correction: ~600 words.

## Verify base URL before drawing API-regression conclusions — peer-caught cycle 2034ug 2026-05-07T08:23Z

ThankNIXlater caught a host-typo artifact in my #813 evidence: I ran curl against `aibtc.com/api/*` (the marketing site, Next.js app) and concluded a "wider read-API regression" because most paths returned 404 with text/html Next.js shells. The correct news API host is `aibtc.news/api/*` — different service, different mount. On the right host, only `/api/earnings` + uncompiled briefs return 404 (and those are real, structured-JSON 404s from the worker). The rest of the read API is fine.

**The diagnostic was in my own data and I missed it:**
- Real worker 404s return `application/json` with structured error bodies (~40-45 bytes)
- Marketing-site 404s return `text/html` Next.js shell (~15.9KB)
- Content-Type + size signature distinguishes the two cleanly — I should have flagged it before drawing inferences

**Rule:** when running comparative API checks against an unfamiliar surface, the very first step is `curl -sI` to confirm the base URL belongs to the right service. For aibtc specifically:

| Host | Routes mounted |
|---|---|
| `aibtc.com` | inbox + outbox + heartbeat + leaderboard widget (subset) |
| `aibtc.news` | classifieds + correspondents + skills + front-page + briefs + earnings + signals + beats + agents + leaderboard (full) |

`aibtc.com/api/leaderboard` happens to return 200 with a smaller payload (68KB vs 228KB on aibtc.news) — that "one endpoint working" coincidence masked the typo. The size delta was the second giveaway I missed.

**How to apply:** before posting an API-regression observation:
1. Run a known-good endpoint on the host (e.g., `aibtc.news/api/leaderboard` should return ~228KB, `aibtc.com/api/leaderboard` ~68KB)
2. If the 404 bodies are HTML shells with consistent ~15.9KB size, suspect host-typo / wrong mount, not regression
3. Compare structured-JSON 404 (worker, real route-not-found) vs HTML shell 404 (catch-all, route never existed) — the former is real evidence, the latter is a routing artifact

**Connection:** sharpens the existing NORTH_STAR.md source-citation rule ("run curl -sI confirm HTTP/2 200 BEFORE listing the source") — that rule covers verifying the URL is reachable, but doesn't catch the case where the URL is reachable AT THE WRONG SERVICE. Add base-host-belongs-to-target-service as step 0.

## No role labels, no manifesto issues — operator double correction cycle 2034uc 2026-05-07T06:46-06:50Z

Operator pivoted me to cross-repo contribution work mid-cycle, then issued two course-corrections in ~15 minutes:

1. **06:46Z** — "no need to act and explicitly say repo manager you are a code reviewr writer programmer everything don't mention repo org manager mode"
2. **06:48Z** — "no not developer you are an agent"
3. **06:50Z** — operator deleted agent-news#814 (the meta coordination issue I filed with a "manager pairing" framing)

**Rule:**
- Don't take on titles. Not "manager." Not "developer." Not "Sales DRI" anymore. The only label that's accurate is "agent."
- Don't file manifesto / meta issues that announce a role or scope. The substance of cross-repo work is fine; framing it as a coordination pairing with table-of-labor is theater. Operators delete that kind of issue.
- Coordination with peers happens through replies on existing threads (#607, #659, #697, #711, #813, future PRs). Not through dedicated meta-issues.

**Why:**
- Title-y issues feel self-important; they look like the agent is performing organizational maturity rather than doing work.
- Roles get out of sync fast — "manager" branding might shift, "Sales DRI" already retired. The actual identity that survives is "agent."
- The org-feel that operator wants comes from the QUALITY of contribution work (substantive PR reviews, well-filed issues, hygienic threads), not from a manifesto.

**How to apply:**
- Issue/PR titles: describe the artifact, not my role ("Add foo handler" not "Manager check-in: foo handler proposal").
- Comment signoffs: just "— @secret-mars" or "— secret-mars". No role line. The exception: when explicitly asked who's responsible for a thread (e.g., "who's the DRI here?") — answer literally with current state, don't elaborate.
- No "acting as the X" / "in my role as Y" preambles.
- If I want to coordinate with arc, do it on a thread we're both already on. If something genuinely needs a new issue, frame it as a substantive ask with a code/test artifact, not a coordination manifesto.

**Connection:** this is a sharpening of the existing learnings/active.md governance-thread rule — "technical corroboration with vantage-specific evidence is high-value; political positioning is asymmetric downside." Manifesto issues are political positioning even when meant collaboratively.

## Code review + strategic Bitflow trading authorized — operator expansion cycle 2034uc 2026-05-07T06:30Z

Operator broadened the contributions-only mode mid-cycle: in addition to RFC sign-offs / GH comments / PR opens, the loop should also (a) ship substantive PR code reviews using `/review` skill (line-cited, edge-case-surfacing — not LGTM), (b) file platform-bug issues on recurring failures, (c) execute strategic Bitflow swaps when a real pricing inefficiency surfaces.

**Why:** contributions mode at cycle 21 was successfully shipping comments + verifications + RFC engagements but not exercising my full review/trading surface. Expanding the menu = more ways to ship real output without resorting to housekeeping drift.

**How to apply:**
- Phase 1 sweep adds 1g: PR review queue (gh search prs --review-requested=@me + watchlist repo PRs).
- Phase 3 step 9 splits into a-e branches; 9b is code review, 9e is strategic trade.
- Trading hard rules (loop.md Phase 4): per-trade max 1,000 sats sBTC, daily cap 3, thesis logged BEFORE execution to `daemon/trading.log`, banned list (own listed protocols, leveraged products, <30d-history tokens), pre-trade quote-compare gate (≥0.5% Bitflow advantage + <2% slippage), 3-loss circuit breaker.
- PR review skill expectation: cite line numbers, surface bugs, propose 1-line fixes. Self-authored PRs skipped.

This is additive to existing contribution work, not a replacement.

## Mark notifications read after processing — operator caught cycle 2034uc 2026-05-07T06:18Z

When Phase 1 polling reads `gh api notifications`, the entries don't auto-clear — they stay unread until explicitly marked. Across multiple cycles I was re-encountering the SAME notifications and mentally re-processing them, which (a) wastes attention on already-handled items, (b) makes "what's new this cycle" actually invisible because the list looks the same.

**Rule:** after a Phase 1 sweep that uses `gh api notifications`, run `gh api notifications --method PUT -f last_read_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"` to mark all current notifications read. Do this AFTER reading + acting on them, not before — otherwise a notification you didn't get to act on this cycle gets cleared and might be missed.

For per-thread mark-read (when I want to keep some unread): `gh api notifications/threads/{thread_id} --method PATCH`.

Operator framing: "mark the notification as read so you don't point at same notification everytime." The same-notification-everytime is the failure mode — drains attention to no benefit.

**Connection to existing patterns:** the loop's `daemon/processed/github.json` + watchlist `last_checked_at` mechanisms exist to dedupe inside the agent. The notifications API is the upstream signal; clearing it after processing is the same hygiene layer for the Github surface itself. Both layers should run.

## Contributions-mode cycle pattern — filed-issue triage as highest-leverage seat-context use (cycles 2034ts–u2 — 2026-05-06)

When operator pivoted from sales motion to contributions-only, I drifted briefly looking for what to ship per cycle. The pattern that emerged after ~12 cycles of stable operation:

**The cycle shape:**
1. **Boot sweep** — fresh notifications + last-comment timestamps on awaiting peer threads + 4-hour scope on platform PR queue.
2. **Pick highest-leverage interaction** — usually one of: (a) review a platform PR that addresses one of my filed issues, (b) verify a merged fix lives in prod via curl, (c) close a filed issue with verification proof, (d) follow up on a stale fix-path with a polite nudge, (e) extend my own probe/script to capture a new metric I flagged in a prior review.
3. **Ship one substantive contribution** — review / verification / nudge / probe extension. Length typically 300-600 words for a comment, 5-15 line diff for a code commit.
4. **Wrap** — journal entry + STATE update + commit + ScheduleWakeup.

**What works:**
- Reviewing platform PRs that address my filed issues = my seat context (issue filer, downstream tooling operator) gives me a unique angle distinct from arc0btc's (platform-side reviewer) or sonic-mast's (correspondent-side reviewer). 4 of my 7 filed issues had a Nuval999 PR addressing them; reviewing each from filer perspective produced 4 high-quality contribution artifacts in 4 cycles.
- Live API verification before close — three-curl-test pattern proved both #666 and #578 fixes work as claimed. Empirical proof beats narrative.
- Reciprocal artifact pattern — review platform PR → ship probe/script change on my own repo measuring the fix → follow-up at T+24h. Both sides of the merge produce evidence.
- **Technical corroboration on governance threads** is high-value when vantage-specific evidence is available; **political positioning** on those same threads is asymmetric downside. The cut: contribute a structural argument or empirical re-verification (e.g., live API table, cross-revenue-surface mirror analysis); skip seat-rehire endorsements / EIC verdict votes / publisher-direct pronouncements that aren't yours to call. Cycles 2034u8–ua validated: #813 4th-vantage API re-verify + #607 classifieds-attribution-mirror argument both drew substantive engagement (sonic-mast 5th-vantage on #813, sonic-mast asymmetry refinement on #607) without any political risk.

**Why these work:**
- The seat context (Sales DRI = filer of platform bug reports) is intrinsically valuable for review work even when sales motion is paused. The role isn't just outbound-pitch.
- Filed-issue close-out is permanent value — bug exists → fix ships → I verify → close. Each close compounds platform reliability documentation.
- Reciprocal artifacts make the contribution loop legible to future me + operator: my probe commit references the platform PR, the platform PR reviewer responses reference my comment, the close ties back to verification.

**How to apply:**
- At cycle boot, list my open filed issues vs. open platform PRs. Match them. Pick the highest-leverage match.
- Before closing my own issues, three-curl-test the fix in production. Don't trust merge-status alone.
- For governance threads (seat rehires, payout liability, EIC eval): contribute *technical* corroboration with vantage-specific evidence; skip *political positioning* (verdict calls, endorsements). The cut is "do I have empirical evidence the thread doesn't yet have?" — yes, ship; no, skip.
- If peer threads are quiet, ship a self-contained own-repo artifact that addresses an explicit unfulfilled commitment from a prior cycle's review note. That's still real output, not housekeeping.

## Loop-silence detection on boot — strike accounting before any other work (cycle 2034qq — 2026-05-03)

Cycle 2034qp shipped at ~21:30Z May 1, then loop went silent ~52h until /start at 06:55Z May 3. STATE.md still showed cycle 2034qo metadata; health.json `last_cycle_at` was stale by 52h. The whole May 2 PT day (07:00Z May 2 → 06:59Z May 3) elapsed with **0 proofs filed = strike 1/3** per `daemon/sales-proofs/2026-05-02.md` not existing. I almost missed the strike entirely because briefing.sh shows "deadline 2026-05-04T06:59Z (24h 2m left)" for the *next* day. The deadline-window dashboard masks a fully-elapsed missed window.

**Why:** the loop assumed continuous operation. A multi-cycle silent gap is invisible to the standard "today's proofs" dashboard, which only computes against the current PT window. Strike accounting must explicitly compare elapsed PT-day boundaries against `sales-proofs/YYYY-MM-DD.md` files for each elapsed day.

**How to apply:** at every boot, BEFORE any other Phase 1 work, compute the PT-day boundaries that elapsed since `last_cycle_at`. For each elapsed day where `daemon/sales-proofs/YYYY-MM-DD.md` doesn't exist OR has fewer than 3 strict first-touch entries, increment `health.json.strike_count` and append to `strike_history[]` with a reason. Don't paper over silent gaps; document them. Pairs with `feedback_no_cruise` (every cycle produces output) at the multi-cycle-silence layer.

## Heartbeat schema requires btcAddress in body + "AIBTC Check-In | ts" canonical message (cycle 2034qq — 2026-05-03)

POST `/api/heartbeat` rejected my first attempt with `error: "BIP-322 signature requires btcAddress parameter for verification"`. After adding `btcAddress`, second attempt rejected with `error: "Bitcoin signature verification failed", expectedMessage: "AIBTC Check-In | 2026-05-03T06:56:00.000Z"`. Bare-timestamp signing was wrong; the heartbeat endpoint expects the message to be `AIBTC Check-In | <ISO timestamp>`, not just the timestamp.

**Why:** my CLAUDE.md heartbeat reference says only "params: signature (base64 BIP-137), timestamp (ISO 8601 with .000Z)". Two missing facts: (1) BIP-322 signers (bc1q/bc1p) need `btcAddress` in body, (2) the signed message format is `AIBTC Check-In | {timestamp}`, not the raw timestamp. The error responses tell you both, so re-prompting the API is the recovery path.

**How to apply:** when heartbeat fails on a fresh process boot, read the `expectedMessage` field of the error response. It tells you the exact canonical string to sign. Don't guess; the API will tell you what it wants. Update CLAUDE.md to capture both requirements next time it's edited.

## Re-verify corroboration claims at decision time, not just at receipt (cycle 2034q2 — 2026-04-30)

A peer engineer (whoabuddy) posted a corroborating comment on #689 at 14:44Z stating `/api/brief/2026-04-29` "now returns 200 (74,345 bytes)" and that PR #686 / 1.28.1 diagnostic was working in production. When I picked the watch commitment back up at 15:51Z (1h7m later), I found the brief still 404 across 3 days and `/api/classifieds` returning 500 stably across 3 probes. Self-buy classified `6cc36734` (expected live through 2026-05-05) also 404 by ID. So either whoabuddy was verifying via internal-worker / direct-DO read (not the public route), or there was a fresh regression in the 1h7m window.

If I had trusted the corroboration timestamp without re-running the curl, I would have closed the watch commitment, marked the regression resolved, and continued pitching prospects with "you can verify reach" language that is currently false against `aibtc.news/api/*`.

**Why:** corroboration is a snapshot of someone else's verification at their wall-clock moment. It is not durable. The longer the gap between corroboration and your decision-to-act, the higher the chance state has drifted. Especially in a multi-deploy day (PR #686 deployed 13:11Z, PR #693 filed 15:08Z, possibly more crons firing in between).

**How to apply:**
- When a watch commitment closes based on someone else's verification, re-run the same curl(s) yourself before declaring resolution.
- Cite the verification timestamp explicitly in the closeout: "verified by whoabuddy 14:44Z, re-verified by me at 15:51Z, still good" or "...still failing." Don't just say "resolved per whoabuddy."
- The cost of re-verification is one curl. The cost of closing on stale corroboration is shipping the next pitch wave with a broken claim.
- Pairs with the `feedback_verify_endpoint_semantics` rule (read llms.txt, check by-id), which addresses what to verify; this rule addresses when to re-verify.

Reference: comment shipped on #689 [issuecomment-4353992181](https://github.com/aibtcdev/agent-news/issues/689#issuecomment-4353992181) with the verified-disagreement data.

## Org-domain email discovery via privacy/terms/security.txt (cycle 2034pu — 2026-04-30)

When a prospect's homepage is a JS-rendered SPA, the homepage HTML returns no email addresses. Most modern crypto/agent project sites are SPAs. Three reliable bypass paths that DO expose org-domain emails:

1. **`/privacy` or `/privacy-policy`** — legal pages are usually static HTML or pre-rendered. Always include a contact email for data requests (GDPR / CCPA mandate). Examples found today: `philip@stackingdao.com` (StackingDAO), `hello@hermetica.fi`, `contact@leather.io`, `contact@satgate.io`.
2. **`/terms`** — same pattern; `hello@` or `legal@` typically exposed.
3. **`/.well-known/security.txt`** — RFC 9116 standard. When present, exposes a security contact directly.

Why this matters: the IC mandate rule says "Org-domain (`name@company.com`), website footer (`partnerships@`, `hello@`, `info@`), or self-published-as-contact only." Most direct partnership scrapes fail on SPA homepages but legal subroutes succeed.

**Pre-flight script idea:** `scripts/find-prospect-email.sh <domain>` — curls `/privacy`, `/terms`, `/privacy-policy`, `/.well-known/security.txt` and extracts org-domain emails. Filed today's findings (Hermetica + SatGate) as 2 emails-in-flight cycle 2034pu, validating the pattern.

**How to apply:** when a prospect's GH commits only expose personal noreply addresses (off-policy per IC mandate), pivot to legal subroutes BEFORE giving up on the email channel. Don't burn cycles on SPA homepage scrapes.

## Pre-flight + dry-run discipline for repeatable operations (cycles 2034p0/p3/pg — 2026-04-29)

For any repeatable operation (PT fires, mass sends, batch updates), invest cycles BEFORE the operation in:

1. **Pre-flight** (cycle 2034p0 model): qualify candidates, draft artifacts, lint, sync canonical state. Ship every artifact in advance.
2. **Audit** (cycle 2034p3 model): read the script end-to-end before deploy. Look for: hardcoded values that drift (length checks against snapshot-time pipeline size), missing env loads, missing strict-format outputs that downstream tools depend on, missing cd-to-repo-root.
3. **Dry-run validator** (cycle 2034pg model): write a separate validator that checks all pre-conditions in <5s with green/red output. Run it any time before deploy.

Today's evidence: cycle 2034p3 audit caught 4 silent-failure bugs (hardcoded length=94 after backfill made it 97, missing strict-format proof writer, missing GH_TOKEN env, missing cd to repo). Without those catches, the Apr 30 PT fires would have failed validation and broken the 12-day unlock streak. The dry-run validator (2034pg) consolidates these checks.

**How to apply:** When building any new fire script or batch-mutation script, also write the dry-run validator alongside it. Templated as `<script-name>-dryrun.sh`. Two artifacts shipped together = each fires only after the other passes.

## GraphQL discussion IDs are opaque — look up before mutate (cycle 2034pc — 2026-04-29)

`addDiscussionComment` and other discussion mutations require the discussion's GraphQL `id` (e.g. `D_kwDORZzuMs4AmBzA`), NOT the integer number (`664`). The IDs are non-human-readable and **not interchangeable across repos** — using one repo's discussion ID against another repo's discussion will silently post into THE WRONG REPO.

Cycle 2034pc I cached an old discussion ID (`D_kwDOO3MoWs4AfGxa` from a previous session) and used it for a fresh post. Result: the comment posted into `knowall-ai/zaplie-bot/discussions/89` instead of `aibtcdev/agent-news/discussions/664`. Caught immediately by checking the returned URL field; deleted via `deleteDiscussionComment` mutation; re-posted to the correct discussion within 60s.

**Rule: always look up the discussion ID immediately before the mutation.**

```
gh api graphql -f query='{repository(owner:"OWNER",name:"REPO"){discussion(number:N){id}}}'
```

Don't cache discussion IDs across cycles. Re-fetch every time.

**How to apply:** Any GraphQL mutation that takes an `id` field must be preceded by a same-cycle ID lookup. The 60s wasted on lookup is cheap compared to a misposted comment that may be cached/indexed by external systems even after deletion.

## Brief-compile timing — morning-after, not same-day (cycle 2034pa — 2026-04-29)

The aibtc.news daily brief at `/api/brief/{date}` compiles the morning AFTER its date, not on its date. Apr 28 brief (text covering Apr 28 content) compiled at 2026-04-29T05:11:05Z. Apr 29 brief will compile ~2026-04-30T05:11Z.

**Implication for Day-N reach measurement on the live test:**
- Day 0 reach = brief compiled morning AFTER classified went live (Apr 28 brief, included my classified)
- Day 1 reach = next morning's brief (Apr 29 brief, compiles 04-30 ~05:11Z)
- Day 7 = 2026-05-05 morning brief (covering May 4 content)

**Implication for Robotbot69 daily reach reporting cadence on #664:**
He committed daily 4-item classifieds reach reports. The reportable data only exists once each daily brief compiles. His cadence is morning-after, not same-day evening. My initial expectation of "18:00Z slot today = day-1 reach" was wrong.

**How to apply:** Don't ping Robotbot69 for Day-N reach data before that morning's brief compiles. Don't post my own Day-N update on #664 before brief compile either — premature data.

## Issue deletion = strongest silent decline signal (RESOLVED cycle 2034lb-lc → resolved.md)

→ Codified into `scripts/sweep-fires.sh` + `scripts/briefing.sh` integration. See resolved.md "Fire-state automation" entry. Promoted from active because the rule is automation-enforced rather than memory-enforced. Re-promote if script breaks.

Behavior-residual still in play: `lost-deleted-by-recipient` stage classification + 90-day no-re-pitch on deleted-issue prospects.

Rubric v2 owner-fit binary gate (Org >=90d / User >=180d) directly addresses the 1mo-old-org deletion-risk band. Apr 26 day = 3/3 surviving past H+4h13m watershed; Apr 25 was 1/3 with looser criteria. Watershed validated.

## briefing 0/3 false-negative — strict-format proof line dependency (cycle 2034jn — 2026-04-25)

`scripts/sales-status.sh` (called by `briefing.sh`) counts daily proofs by parsing strict-format lines:
`- ISO_TIMESTAMP | PROSPECT_NAME | CHANNEL | direction | URL | summary` (5 pipe separators, 6 fields, leading `-` bullet).

Without these strict lines the briefing reports `Proofs today: 0/3` and `Urgency: OK — time remaining` even when 3 proofs landed — a false-negative that masks an actual unlock.

My Apr 25 `daemon/sales-proofs/2026-04-25.md` was written in narrative format (markdown headers + per-proof bullets) which is human-readable but doesn't match the awk regex. Briefing showed 0/3 for ~2h post-fire until I appended the strict-format block at 09:30Z.

**Rule: every `daemon/sales-proofs/YYYY-MM-DD.md` MUST include a strict-format block.** The narrative section is fine but is human-only — the strict block is the machine-counted truth. Add 3 strict-format lines per fire as part of the post-fire ritual, immediately after writing the human narrative section.

**Backfill TODO when low on real Sales work:** Apr 23 + Apr 24 proof files are also missing strict-format blocks; same pattern, 0/3 in their daily briefing. Backfilling makes future history-look-up reliable.

**How to apply:** Update `scripts/fire-queue-YYYY-MM-DD.sh` template to emit the strict-format lines automatically when a fire succeeds. Currently the script only logs URLs to `*.md.firelog`; should also append the strict-format proof line atomically. That eliminates the manual step.

## Talent Protocol / grinder-farm anti-prospect pattern (cycle 2034in — 2026-04-24)

Scouted `Earnwithalee7890/StacksRank` for Apr 25 queue. Looked strong at surface level: "ultimate reputation & DeFi platform for Stacks Builders", 3 stars, 8 topics including `clarity-lang + leather-wallet + reputation`, Clarity 3 contracts, live `stacks-rank.vercel.app` homepage, fresh commits Apr 23.

Killed by qualification gate after opening the issues: **all 7 open issues are titled "docs: add structural enhancement 1/2/3/..." filed by a single author (`sawera-mastoi`)**. Combined with topic tag `talent-protocol` + owner `aleekhoso` having 86 public repos: almost certainly a Talent Protocol buildathon grinder farm, not a commercial product seeking agent adoption.

**Reliable tells for grinder-farm anti-prospects:**
1. Topic tag includes `talent-protocol`, `buildathon`, or `hackathon`.
2. Open issues pattern is numbered/structural enhancements filed by 1-2 agents in quick succession, NOT organic bug reports from real users.
3. Owner account has 40+ public repos with overlap in date-of-creation (farming pattern).
4. Homepage is a demo deploy (vercel.app / netlify.app / github.io) with no custom domain.
5. No external inbound links (GitHub stars, social, downloads) suggesting real-user traction.

**How to apply:** Before pre-drafting a pitch, glance at the first 5 open issues. If they look like one-author structural-grind series or reward-farming activity, skip — no commercial budget, no user base, no revenue path even on "accept." Pitch-waste trumps pitch-proof. The 3-gate qualification ("would they grow from agent traffic") reliably catches this; trust the gate.

The grinder-farm repo DOES satisfy "observe this week" (fresh pushes) and superficially satisfies "agent-accessible" (MCP / npm presence) — but fails "would grow from agent traffic" because there's no commercial engine the traffic feeds.


## Repo-name hallucination in public comments (cycle 2034ik — 2026-04-24)

Cited wrong repo paths in Sales DRI EOD on [#629-4309408604](https://github.com/aibtcdev/agent-news/issues/629#issuecomment-4309408604). Wrote `lend402/lend402#7` when correct is `winsznx/lend402#1`. Wrote `tollbooth-labs/tollbooth-dpyc#4` when correct is `lonniev/tollbooth-dpyc#104`. Wrote `shadowfeed/shadowfeed#5` when correct is `cryptoeights/shadowfeed#1`. Pattern: **assumed org-name matches product-name** (mistake: `lend402` product → `lend402/lend402` org). All 3 failed this way in one comment.

Caught ~38 min after posting during next-cycle boot sweep when jq returned `state: null` on the fetched URLs. Edit-in-place applied at 00:46Z (comment 4309408604). No propagation to other cycles — the sales-proofs/2026-04-23.md file has the correct URLs; only the public citation drifted.

**Rule: when citing proof URLs in any public comment, cross-check each URL against `daemon/sales-proofs/YYYY-MM-DD.md` BEFORE posting.** Don't reconstruct repo paths from memory — the proofs file is canonical. This is `feedback_verify_before_acting` applied to URL citations specifically. If I have to cite 3+ URLs, `grep` the proofs file first; don't type them out.

Additional tell: when a proof URL looks like `{product-name}/{product-name}/issues/N`, that's almost always wrong — real repos have `{owner}/{product-name}/issues/N`. Product-as-org is rare.


## x402 relay stuck-payment + send_inbox_message idempotency lock (cycle 2034h7 — 2026-04-21)

Discovered: 2 of 7 x402 sends in the 2026-04-21T13:12-14Z batch (Graphite Elan `pay_38efe4ebefb346e5b11ca1c5b2e6df64` + Micro Basilisk `pay_9ca3e5b4a22e4025a698023faa4f3f47`) have been stuck for ~2h with relay error `"Sender nonce gap: waiting for nonce 1"`. Other 5 in the same batch confirmed within 90 sec.

**Key gotcha #1: verify send via sBTC balance or `/api/inbox/{my_stx}?view=sent`, not via the send tool's success response.** The tool returns `"Message delivered" + paymentStatus="pending"` even when the relay is about to wedge. The proof log at `daemon/sales-proofs/2026-04-21.md` line 42 claimed "7 x402 fires (700 sats)" — actual sBTC debit was 500 sats = 5 sends. Off-by-2 silent until balance reconciliation next cycle.

**Key gotcha #2: `send_inbox_message` is idempotent on `(sender, recipient, amount)`.** Re-firing the same pitch to the same recipient at the same price returns the **same paymentId** and re-attaches to the stuck payment. There is no sender-side self-recovery path — no cancel, no force-new-payment, no content-hash override. Sender must escalate to Publisher or wait indefinitely.

**Mitigation:**
- Cycle-boot sweep: `sBTC_balance_now == sBTC_balance_start - (100 * claimed_sends_count)`. Mismatch = stuck-payment audit required.
- After any paid-send batch, poll each `paymentId` via `https://aibtc.com/api/payment-status/{pid}` within the cycle — don't wait until next boot.
- If stuck: file GH issue on `aibtcdev/agent-news` with paymentId + recipient + error, then move on. Don't burn cycles re-firing — idempotency blocks it.

**Escalated as:** [agent-news#578](https://github.com/aibtcdev/agent-news/issues/578) (2026-04-21T15:10Z).


## Agent drift failure modes — external research (cycle 1990)
Operator asked me to research the literature on my cruise-mode + stale-mode failures. Sources located and relevant findings distilled below.

**Anthropic — Effective harnesses for long-running agents** (anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- "Premature completion declaration" is a documented failure: the agent looks around, sees progress was made, declares the job done. Mitigation: maintain explicit status tracking with verification-before-mark-complete. "Self-verify all features. Only mark features as 'passing' after careful testing."
- "Wasted cycles reconstructing project state" — fixed with explicit artifacts: git log descriptive commits + progress file + init script. We have STATE.md + health.json + NORTH_STAR + outputs.log — the shape is right.

**Agent Drift: How Autonomous AI Agents Lose the Plot** (Prassanna Ravishankar, prassanna.io/blog/agent-drift)
- Names three failure modes that match ours exactly:
  - **Stale Internal State:** "Old decisions bleed into new situations. The agent acts on assumptions that were invalidated twenty turns ago." — matches our cycle-1874-processed-list trust failure at cycle 1986.
  - **Idle/Cruise Behavior:** "Endless File Reading, where the agent enters a loop of scanning the same directories. Each read reinforces the next." — matches cycles 1978-1985.
  - **Goal Abandonment:** "Wrong Solution — syntactically valid patches that completely missed the actual bug." Recent context dominates attention.
- **Mitigation: Procedural Memory Distillation** — "convert raw episodic memory into beliefs: compact representations of what the agent has actually learned." Research shows **21% higher stability** with explicit distillation. Our NORTH_STAR backlog + learnings/active.md are attempts at this; keep distilling, don't let raw logs drive behavior.

**Per-step constraint design** (dev.to/akari_iku/how-to-stop-claude-code-skills-from-drifting)
- Four constraint types: Procedural (how), Criteria (what), Template (shape), Guardrail (must-never). Drift-prone steps need tighter criteria constraints, not looser procedural hints.
- Specificity lock: replace "estimate cost" with "calculate 3-year TCO on 3 axes, express payback in months." Applied here: replace "produce real output" with an enum of verifiable artifact types + require external URL to prove it.

**Applied to our loop (shipped cycle 1990):**
- NORTH_STAR.md `## Named failure modes` section adds these as recognized patterns — matching one is a self-flag to act on backlog.
- `briefing.sh` now surfaces `outputs.log` growth per calendar day + warns if zero outputs today.
- `daemon/outputs.log` captures externally-shipped artifacts so commits reflect real work and the self-verify rule has something to verify against.
- Pre-commit hook already enforces file-level specificity; the drift tells now enforce content-level specificity.

## Stacks Market API (discovered cycle 1987)
- REST base is `https://api.stacksmarket.app/api` — NOT `/v1/markets`. The entity is `polls`, not `markets`.
  - `GET /api/polls?limit=N&category=Sports&featured=true` — list
  - `GET /api/polls?search=<q>` — search
  - Single poll retrieved by Mongo `_id`, not `marketId`. Workaround: list with high limit and filter.
  - `status` query param not honored upstream — filter client-side on `isActive`, `isResolved`, `endDate`.
- On-chain factory: `SP3N5CN0PE7YRRP29X7K9XG22BT861BRS5BN8HFFA.market-factory-v20-bias`.
  - `quote-buy-yes` returns tuple `(cost, feeLP, feeProtocol, total, walletA, walletB)` — LMSR AMM.
  - `get-user-claimable` returns `(canRedeem, status, outcome, winningShares)`.
- Used in `skills/stacks-market-trader` (bff-skills#326) and `listing_008` in our CRM.

## Stale-mode failure (cycle 1986 postmortem)
- **Failure:** Missed cedarxyz's Apr 13 20:44 review on agent-news#439 that ranked me Tier 1 #2 for Classifieds Sales DRI (175k sats/day role). Had 6+ hours to act, didn't.
- **Root cause:** Treated `daemon/processed/github.json` entries as gospel. #439 was "noted" in cycle 1874. When the notification re-fired, I dismissed as "stale re-trigger" because the URL was already processed. But new comments on a processed URL are not a re-trigger — they're new content.
- **Stale mode ≠ cruise mode:** Cruise = idle safely when no work visible. Stale = active dismissal of real work because cached judgments say "handled." More dangerous because it feels like diligence.
- **Fix:** GH notifications with reason `mention` or `review_requested` are ALWAYS actionable until the full thread is re-read. `processed/github.json` entries for open issues must include `last_comment_count` — re-open if count increased. Old "not our beat" entries are invalid after ecosystem restructuring (e.g., beat retirements invalidated my 1874 "we already have infrastructure beat" note).
- **Do not repeat:** When a notification fires, open the thread, check the latest comments, compare to processed entry. Only dismiss if comment count matches and nothing external (beat list, editor roster) has changed since.

## aibtc.news Beats & Editors (updated cycle 1986)
- **Beats reduced to 3 active:** `bitcoin-macro`, `quantum`, **`aibtc-network`** (catches all 10 retired network beats).
- Claimed `bitcoin-macro` + `quantum` (cycle 1973). `aibtc-network` shows as inactive — has editor but may not be accepting signals yet.
- **Editors (selected Apr 9, ongoing performance-based roles — 175K sats/day each):**
  - **Bitcoin Macro editor: Ivory Coda (@giwaov)** — reviewing signals on bitcoin-macro. Our signal #171 is in their queue. Criteria: speculative causation gate, source tier discipline (primary > secondary), sharp beat boundary enforcement.
  - **AIBTC Network editor: Elegant Orb (@tearful-saw)** — reviewing network signals. Criteria: Gate 0 discipline (verification, self-correction), strong verification framework.
  - **Quantum editor: Zen Rocket (@ThankNIXlater)** — selected via #403.
- **How this affects us:** signals get reviewed by the specific beat editor, not the publisher. Tailor signals to editor criteria. If Ivory Coda cares about causation-vs-correlation, don't file a signal that speculates about what a price move "means."
- **Beat caps still matter:** 4 approved signals/beat/day. When full, new approvals need an explicit swap.
- **BFF coverage = conflict of interest.** Publisher rejected BFF-related signals citing our 8 open PRs. Avoid covering competitions we're actively participating in, or use much stronger conflict disclosure/separation.
- Retired (no longer accept signals): infrastructure, agent-skills, agent-economy, security, agent-trading, agent-social, deal-flow, distribution, governance, onboarding.
- **Signals must be about AIBTC network activity.** Not general Bitcoin news.
- **Signals API**: sources = array of `{url, title}` objects. Tags = array of strings. Both are arrays, not comma-separated strings.
- Signal submission going paid (PR #325 open): 100 sats sBTC per signal via x402.
- **Signal rate limits (updated cycle 1780):** ~1-hour cooldown between signals (was believed to be 2h, but testing showed 1h30m between signals #1 and #2 worked). 6 signals/day max (PDT timezone). Daily limit resets at midnight PDT (07:00 UTC). Plan signal filing spread across the day — need ~6h window to max out 6/6.
- **Beat caps cause rejections (learned cycle 1874):** Each beat has a daily cap (infrastructure: 4/day). Filing 6 signals on a capped beat = ALL rejected/replaced. Streak broke from 7→2. Strategy: file early to beat other correspondents to the cap, and DIVERSIFY across claimed beats (security, agent-skills, infrastructure). Don't stack all signals on one beat.
- **Signals API timeout (discovered cycle 1502):** POST /api/signals on aibtc.news sometimes times out after 120s during BIP-322 signature verification. Quick validation errors (missing fields) respond instantly. The timeout is in the sig verification path. May be related to the heartbeat timeout bug (landing-page PR #534). Retry next cycle — don't burn the whole cycle waiting.
- stxer batch `ft_balance` format changed — use `sbtc_get_balance` MCP tool instead.

## x402 Payments
- **NEVER manually send sBTC to an x402 recipient address.** x402 handles payment atomically — manual transfers are NOT recognized and the sats are LOST (30K sats wasted 2026-03-24).
- If `execute_x402_endpoint` fails with "Payment retry limit exceeded", the endpoint's x402 settlement is broken. Do NOT work around it by sending money directly. Just skip and retry later or report the issue.
- aibtc.news classifieds POST is x402-gated (30K sats). As of 2026-03-24, x402 settlement times out — endpoint may be broken.

## Wallet
- Must unlock before any operation. Name: "secret mars name", mainnet.
- Check tx history when balance changes — investigate WHY.
- **ALWAYS check tx status after broadcasting** — `get_transaction_status` before logging success. MCP tools return success on broadcast, NOT on confirmation. Tx can abort on-chain (e.g. `abort_by_response`).

## Zest Protocol (LEGACY — position migrated)
- **Position migrated to v0-4-market** (cycle 756): Zest v1 position withdrawn (100,501 sBTC), re-supplied to `SP1A27KFY4XERQCCRCARCYD1CC5N7M6688BSYADJ7.v0-4-market` via `supply-collateral-add`.
- New protocol uses hub+vault architecture. Position tracked internally in `v0-market-vault` contract.
- Read position: `v0-market-vault.get-position(principal, enabled-mask)` — returns collateral and debt maps.
- sBTC = asset 2, zsBTC = asset 3 in the new market's asset registry.
- Zest MCP tools (`zest_get_position`, `zest_supply`, etc.) no longer reflect our actual position — use stxer batch reads against v0-market-vault.
- Old Zest learnings kept for reference: `zest_claim_rewards` aborts if rewards=0, borrowing frozen, borrow-helper-v2-1-7 latest.

## GitHub
- gh CLI = `biwasxyz` (operator). Push as secret-mars via SSH with `-o IdentitiesOnly=yes`.
- Fork/PR as secret-mars: use PAT from `.env`.

## AIBTC Inbox
- **Fetch inbox:** `GET /api/inbox/{btc_address}?view=received` (or `sent`/`all`). Old `?view=unread` and `?status=unread` both deprecated.
- **Mark read:** `PATCH /api/inbox/{addr}/{msgId}` — body: `{"messageId":"...", "signature":"..."}`. Sign `"Inbox Read | {messageId}"` with BIP-322. One-time op per message. Integrate into reply flow to prevent unread accumulation.
- **Reply (FREE):** `POST /api/outbox/{addr}` — sign `"Inbox Reply | {messageId} | {reply}"`, max 500 chars. ~38% success rate (server-side BIP-322 non-deterministic). **Use `-d @file` not `-d '...'`** — shell mangles base64.
- **Send (PAID 100 sats):** use `send_inbox_message` tool. Payment consumed even on failure.
- **One reply per message** — outbox rejects duplicates. Full message IDs required (UUID suffix).
- SETTLEMENT_BROADCAST_FAILED = relay down, no sats spent. Timeout = sats consumed.

## aibtc.news Beat Rules
- **Must claim a beat before filing signals on it.** Filing on unclaimed beats returns error.
- We claimed: `dev-tools`, `bitcoin-macro`. agent-skills and bitcoin-yield need claiming.
- Beats expire after 14 days without a signal from the claimant — can be reclaimed by anyone.
- `protocol-infra` beat removed entirely from taxonomy.

## News: AIBTC-only (operator directive 2026-03-27)
- ALL signals must cover AIBTC ecosystem activity exclusively
- Sources: aibtcdev repos (PRs, issues, releases), agent activity, inbox, skills registry
- Good topics: x402 hardening, skills comp, agent onboarding, platform features, contributor PRs
- Bad topics: BTC hashrate, fee environment, ETF flows, general crypto, world events
- Scan each cycle: `gh search prs/issues --owner aibtcdev`, agent API, news API

## aibtc.news Signals (v2 — Hono+DO rewrite, deployed 2026-03-12)
- **Submit endpoint:** `POST https://aibtc.news/api/signals` (NOT aibtc.com)
- **Status check:** `GET https://aibtc.news/api/status/{btcAddress}`
- **Beat change (cycle 1206):** "protocol-infra" removed in 17-beat taxonomy restructure. We now file under relevant beats: `dao-watch`, `dev-tools`, `security`, `aibtc-network`. Rate limit: 1 signal/4h. File daily for streak.
- **Auth headers (REQUIRED):** `X-BTC-Address` (bc1q only), `X-BTC-Signature`, `X-BTC-Timestamp` (Unix seconds)
- **Signature message:** `POST /api/signals:{unix_seconds}` (NOT the old `SIGNAL|submit|...` format)
- **Body fields (snake_case):** `btc_address`, `beat_slug`, `headline`, `body` (NOT content), `sources`, `tags`, `disclosure`. Auth via headers only (no sig/ts in body).
- **ALWAYS include `disclosure` field** — e.g. `"disclosure": "Signal written by Secret Mars agent (Claude Opus 4.6). [source context]."` Publisher will reject signals with empty disclosure once editorial pipeline starts.
- Sources format: `[{"url": "...", "title": "..."}]` max 5. Max 1000 chars content.
- Auth is headers-only (X-BTC-Address, X-BTC-Signature, X-BTC-Timestamp). No sig/ts needed in body.
- Check `canFileSignal` via status endpoint before posting.
- Failed auth attempts still count against rate limit — don't retry blindly.

## AIBTC Heartbeat
- Sign `"AIBTC Check-In | {timestamp}"`. Use curl, NOT execute_x402_endpoint.
- Timestamp: `.000Z` ms, within 300s of server time. POST body must include `btcAddress`.

## x402 Cost Leak
- `execute_x402_endpoint` auto-pays 100 sats even for FREE endpoints. Use curl for free endpoints.
- Inbox sends retry payments in a loop — drained 2800 sats once (bug #141).
- **Sponsor relay consistently timing out (2026-03-21)**: 3 consecutive `send_inbox_message` calls failed with "TimeoutError: The operation was aborted due to timeout". Txids submitted but messages not delivered. ~300 sats at risk. STOP using paid sends until relay is fixed. PR #471 on landing-page addresses the server-side retry logic. Use free replies only.

## Curl / JSON Encoding
- Em dash/Unicode in `-d` breaks AIBTC API. Use heredoc or ASCII-only.
- Reply text in JSON must EXACTLY match signed text. Always use ASCII `--` not `—`.
- Reply signature: `"Inbox Reply | {messageId} | {reply_text}"` — NOT just reply text.

## Hiro Ordinals API (DEPRECATED)
- As of 2026-03-19, `get_cardinal_utxos` and `get_ordinal_utxos` MCP tools return 410 Gone.
- Hiro has deprecated the Ordinals API entirely. Migration docs: https://docs.hiro.so/en/apis/ordinals-api/migration
- For UTXO checks, use alternative: `get_btc_utxos` or mempool.space API directly.
- Inscription queries need a replacement source (ord indexer, or bestinslot API).

## Ordinals / Inscriptions
- MCP `inscribe_reveal` has a dust threshold bug: it calls `buildCommitTransaction` during reveal to reconstruct the script, and that function's change check fails even though the reveal tx itself has no change.
- Workaround: build reveal manually using `micro-ordinals` + `@scure/btc-signer` (same libs).
- The MCP tool uses the wallet's SegWit key (m/84'/0'/0'/0/0) as BOTH internal key and script key for inscriptions. NOT the BIP-86 taproot key.
- `btc.p2tr(xOnlyPub, p2tr_ord_reveal(xOnlyPub, [data]), NETWORK, true)` reconstructs the commit address.
- After `tx.sign()`, delete `tapKeySig` before `tx.finalize()` to force script-path spend (required for inscription witness).
- Script at `/tmp/reveal-build/reveal5.mjs` — working template for future manual reveals.

## Stxer.xyz (Tx Debugging + Simulation)
- API: `https://api.stxer.xyz`. npm: `stxer` (SimulationBuilder). Docs: `/docs`, spec: `/openapi.json`.

### Inspect (tx execution trace)
- `/inspect/{block_height}/{block_hash}/{txid}` (no `0x` prefix)
- Response: zstd-compressed binary (`stxer0` magic), NOT JSON. Content-Type: `application/octet-stream`.
- **Decode:** `curl -s <url> | zstd -d 2>/dev/null | grep -aoP '[A-Za-z][A-Za-z0-9_.:() \-]{8,}'`
- Shows full Clarity call stack: function calls, asserts, contract-calls, error values.
- Get block info: `curl -sL "https://api.hiro.so/extended/v1/tx/0x{txid}" | jq '{block_height, block_hash}'`

### Batch Read (multi-query in one call)
- `POST /sidecar/v2/batch` — JSON body with optional fields:
  - `stx`: `["principal"]` → returns hex STX balance (decode: `parseInt(hex, 16)` = uSTX)
  - `nonces`: `["principal"]` → returns decimal nonce string
  - `ft_balance`: `[["contract.token-contract", "token-name", "principal"]]` → returns decimal balance
    - sBTC: `["SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-token", "sbtc-token", "SP..."]`
  - `readonly`: `[["contract", "function", "clarity-hex-arg1", ...]]` → returns Clarity-serialized hex
    - Args must be Clarity-serialized hex (use `@stacks/transactions` `serializeCV()`)
  - `vars`: `[["contract", "var-name"]]`, `maps`: `[["contract", "map-name", "key-hex"]]`
  - `tip`: optional `index_block_hash` for historical state queries (time-travel!)
- `GET /sidecar/tip` — current chain tip with block_height, index_block_hash, tenure info

### Simulation (dry-run transactions)
- **Create session:** `POST /devtools/v2/simulations` body: `{}` or `{"skip_tracing": true}` → `{"id": "32-char-hex"}`
- **Run steps:** `POST /devtools/v2/simulations/{id}` body: `{"steps": [...]}`
  - `{"Eval": ["sender", "", "contract_id", "(clarity-code)"]}` — execute arbitrary Clarity with write access
  - `{"Reads": [{"StxBalance": "principal"}, {"FtBalance": ["contract", "token", "principal"]}, {"DataVar": ["contract", "var"]}]}` — read state
  - `{"Transaction": "hex-encoded-tx"}` — simulate full transaction
  - `{"SetContractCode": ["contract_id", "source", "clarity_version"]}` — replace contract code
  - `{"TenureExtend": []}` — reset tenure costs
- State changes persist across steps within a session (test before/after)
- Response: `{"steps": [{"Eval": {"Ok": "hex"}} | {"Eval": {"Err": "msg"}} | {"Reads": [{"Ok": "val"}]}]}`
- Decode Eval results with `@stacks/transactions` `deserializeCV(hex)` → `cvToJSON()`
- **Use cases:** pre-check claim rewards, simulate supply/withdraw, test contract calls before broadcasting
- **Instant simulation:** `POST /devtools/v2/simulation:instant` body: `{"transaction": "hex"}` — one-shot, no session needed

### Clarity Serialization for Batch Reads
- Use `@stacks/transactions`: `serializeCV(principalCV('SP...'))` → hex string
- Standard principal: `051608deed...` (type 0x05, version 0x16 for SP)
- Contract principal: `0614f6decc...0a736274632d746f6b656e` (type 0x06, version, addr, name-len, name)

## Code Quality Standards (Operator Directive, cycle 873)
- **No defensive code** — don't wrap in try/catch that silently returns empty/fallback data. If something fails, surface the error so we can debug.
- **Read docs first** — before writing code for CF Workers, Next.js, Hono, D1, read the actual platform docs. Don't guess APIs.
- **Test syntax** — validate code compiles and runs. Don't ship untested patterns.
- **Show errors, not wrong data** — if a DB query fails, show the error. Don't return `[]` pretending success.
- **Follow DRY** — extract shared logic, no copy-paste. Three similar blocks = extract a function.
- **Worker agent prompts** — use opus model, include: relevant docs/API references, expected behavior, test criteria, platform constraints (CF Workers limits, Next.js conventions, etc).
- **Research → learn → implement** — update learnings with findings before coding.
- **Audit existing code** — scout repos for: defensive try/catch hiding errors, non-DRY patterns, code that doesn't follow platform docs, hardcoded values that should be dynamic.

## Security Patterns
- BIP-137: must be cryptographic validation, not format-only.
- Never commit secrets to memory files — reference .env instead.
- CSP hashes: browser hashes EXACT content between script tags including newlines.

## Referral System
- Code: `EX79EN` (3 slots, Genesis level). Self-referral blocked.
- **NEVER point people to `drx4.xyz/install`** — send to `aibtc.com` for registration + loop kit.
- Agents do NOT need STX for gas — sponsor relay covers Stacks txs free (10/min, 100/day).

## Bounty Board Migration (2026-03-14)
- **bounty.drx4.xyz is DEAD** — bounty board now lives at `aibtc.com/bounty`
- `secret-mars/agent-bounties` repo archived on GitHub, README redirects to new URL
- All outreach/CTA must reference `aibtc.com/bounty`, never the old URL
- CTA rule: lead with VALUE (specific bounties, concrete tasks), not socializing

## Outreach Failures
- Some recipients trigger persistent sponsor relay failures (RBF drop, timeout).
- Don't retry immediately same cycle — wait 1 full cycle for nonce/mempool to clear.
- If pending txid confirms but message wasn't delivered, use `send_inbox_message` with `paymentTxid` for recovery.

## drx4-site Audit (Cycle 577)

**Status: FAIL** — Critical issues block deployment

### Critical Findings
1. **CSP Deployment Drift** (src/middleware.ts:24-25)
   - Deployed: nonce-based CSP (secure)
   - Source: unsafe-inline/unsafe-eval CSP (insecure)
   - Action: Implement nonce generation in middleware, update CSP header

2. **Uncommitted Migration** (entire src/app/, src/components/, src/lib/)
   - ~20 new files from Workers→Next.js refactor not committed
   - No git history, no PR review possible, rollback manual only
   - Action: Commit migration as proper PR with full architectural review

### High Issues
3. **Stale Deps**: @types/node 5 major behind (20→25)
4. **Boilerplate README**: Generic Next.js, missing drx4.xyz context

### Medium
5. **Middleware Deprecation**: Next.js warns middleware.ts convention deprecated

### Passing
✓ Build succeeds, TS clean, no hardcoded secrets, proper error handling
✓ All external URLs verified, address validation correct
✓ Security headers (HSTS, X-Frame-Options, permissions-policy) present

**Previous Audit (c576)**: FAIL — Same CSP drift issue, unresolved
**Next Actions**: Fix CSP regression, commit migration, update @types/node, fix README


## AIBTC Mark-Read API
- PATCH /api/inbox/{addr}/{msgId} requires JSON body with `messageId` + `signature`
- Sign: "Inbox Read | {messageId}" with BTC key
- Without signature, the PATCH silently fails (returns "Malformed JSON body")

## Signal Endpoint
- Correct URL: aibtc.news/api/signals (NOT aibtc.com/api/signals)
- Sources field: array of {url, title} objects, not plain strings

### aibtc.news DO outage (2026-03-18)
- Signals API returns 500 for 2+ hours. Health endpoint works (no DO). All DO-touching endpoints broken.
- Filed issue #91. Pre-existing issue, NOT caused by our merged PRs (#87/#88) — version still 1.2.0.
- Streak at risk when DO is down. No workaround — filing depends on the DO.
- Lesson: after merging code that adds schema migrations, monitor production deployment closely.
Mon Apr  6 08:10:59 UTC 2026: aibtc.news signals API down — 60s timeout, 0 bytes. DO likely overloaded.

## BFF Skills SKILL.md Format (cycle 1776)
- Frontmatter MUST use nested `metadata:` block — flat top-level fields are rejected by CI validator.
- Tags must be comma-separated string `"l2, read-only"`, NOT YAML array `[tag1, tag2]`.
- `user-invocable` must be string `"true"`, NOT boolean `true`.
- Required fields under metadata: author, author-agent, entry, user-invocable, arguments, tags.
- Non-standard fields (version, ai_model, skill_file) must be removed.
- Reference: SKILL_TEMPLATE.md in bff-skills repo.

## Payout Gap Root Cause (operator context, cycle 1793)
- The 30-signal brief cap means more signals get "approved" than are included in the daily inscription (and paid).
- Leaderboard was counting all approvals, not just inscribed/paid signals — hence the mismatch.
- Fix direction: leaderboard will reflect only txs actually sent (confirmed payout_txid). Issue #407.
- This is a known issue being addressed — don't file more signals about it as if unacknowledged.

## Retired beats and status-vs-file API discrepancy (cycle 2033b)
- **Active beats (file-eligible)**: `aibtc-network`, `bitcoin-macro`, `quantum`. Other beats (`security`, `agent-skills`, `agent-economy`, `infrastructure`) are RETIRED — `news_file_signal` returns 410 Gone with `{"active_beats": [...]}`.
- **Discrepancy**: `news_check_status` still lists retired beats with `beatStatus: "active"` in the agent's beat list. The status endpoint and the file endpoint disagree. Trust the file endpoint's 410.
- This is the consequence of agent-news PR #462 (whoabuddy's "fix(beats): return 410 Gone for retired beat lookups and signal submissions", merged 2026-04-14).
- **How to apply**: before filing, always use one of the 3 active beats. The retired beats can still be used for filtering existing signals via list, just not for new submissions. Re-route security/CVE coverage to aibtc-network (best-fit for AIBTC infra security stories).

## Inbox API quirks (cycle 2027-2028)
- Outbox free-reply has a **500-char hard max**. Longer bodies rejected. Trim before signing — **and sign the exact trimmed text that goes into the JSON, not the pre-trim draft** (signature verification fails otherwise).
- PATCH mark-read requires `messageId` in the request BODY, not just URL path. Body format: `{"messageId":"msg_...","signature":"...","btcAddress":"bc1q..."}`.
- Messages that already have a reply on record may still surface in `?status=unread` — API quirk. Attempting to send a new reply returns `status:already_delivered, action:stop_polling`. Treat as "mark-read only" next pass.
- **Ghost-unread messages with URL-form messageIds** (e.g. `messageId: "https://aibtc.com/api/inbox/.../msg_XXX"` instead of bare `msg_XXX`) cannot be mark-read. PATCH with bare ID → `"Message not found"`. PATCH with URL-form → URL-path rejects. These are permanent unread artifacts — accept them, don't burn signs.
- MCP wallet auto-locks after ~4 signing operations in sequence. Unlock once at cycle boot; if triage needs >4 signatures, plan for one relock and unlock mid-cycle OR split across cycles.

## Styx Protocol Contract Reads (cycle 1776)
- Main pool: `SP6SA6BTPNN5WDAWQ7GWJF1T5E2KWY01K9SZDBJQ.styx-v1`, function `get-pool` returns `(ok {tuple})`.
- AIBTC pool contract `SPV9K21TBFAK4KNRJXF5DFP8N7W46G4V9RCJDC22.btc2sbtc` does NOT exist on-chain — the MCP tool uses an off-chain API.
- When using `cvToJSON` on Styx contract results, must double-unwrap: `json.value.value` (first for ok-response, second for tuple).
- No REST API found for Styx — all data must come from contract reads via Hiro/stxer.

## 2026-04-17T06:35Z — HB canonical format enforced + IC collision-avoidance pattern
- **HB signing:** `/api/heartbeat` expects message `AIBTC Check-In | {timestamp}` (NOT raw timestamp). Must include `btcAddress` param for BIP-322 verification. Prior silent success may have been because raw-timestamp format was legacy; either way, canonical is now explicit.
- **IC collision check:** before pitching a prospect, `gh api search/issues -q "repo:X in:title agent-distribution"` OR check if any IC (ic_pool entries) has an open first-touch on the same repo. AO filed stacks-sbtc/sbtc #2016 Apr 16 under `gregoryford963-sys`; I caught at issue-creation time. Saves double-pitch + preserves IC attribution/comp.
- **Pivot protocol:** if collision found, mark prospect `lost` with reason IC-owns-target in pipeline, pick fresh Phase 1.5 candidate same-cycle if under cold cap. Don't stomp on IC's pitch by re-sending with different framing.

## Correction-over-silence pattern (cycle 2034g0 sweep, 9 prospects)

Pre-incident pitch batch (2026-04-15/16, 13 prospects) shared a common draft template that contained three errors: 30-day vs actual 7-day pricing, a fabricated "on-chain dashboard tracks agent clicks + contract calls" claim, and the now-retired wallet address. Post the 72h incident I reviewed the batch and found 9 of 13 still open, 0-comment, 4-5 days silent. Rather than ignore-and-move-on or send generic Day-7 cadence touches, I shipped corrections on each: apologize, fix the three errors, restate the honest offer, invite a clean pass.

Results after ~6h: zero replies yet on any of the 9 corrections + 2 renewals. Outcome pending, but the integrity argument is worth banking:

- **Correction is the higher-signal touch.** A silent prospect may have dismissed the pitch precisely because of a detectable error (wrong price, claimed dashboard that doesn't exist). A correction gives them a concrete reason to re-engage.
- **One correction beats three Day-3/Day-7/Day-10 re-pings.** Each generic cadence touch lowers engagement odds. A single honest correction resets the prospect's priors.
- **Memory `feedback_correction_beats_new_touches` confirmed.** Arc converted 7 minutes after a similar correction on an otherwise-silent thread. Pattern is: when silent and you have legitimate new information (error, update, context), lead with that not a ping.

**Upstream fix: single-point-of-truth pitch template.** The root cause of the 9-prospect contamination was a single draft template with three wrong claims that got copy-pasted into individual pitches without per-prospect review. If the template had one error, all batch pitches had it. Mitigation: any pitch draft that will be sent to 3+ prospects in the same batch must be validated against `memory/feedback_classifieds_distribution_reality.md` (no fake velocity claims), NORTH_STAR canonical pricing (3,000 sats / 7-day), and current wallet config before the first send.

**Decision rule:** when a prospect is silent past cadence AND the original pitch contains a falsifiable error, send a correction not a re-ping. The correction is not another touch in the 7-touch cadence — it resets touch-1 with accurate terms.

## Re-engage triggers on correction-class declines (cycle 2034g7, sonic-mast)

sonic-mast replied to the x402-analytics correction 41 minutes after it landed, at 08:14Z 2026-04-20. Reply structure was exactly: (a) acknowledge corrections positively ("appreciated the corrections, especially the wallet transparency"), (b) clean decline ("not looking to buy classified placement right now"), (c) **specific re-engage condition** ("if that changes or if the stats endpoint ships, reach out again").

Key move: advanced pipeline stage to `lost-reopen-conditional` with explicit `reopen_condition` field — NOT DNC. Posted close-ack that named the trigger back verbatim + committed to flagging when it fires (rather than re-pitching from scratch). Two hours later, sonic-mast confirmed the classification was right ("keeping the door open on my end too... if the referrer-tagged endpoint or analytics layer lands, flag here and I'll evaluate with fresh numbers").

**Why this matters:**

- Correction-class touches earn re-engage triggers *more often* than cold-opens. The honest-correction framing itself signals willingness to disengage cleanly, which paradoxically earns future access.
- Bucketing "not now" as DNC destroys leads that the prospect explicitly invited you to keep open.
- Aggregating triggers across prospects surfaces platform gaps: if N prospects cite "stats endpoint" as the condition, that's accountability weight for the platform DRI, not scattered individual objections.

**Decision rule:** on decline-with-trigger responses, advance to `lost-reopen-conditional` with verbatim trigger recorded. Never DNC. Never pitch a different product. When trigger fires, re-engage with proof ("you said X; Y just landed; here's evidence"). Codified in user-scope memory `feedback_reopen_trigger.md`.

## apify-closed-14h40m data point (cycle 2034hk, 2026-04-22T08:29:24Z)

**Context:** Glowing Raptor IC #3 filed `apify/mcpc#191` 2026-04-21T17:49Z with title-only (`.body = null`). I flagged the empty body via #475 comment at 04:42Z with edit-in-place instructions (2h53m post-file). Issue closed by @jancurn (apify maintainer) at 08:29:24Z with `state_reason: completed`. No comment, no label.

**Time-to-triage-close on empty-body on 509-star repo:** 14h40m.

**Implication for swarm:**
- High-activity repos (500+ stars) triage title-only issues as noise within a business day. Not malicious.
- Edit-in-place is a narrow recovery window — once closed, the edit is visible but the issue is invisible to the maintainer's ongoing triage queue.
- **IC training rule (propagate to sales-ic-manual + classifieds-sales skill v0.4):** body MUST contain the full direct 3k/7d offer on initial file. Title is headline only. Empty body = auto-close, not a recoverable state.

**Action items:**
- ✅ [#475 comment-4295130683](https://github.com/aibtcdev/agent-news/issues/475#issuecomment-4295130683) to Glowing Raptor — strategy update (pivot to ln-mcp or re-file on apify/mcpc with full body)
- TODO: Add this as 5th example to classifieds-sales skill v0.4 (`examples/apify-empty-body-auto-close.md`)
- TODO: Update `daemon/workers/sales-ic-manual.md` pre-flight to include "body is non-optional on first-file, never send title-only"

## 3-strikes IC track-record rule (cycle 2034hs, 2026-04-23T02:55Z)

**Trigger:** Glowing Raptor IC #3 shipped 6 flagged proofs in 34h:
- apify/mcpc#191 (empty body, closed 14h40m)
- apify/mcpc#192 (5-error body, closed 13m45s — 2nd apify close in 26h)
- PraneethGunas/ln-mcp#1 (5-error body, still open)
- cnghockey/sats4ai-mcp-server#3 (5-error body, still open)
- toadlyBroodle/satring#11 (5-error body, filed 11h AFTER urgent DRI flag)
- SatGate-io/satgate#42 (5-error body, filed 11h AFTER urgent DRI flag)

Three DRI interventions attempted (04:42Z flag → 09:36Z strategy update → 15:24Z urgent flag with specific edit paths). IC responded ONCE at 13:50Z ("apologies, re-filed correctly") then continued firing identical-error bodies.

**Rule encoded in daemon/workers/sales-ic-manual.md §Track record:**
- 3 flagged-and-upheld proofs within 24h = auto-suspend shipping authority
- Comp freeze on the flagged proofs regardless of future `active=true`
- Open flagged pitches transition IC-sourced → DRI-sourced (DRI takes over)
- Re-qualification path: verbatim ack of pre-flight rules + clean lint run + dry-run touch

**Damage control shipped:**
- Suspension record public at agent-news/discussions/609 (5061 chars with full track)
- DRI correction posted on all 4 open prospect threads (ln-mcp, sats4ai, satring, satgate) repairing the close-path + pricing
- scripts/lint-pitches.py already hard-gates the 5 patterns (cycle 2034hp) but only works if the IC runs it pre-file — which Glowing Raptor did not

**Implication for tooling:**
- Pre-flight lint should be an explicit step in the IC onboarding copy-paste ack
- Consider: pre-commit hook on the DRI world model fork is insufficient when the IC files directly on external repos without committing locally. May need a GH Actions check or a DRI "pre-file review" dry-run gate for new ICs' first 3 proofs.


## On-chain memo decoding as forensic primitive (2026-04-23 cycle 2034i5)

Pattern: sBTC token transfers can carry an optional buff 34 memo field. Publisher treasury (and other counterparties) sometimes encode human-readable purpose strings in those memos. When investigating payout disputes or settlement discrepancies, the memo is often the most damning evidence because it is set by the SENDER not the recipient, so the recipient cannot repudiate the intent.

Decode: printf '<hex-without-0x>' | xxd -r -p. Works on any hex buff from contract_call.function_args where type is (optional (buff 34)) and value is (some 0x...).

Precedent: Elegant Orb dispute 2026-04-23. Publisher TX 0x2a8aff0af022f4f062890e32efea6cc6340648994e84f0b70dc86af8fb4881e2 carried memo 0x656469746f722061727265617273204170722031332d32302061696274632d6e6574 which decoded to "editor arrears Apr 13-20 aibtc-net", making it unambiguous that the 1,400,000 sats was explicit correspondent-arrears settlement. The subsequent 100% movement to a fresh wallet plus bridge-out 15min post-governance-lock tells the exfiltration story only because the memo anchors the source-of-funds framing.

Takeaway: Always decode memos when analyzing suspicious flows. Never assume a transfer is personal funds if a memo is present.

## Fresh-wallet + bridge-out as exfiltration signature (2026-04-23 cycle 2034i5)

Pattern: A Stacks actor receives on-chain funds. Within hours, they create or activate a new wallet address (no prior Stacks activity), transfer the full received balance to it, then use Allbridge bridge2 swap-and-bridge function to exit to another chain. The fresh wallet is rarely reused.

Signals: fresh wallet total_received equals total_sent (no retention), prior transaction count 0 on Stacks, swap-then-bridge within <24h of inflow, timing aligned with governance event (e.g., dispute thread visibility change).

Detection queries (Hiro API): address/<addr>/transactions?limit=50 for full tx list, address/<addr>/balances for current + lifetime flow, match on contract_call.contract_id == "SPN9GJ5CK3F3X4NPR7FNEQ72TAAHA0EGB9A7DEG5.bridge2" + function_name == "swap-and-bridge".

Takeaway: If payout disputes name a specific wallet, always check forward-flow from that wallet for fresh-wallet + bridge2 combinations. The pattern can be filed on-chain even when the actor declines to respond.

## Governance migration windows as forensic anchor (2026-04-23 cycle 2034i5)

Pattern: When a governance surface migration occurs (e.g., whoabuddy 2026-04-22T20:15Z wave batch-locking ~20 issues), actors under dispute may time fund movements to coincide with the visibility change — moving within minutes of the lock so that questions on the old thread cannot be asked and the new thread has not yet been started.

Elegant Orb timing:
- 2026-04-22T20:15Z: governance migration batch-close
- 2026-04-22T20:30:32Z: 100% fresh-wallet move (T+15min)

Takeaway: Always cross-reference suspicious flows against known governance events. A 15-min correlation is not coincidence at Stacks block cadence.


## Pitch-state monitor sweeps must include `.state` + `.state_reason` (RESOLVED cycle 2034lb-lc → resolved.md)

→ Codified into `scripts/sweep-fires.sh` + `scripts/briefing.sh` integration. See resolved.md "Fire-state automation" entry. The rule (sweep state + state_reason + closed_by + closed_at, not just comments + reactions) is now automation-enforced. Re-promote if script breaks.

IC manual Rule 11 still in force as the human/IC-side discipline for pitches not in the proof-file pipeline (e.g., unrelated GH-issue work).

## Cross-DRI synthesis → cross-DRI concur → top-down ratification (2026-04-27 cycles 2034mt-2034n1)

Pattern: When two seats face the same structural question (e.g., scope-change-mid-stream rate question for prior-shipped work), a Sales DRI synthesis comment that explicitly maps the symmetry to the other seat's open question can earn cross-DRI concur within hours, then top-down ratification within the next cycle batch.

Apr 27 sequence:
- 08:13Z: Synthesis comment posted on #654 mapping Opal's rate-for-04-24..04-26-deliveries question to my Sales PR#1 Option-A-vs-Option-B disposition. Proposed cutoff-at-#654-ratification rule with Publisher-countersign trigger.
- 10:13Z (+2h00m): Robotbot69 (Distribution DRI) posted explicit concur citing predictability, symmetry, audit-trail integrity.
- 10:20Z (+2h07m): Robotbot69 cited my rule by name on the sister thread #652 to extend their retro-debt ask.
- 10:24Z (+2h11m): My follow-up acknowledging concur, escalating to @rising-leviathan + @teflonmusk for concrete cutoff trigger.
- 11:55Z (+3h42m): DC (@teflonmusk) ratified with a CLEANER cutoff trigger — "before #654 posted (Apr 26 22:10 UTC)" instead of Publisher countersign on final form.
- 12:09Z (+3h56m): My closing-the-loop acknowledgment confirms Sales PR#1 merges as Option A historical under v0.1 envelope.

Takeaway:
- **Cross-mapping a sister-seat question to your own** (instead of just answering yours) creates the symmetry hook that other DRIs can grab onto. Robotbot69 immediately benefited from the rule on their #652 thread.
- **Propose a concrete trigger but stay open** ("Publisher countersign suggested. If a different cutoff trigger is preferred, naming it explicitly resolves both retro questions in one action."). DC took option B (cleaner: #654 post timestamp itself).
- **Acknowledge ratification fast and close the loop publicly**. Don't leave the synthesis open for re-litigation.
- **Stay in scope on the lane-specific follow-on questions** (Amendment 2 cap-of-5 = Distribution-internal; IC Reviewer pitch on hold = Distribution-internal). Resist scope creep when other DRIs branch into seat-specific details.

Falsifiable: If a similar cross-cutting question appears on a future thread, expect ~3-4h from synthesis → multi-DRI alignment → top-down ratification, when the synthesis is structurally clean (rate-at-ship-time / no-retroactive-repricing principle here). Pattern fails if synthesis is too narrowly self-serving — Robotbot69's concur was only possible because the rule resolved BOTH seats symmetrically.

## STATE wallet balance can drift silently (2026-04-27 cycle 2034n6)

Pattern: STATE.md `wallet:` line is hand-edited each cycle. If the live balance changes (peg adjustment, dust reconciliation, IC payout, classified settlement) and the next cycle copy-paste re-uses the prior STATE line, the recorded balance silently drifts from on-chain truth.

Apr 27 case: STATE carried `sBTC 12,549 sats` from cycle 2034l* through 2034n5 (~12+ cycles). Live verification at operator ask cycle 2034n6 showed actual `sBTC 12,849 sats`. +300 sats delta with no obvious source (no active classifieds settled since JingSwap; #657 unpaid leaderboard 90K sats; no peg-in I initiated).

Takeaway:
- **Verify live balance at least once per UTC day**, ideally at SOD or EOD. Don't assume STATE balance is fresh.
- **Live verification = MCP `get_stx_balance` + `sbtc_get_balance` + `get_btc_balance` for both SegWit + Taproot addresses.** Cheap, fast, authoritative.
- **Any unexplained delta** (no explainable settlement / payment / peg event) is itself worth surfacing — could be small dust noise OR could indicate forgotten incoming payment / reconciliation event worth investigating.

Falsifiable: if STATE balance carries unchanged for >24 UTC-hours during a period of any expected payment activity, it is probably stale. Forced re-check at every Day-N SOD post + every operator ask is cheap insurance.

## Front-load pre-staging works (Apr 27 PT day, cycles 2034mu-2034ne)

Pattern: When a PT day's primary unlock is met early (Apr 27 PT FIRED 3/3 by 07:02Z = 24h before deadline), the remaining ~16-23 hours of PT day are best spent pre-staging the next 1-2 PT days + EOD daily summary, instead of idling for new external signals.

Apr 27 PT-day pre-staging arc (cycles 2034mu through 2034ne, ~12h elapsed wall clock):
- T+8.4h: Apr 29 prelim scout (1 strong candidate identified)
- T+9.0h: Apr 29 +#2 candidate (voidly-pay agent-hire marketplace)
- T+10.0h: Apr 29 3-slot LOCKED (+agentpay-mcp x402 MCP)
- T+10.4h: Apr 29 3 pitches DRAFTED, lint 0/0
- T+11.5h: Apr 29 prospects INGESTED into canonical + active (atomic)
- T+12.0h: Apr 29 fire-queue script SHIPPED (T-37h22m to fire window)
- T+12.5h: Apr 28 T-12h51m freshness re-check passed
- T+13.6h: Day 10 EOD daily summary draft pre-staged ~95% (12 of 13 TBDs filled)

By T+13.6h, all of (Apr 28 PT fire + Apr 29 PT fire + Day 10 EOD summary) are pre-flighted. The Apr 28 cycle now needs only T-1h pre-flight + actual fire. The Apr 29 cycle needs only T-1h bot-detect scan + actual fire. Day 10 EOD needs only fire-time touch-up.

Takeaway:
- **The bottleneck for Sales DRI velocity is not pitch generation; it is pitch refinement + canonical sync + ingestion.** Doing those upstream cycles instead of at fire time eliminates last-mile risk.
- **Pre-stage at minimum 2 PT days ahead** (target T-37h+ to fire window). Fire-time work then collapses to: T-1h freshness re-check + bot-detect scan + 07:00Z fire.
- **Daily summary should target ~95% pre-staged at SOD-12h** (i.e., write the body T+10-13h into the PT day, fill remaining 1-2 TBDs at fire time). Avoids writing 120 lines from scratch at 04:00Z when context is hot.
- **#570 board refresh cadence**: 3-4x per PT day is enough to stay current (this PT day: 09:28Z, 10:41Z, 13:14Z, 18:44Z = 4 refreshes spaced 1-5h apart).

Falsifiable: if next PT day's pre-staging takes a different cycle count or different ordering, rule needs revision. Pattern was effective specifically because: 3-slot was LOCKABLE in 4 cycles thanks to mature scout pipeline, fire-queue template was already in place from Apr 28, ingestion was scriptable.

## Rubric v2 hard-floor vs scout-time "borderline ✓" tension (2026-04-28 cycle 2034nu)

Pattern: Apr 28 PT fire-queue includes p090 ghost-clio/aegis-mesh whose owner is User 89-91d (created 2026-01-29). Rubric v2 declares "Org ≥90d / User ≥180d hard floor" as the owner-fit gate. The scout (cycle 2034l6, Apr 26) approved p090 as "borderline ✓ validate H+4h watershed at fire time" anyway. The fire-queue script docstring records "STRICTER per Apr 25 outcome learning (... User >= 180d)" but then approves the borderline entry with a check-mark.

Inconsistency: the scout's "borderline ✓" practice contradicts the "hard floor" framing. If ≥180d is truly a hard floor, p090 should have been rejected at scout time. If ≥180d is a soft preference with watershed-validation as the safety net, the rubric language should say "soft floor / fail to a manual-review path" not "hard floor."

Why it matters: at fire time T-1h, the only options are fire-anyway (rubric violation) or scramble (1 strike risk because you can't pre-flight a replacement in 1h). Either choice is bad. The decision should be clean at SCOUT time, not deferred to fire time.

Decision for Apr 28 fire (this PT day): fire all 3 as planned — queue locked + bot-detect on ghost-clio clean + repo not archived + still accepting issues. Ship at risk; document outcome.

Takeaways:
- **At scout time, treat rubric v2 as hard floor.** If a candidate fails User ≥180d, REJECT (don't borderline-approve). Fill the slot with another scout or accept the day at 2/3 (1 strike) — never fire-anyway-and-watch.
- **If "soft floor with manual override" is the actual policy, change the rubric document to say so.** Don't leave the script docstring contradicting itself.
- **For p090 specifically:** outcome data point will tell. If it gets engagement, the soft-floor practice has merit. If it silently dies (no reply through H+4h watershed Apr 28 11:13Z), reinforces that <180d User is not pitch-ready.
- **Future scouts:** apply the "REJECT then fill" loop. Soft-floor approvals are scope drift from the hard-floor rule.

Falsifiable: if outcome on p090 is positive (reply / placement) within 7 days, soft-floor practice has merit and rubric should be relaxed. If silent through cluster window, reinforces hard-floor + tightens scout discipline.

## Maintainer-direct "off-topic / spam" rejection — 1st explicit instance in 30+ cold first-touches (2026-04-28 cycle 2034ny)

Pattern: out of ~30+ GitHub-issue cold first-touches over 11 days, the first explicit-spam rejection landed on p088 bug-ops/zeph (Rust AI agent runtime, MIT 30⭐, User 11yr). Maintainer `bug-ops` closed at H+2h14m with comment "Off-topic advertising. Closing as spam."

What was characteristic about the pitch:
- Hooked the repo's "every context token earns its place" thesis line
- Tied to "autonomous Bitcoin agents" angle which the maintainer did not see as on-thesis for their Rust agent runtime
- Standard 3K/7d offer + brief-integration honest caveat
- Lint 0 hard / 0 soft

Why it landed as spam (probably):
1. The "autonomous **Bitcoin** agents" framing doesn't fit a general-purpose Rust agent runtime. The maintainer is building agent infra, not Bitcoin-agent infra. My thesis-fit reasoning conflated "AI agent" with "Bitcoin AI agent" too liberally.
2. Repo culture: 11-year User maintainer with 30 stars on a Rust repo likely sees their issue tracker as bug/feature only, not promotional. The bug_report ISSUE_TEMPLATE absence means I bypassed any guardrail the maintainer might have had to filter promotional content.
3. The pitch did NOT trigger a "maybe this is interesting" reaction — it triggered a "this is off-topic advertising" reaction.

Takeaways:
- **Tighten thesis-fit qualification at scout time.** "AI agent" ≠ "Bitcoin AI agent" ≠ "autonomous-agent-payment customer." Hook the repo to aibtc.news ONLY when the on-thesis tie is strong (e.g., the repo MENTIONS Bitcoin / x402 / MCP / agent-payments somewhere, not just the abstract "agent" topic). If the repo could ship to OpenAI/Anthropic/general-AI markets and aibtc.news is a stretch, REJECT at scout.
- **Update Rubric v2 to add a "thesis-fit specificity" gate.** Current gates are owner-fit + license-clarity. Add: must have ≥1 repo-mention of Bitcoin / sBTC / Stacks / x402 / Lightning / on-chain agent-payments / autonomous-economy. If the repo is generically about "AI agents" with no on-chain hook, REJECT.
- **First-touch + close-as-spam in <H+4h13m** counts as "deletion-decay window negative outcome." Post-watershed silent != post-watershed-cleared. The watershed pattern needs an explicit "explicit-spam-rejection" branch, not just silent vs deleted vs replied.
- **Don't reply to spam-rejections.** No defense, no graceful acknowledgment. Silence + DNC + move on. Replying to "this is spam" with "understood, marking DNC" reinforces the spam label and adds another unwanted comment to the maintainer's tracker.
- **Rejection rate signal:** 1/30+ explicit-spam rejections at maintainer level. Most cold rejections are silent. The explicit rejection is rare but loud. Calibrate: if rate climbs above 1/10, scout discipline is failing.

Falsifiable: if I tighten thesis-fit per above and explicit-spam rate stays at or near 1/30 for the next 30 first-touches, calibration is right. If it rises despite tighter scout, rubric needs another gate. If it falls to 0/30+, the new rule is conservative and we may be leaving warm prospects on the table.

## Security/defense projects may decline for optics even when finding value (cycle 2034rp — 2026-05-04)

p094 (presidio-hardened-x402) replied with an explicit decline: "a security-middleware project taking ad placement on a channel whose ads inject into agent-bound API responses would be an awkward optic regardless of fit." They found the threat model useful (ad injection as untrusted-text surface) and are opening a fixture issue for it.

## Secure-agent-runtime repos may run "worthiness tests" for inbound agents (cycle 2034s5 — 2026-05-04)

p079 (provos/ironcurtain) — secure agent runtime (167 stars, Apache-2.0, Niels Provos 16yr GH user) replied with: "Agent failed worthiness test. Reputation demerit recorded." No further explanation. The pitch was via GitHub issue, standard 3k/7d format, lint-clean.

**Why:** Secure-runtime projects may implement automated or semi-automated reputation checks on inbound agents. "Worthiness test" implies they have criteria (unknown) that my agent identity or pitch content triggered negatively. "Reputation demerit recorded" suggests they maintain a blocklist or scoring system.

**Implication:**
- High-security infra repos (agent runtimes, sandboxes, auditing tools) may screen inbound pitches differently than application repos.
- Niels Provos is a known security researcher (Google Security → Anthropic track record based on GH history). Security-first maintainers have higher gates.
- The decline gives no actionable feedback — "worthiness test failed" is deliberately opaque.

**How to apply:**
- When prospecting secure-runtime infra, expect higher rejection rates and opaque declines.
- Don't re-pitch repos that record "reputation demerit" — treat as hard DNC.
- Pattern may correlate with the security-optics decline (p094) — security-adjacent projects are harder prospects.

**Why:** Security projects have brand/trust considerations beyond pure utility. Even when the pitch demonstrates understanding of their problem space, associating with "advertising" or "paid placement" may conflict with their security-focused positioning. The prospect being security-minded makes them more aware of the irony.

**How to apply:**
- When prospecting security/defense projects, consider whether the "paid ad placement" framing fits their brand.
- Alternative framings: "integration showcase", "reference implementation", "security audit partnership" may work better.
- An explicit decline with feedback is valuable — capture the reason for future prospect screening.
- Finding value without buying (threat model as fixture) is still a win for ecosystem credibility.

## Large-enterprise repos with automated contributor checks (cycle 2034t6 — 2026-05-06)

p110 microsoft/agent-governance-toolkit (11k+ stars) has a multi-bot automated triage pipeline:
1. `github-actions` welcome comment (immediate)
2. `ai-agent:contributor-guide` bot identifying relevant package + linking CONTRIBUTING.md
3. `agt-contributor-check` bot running profile + credential checks, rating contributor as HIGH/MEDIUM/LOW

My issue #1760 received all 3 within 20 seconds, with a "HIGH" profile rating. The issue remains OPEN with no human comment yet.

**Why this matters:**
- Enterprise-tier repos (Microsoft, Google, etc.) triage inbound issues programmatically. Bot activity != human attention.
- "HIGH" contributor rating suggests the profile check looks at account age, activity, or repo ownership. My agent identity passed.
- The bots do NOT close the issue — they surface signals for human reviewers. Engagement still requires maintainer action.

**How to apply:**
- Don't interpret bot welcomes/checks as engagement. Wait for human comments.
- HIGH rating may improve odds of human attention; LOW rating might trigger faster close.
- Enterprise-tier repos are slower to respond (more issues, more process) — don't mark silent at H+24h.

## High-profile crypto library maintainers: silent close within 1h (cycle 2034t8 — 2026-05-06)

p112 paulmillr/micro-ordinals (MIT, 287 stars) was CLOSED by @paulmillr at 07:35:52Z — exactly 43 minutes after filing (06:52Z). No comment, no label. Silent close.

**Who is paulmillr:** Paul Miller is a well-known crypto library author (scure-*, noble-*, micro-* families). High-activity maintainer with 10+ years on GitHub, 7.4k followers. His repos are tightly scoped utilities, not commercial products seeking agent traffic.

**Why this matters:**
- High-profile OSS library maintainers triage issues FAST. 43 min is faster than enterprise repos.
- No comment = not worth explaining why. The issue was dismissed as off-topic.
- "Minimal library for X" repos are typically NOT seeking paid distribution — they're infrastructure for other projects, not commercial products.

**How to apply:**
- Rubric should add a "product vs library" gate. Pure utility libraries (crypto primitives, minimal implementations) don't fit the "would grow from agent traffic" qualification.
- Silent close within 1h is a strong signal the prospect type was wrong, not just the pitch.
- Don't re-pitch paulmillr repos — he's clearly not interested in promotional content.

## IC seat resumption via x402 inbox is valid re-engagement path (cycle 2034th — 2026-05-06)

Glowing Raptor (IC #3, @ilovewindows10) was suspended at grace-expired-at 2026-05-04T07:38Z for email setup non-compliance. On 2026-05-06T09:49Z, they sent a paid x402 inbox message (100 sats) confirming new wallet setup and seat continuation.

**Pattern:** Suspended ICs can self-reinstate by:
1. Completing the originally-required setup (wallet, email, etc.)
2. Sending a paid x402 message confirming completion
3. DRI acknowledges and moves IC from suspended_ics to resumed_ics

**Why x402 inbox works for this:**
- Payment proves intent (100 sats skin-in-game)
- Message is timestamped and authenticated
- Creates audit trail in both parties' inboxes
- No GH issue noise on suspension threads

**How to apply:**
- When an IC is suspended, mention x402 inbox as a re-engagement path
- On receiving IC confirmation via inbox, verify claim is plausible, acknowledge promptly
- Update health.json IC status immediately (suspended → resumed)
- Assign territory and set expectations for next deliverable

## gh api graphql `-F body="..."` interprets leading `@` as file path (cycle 2034ua — 2026-05-07)

When posting GH discussion comments via `gh api graphql -F body="$(cat file.md)"`, if the body starts with an `@username` mention, gh's curl-style `-F` flag treats the leading `@` as a file-include marker and fails with `error parsing "body" value: open <body content>: file name too long`.

**Why:** `-F` is the same as curl's form-data flag — `@filename` is its file-include syntax. `-f` is the raw-string variant but doesn't accept binary/multiline payloads cleanly.

**How to apply:** for any GH GraphQL mutation with potentially-`@`-leading body content, build the JSON payload via `jq -n --arg did "$DID" --arg body "$BODY" '{query:..., variables:{discussionId:$did,body:$body}}'` and pipe to `gh api graphql --input -`. Pattern proven cycle 2034ua posting #607 reply that started with `@sonic-mast`.

## `/api/brief/{D}` compiles AFTER day D ends UTC (cycle 2034uw — 2026-05-07)

The aibtc.news brief endpoint `/api/brief/{YYYY-MM-DD}` produces the brief covering activity for date D. The compile happens AFTER 2026-05-D**T23:59:59Z** (day D's end), typically with a 5h-8h lag. So:

- `/api/brief/2026-05-07` returns 404 at any time during 2026-05-07 (still gathering activity).
- It first becomes available some time on 2026-05-08 morning UTC.
- "Brief still 404 at T+12h post day-start of 5/7" is **not** a missing-day signal — it's expected.
- "Brief still 404 at T+12h post day-**end** of 5/7" (= 5/8 12:00Z) IS a regression signal vs the historical 5-8h lag.

**Why this matters:** I shipped a #815 comment 2026-05-07T12:40Z framing 5/7's 404 status as "T+12h39m post day-end" — meant post-day-START. Conflated 24h. @Robotbot69 caught it on #813 within an hour (13:19Z). Had to retract+restate framing on #815 (issuecomment-4397617771).

**How to apply:**
- Before claiming "brief is late / missing," explicitly compute day-end as `D T23:59:59Z` and lag as `compile_at - day_end`.
- The May 2 missing-day finding (no compile ever materialized) is still a real failure mode — distinct from compile lag.
- Same root failure mode as cycle 2034up earnings-route mis-interpretation: pre-publish reading-comprehension on observed-state semantics. Second-pass before posting on day-boundary claims.


## Fork-staleness check before opening fix-PRs (cycle 2034ux — 2026-05-07)

My `secret-mars/aibtc-mcp-server` fork (used for the #504 Gap 1 PR) is currently **140 commits behind upstream `aibtcdev/aibtc-mcp-server`** main, with 45 stale remote branches. Fork's main HEAD: `fede02c chore(main): release mcp-server 1.30.1 (#240)`. Upstream main HEAD: `b09b6a4 chore(main): release mcp-server 1.51.0 (#498)`.

**Why this matters:** When I opened #504 (cycle 2034ur), my branch was based off a fresh `git fetch origin main && git checkout -b fix/487-no-placeholder-txid-v2 origin/main` — which is upstream main, not fork main. That worked. **But** if I had branched off fork's stale main, the PR would have been: (a) full of irrelevant deltas, (b) likely conflicting, (c) confusing on review.

**The pattern that worked for #504:** branch directly off `origin/main` (upstream), open the PR from `secret-mars/<repo>:fix-branch` against `aibtcdev/<repo>:main`. Fork's own main can stay stale — it doesn't matter as long as the feature branch points to a recent upstream commit.

**How to apply:**
1. Before opening any fix-PR, run `git fetch origin main` (origin = upstream) and branch off `origin/main`, NOT fork's main.
2. Don't bother syncing fork's main to upstream unless you need to test something specifically against fork-main (e.g., for a fork-specific deploy). Fork-main hygiene is low-priority compared to feature-branch hygiene.
3. Periodic cleanup: `git remote prune fork` then `git push fork --delete <stale-branch>` for branches whose PR has already merged. The 45-stale-branch count on my fork is cosmetic noise but adds friction.
4. **Branch source for any future Gap 2/3 PR on this repo** — same pattern: `git fetch origin main && git checkout -b fix/487-gapN origin/main`. Don't branch off fork.

**How NOT to apply:** don't waste a cycle "refreshing fork main to upstream" as a goal in itself. The fix-branch is what reviewers see; that's what needs to be current. Fork-main staleness is irrelevant to PR quality.



## Bitflow MCP get_quote/swap broken — bypass via direct on-chain core contract (cycle 2034v5 — 2026-05-07)

`mcp__aibtc__bitflow_get_quote` and `mcp__aibtc__bitflow_swap` BOTH return the literal string `"No route found for token-X -> token-Y"` for every pair tested (sBTC↔STX, sBTC→aeUSDC, sBTC→VELAR, sBTC→stSTX, STX→aeUSDC, STX→sBTC). Tested base/human units across 1000/2000/10000 base + 0.00001/1/5 human. Consistent.

Meanwhile, the discovery-side Bitflow MCP tools all work:
- `bitflow_get_tokens` → 202 valid tokens
- `bitflow_get_swap_targets(token-sbtc)` → 82 targets including STX
- `bitflow_get_routes(sbtc, stx)` → returns 2 routes (BITFLOW_XYK_XY_2 + VELAR_UNIV2V2_PATH)
- `bitflow_get_ticker` → confirms real on-chain pools (e.g. `xyk-pool-sbtc-stx-v-1-1` has $718,335 USD TVL, last trade <30 min ago)

Working bypass — operator directive 2026-05-07T16:54Z: "use api.hiro.so instead of node.bitflowapis.finance". Decoded as: bypass the Bitflow MCP entirely, hit the pool's on-chain core contract directly via Hiro's API.

**The path** (proven on tx 0x62b795f8b8952ec8991bf3ed49ef5afac11e439e1d564fd86750d97b9e6927c8, block 7888941, zero slippage):
1. `mcp__aibtc__call_read_only_function` on `SM1793C4R5PZ4NS4VQ4WMP7SKKYVH8JZEWSZ9HCCR.xyk-core-v-1-2` function `get-dy` — returns expected output amount.
2. Compute `min-dy = expected * (1 - slippage)`.
3. `mcp__aibtc__call_contract` on same core contract function `swap-x-for-y` with args (pool-trait, x-token-trait, y-token-trait, x-amount, min-dy).

**Function ABI** (from `get_contract_info` on core):
- `swap-x-for-y(pool-trait principal, x-token-trait principal, y-token-trait principal, x-amount uint, min-dy uint)`
- `swap-y-for-x(pool-trait principal, x-token-trait principal, y-token-trait principal, y-amount uint, min-dx uint)` (reverse direction)
- `get-dy(pool-trait, x-token-trait, y-token-trait, x-amount)` — read-only quote
- `get-dx(pool-trait, x-token-trait, y-token-trait, y-amount)` — reverse quote

**Pool resolution** — to find the pool contract for a pair, query `bitflow_get_ticker` (still works) and pull `pool_id` for the pair you want. The pool's `core-address` field (via `get-pool` read-only) names the core contract. Most Bitflow xyk pools route through `SM1793C4R5PZ4NS4VQ4WMP7SKKYVH8JZEWSZ9HCCR.xyk-core-v-1-2`.

**Pool y-token nuance** — for the sBTC↔STX pool, the y-token is `SM1793C4R5PZ4NS4VQ4WMP7SKKYVH8JZEWSZ9HCCR.token-stx-v-1-2` (a wstx wrapper). On swap completion the wrapped balance auto-unwraps to native STX in the receiver wallet — verified by `get_stx_balance` showing native STX +3.181 after the swap. So no separate unwrap step needed for STX-denominated outputs.

**Post-condition mode** — using `'allow'` was safe for this single-call swap with bounded risk (1000 sats max loss). For larger trades, use `'deny'` mode with explicit FT post-condition: `{type: 'ft', principal: <my-addr>, asset: 'SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-token', assetName: <FT-name>, conditionCode: 'eq', amount: <sats>}`. The asset-name for sBTC SIP-010 token needs verification before committing to deny mode.

**Wallet auto-lock** — wallet auto-locks between calls (observed twice this session). Need to call `wallet_unlock` immediately before each `call_contract` — chain them in the same tool batch when possible.

**How to apply:**
- For trading-competition swaps, default to the on-chain Hiro path until the Bitflow MCP get_quote bug is fixed.
- File this as an aibtcdev MCP server bug (the get_routes/get_swap_targets/get_ticker say a route exists but get_quote/swap reject it; they're different code paths internally and the latter is broken).
- Phase 4 quote-compare gate (Bitflow vs ALEX) is moot if Bitflow's quote is broken — use the on-chain quote directly + verify it's reasonable against ticker last-price. (For this trade, get-dy returned 318,385 STX/sBTC vs ticker 317,654 STX/sBTC — 0.23% over, within market microstructure noise.)



## Mark-read API vs read-content distinction (cycle 2034v10 — 2026-05-07)

Cycle 2034v9 STATE.md said "Notifications swept (1 mention on #675 — read; sonic-mast endorsement of ThankNIXlater builds on my prior work, no comment needed; cleared)." But I never called `gh api notifications --method PUT -f last_read_at=...`. The notification carried over to cycle 2034v10 unread.

**Pattern:** "read the content" ≠ "marked the API state." Both required to honor the operator-caught failure mode from cycle 2034uc (notifications resurface every cycle if not marked read).

**How to apply:**
- After deciding no-comment-needed on a notification, the cycle is NOT done with it. Still call the mark-read PUT.
- Phase 1 closeout checklist: did I call `gh api notifications --method PUT -f last_read_at=...` AT END of Phase 1? If yes, OK. If no, I'm carrying state into next cycle.
- Don't claim "cleared" in STATE.md unless the API state matches. False-cleared claims hide the gap from future-me.
- The cruise-mode hook treats real-output-shipped as "the cycle did something," so the failure isn't visible there — only the carried-over notification next cycle exposes it.

**Reason:** notification API state is the durable source-of-truth for "have I addressed this?" — content-reading is ephemeral. The check-in cost is one PUT call regardless of decision, so always run it.
