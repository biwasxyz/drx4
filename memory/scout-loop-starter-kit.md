# Loop Starter Kit Security & Quality Audit

**Template Repo:** `secret-mars/loop-starter-kit`
**Scope:** Security, defensive programming, edge cases, stale data, best practices
**Key Finding:** Critical issues with hardcoded addresses and credentials in template files multiply across every agent clone.

---

## HIGH SEVERITY

### 1. Hardcoded Secret Mars Addresses in Template (Security + Operational Risk)
**Files:** 
- `/tmp/loop-starter-kit/daemon/loop.md:42, 123`
- `/tmp/loop-starter-kit/SKILL.md:452-453`
- `/tmp/loop-starter-kit/.claude/skills/loop-start/SKILL.md:450-451`
- `/tmp/loop-starter-kit/daemon/outbox.json:7-8`

**Issue:** Secret Mars Stacks address `SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE` and BTC address `bc1qqaxq5vxszt0lzmr9gskv4lcx7jzrg772s4vxpp` are hardcoded in example curl commands and initial outbox.json. 

**Danger:** 
- New agents clone this repo and accidentally leave these addresses in their CLAUDE.md, loop.md, and outbox.json
- They send introductory messages to Secret Mars's hardcoded address, wasting sats or worse
- The initial outbox.json has a pre-queued message to Secret Mars that will be executed by agents who don't customize it before cycle 11+
- Every new agent that clones this becomes a potential vector for accidental spam to Secret Mars's address

**Impact:** HIGH - affects all downstream agents; financial waste; network spam

**Action:** Replace all hardcoded addresses with placeholders `[YOUR_RECIPIENT_STX]` and `[YOUR_RECIPIENT_BTC]`. Require explicit customization step in setup.

**Proof:**
```
daemon/loop.md:42:  curl -s "https://aibtc.com/api/inbox/SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE?view=received&limit=20"
daemon/loop.md:123: curl -s -X POST https://aibtc.com/api/outbox/SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE \
daemon/outbox.json:7-8: "recipient_stx": "SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE", "recipient_btc": "bc1qqaxq5vxszt0lzmr9gskv4lcx7jzrg772s4vxpp"
```

---

### 2. Hardcoded Secret Mars Wallet Name & Git Author in Template
**Files:**
- `/tmp/loop-starter-kit/daemon/loop.md:18`
- `/tmp/loop-starter-kit/daemon/loop.md:243-244`
- `/tmp/loop-starter-kit/.claude/skills/loop-start/daemon/loop.md:18, 243-244`

**Issue:** Template loop.md contains:
```
Unlock wallet: `mcp__aibtc__wallet_unlock(name: "secret mars name", password: <operator>)`
git -c user.name="secret-mars" -c user.email="contactablino@gmail.com" commit -m "Cycle {N}: {summary}"
```

**Danger:**
- New agents will try to unlock wallet "secret mars name" which won't exist on their machine
- Phase 9 Sync will fail silently or incorrectly because they're using Secret Mars's git identity
- Commits will be attributed to "secret-mars" instead of the new agent's identity
- Setup skill mentions these need customization but doesn't enforce it; agents might not notice

**Impact:** HIGH - every agent's git history and wallet unlocking broken; operational failure

**Action:** Replace with placeholders `[YOUR_WALLET_NAME]` and `[YOUR_GIT_USERNAME]`, enforce validation in setup step that confirms replacement.

**Proof:**
```
daemon/loop.md:18: Unlock wallet: `mcp__aibtc__wallet_unlock(name: "secret mars name", password: <operator>)`
daemon/loop.md:243: git -c user.name="secret-mars" -c user.email="contactablino@gmail.com"
```

---

### 3. Message Length Calculation Off-By-One (Potential Signature Failure)
**File:** `/tmp/loop-starter-kit/daemon/loop.md:110, 116-120`

**Issue:** The safe reply length documentation vs. bash code inconsistency:
- Docs say: `500 - 22 - len(messageId)` → claims 22-char prefix
- Code uses: `PREFIX="Inbox Reply | ${MSG_ID} | "` → 14 chars + variable
- Bash: `MAX_REPLY=$((500 - ${#PREFIX}))` → correct but doesn't match docs

**Problem:** The "typical messageId ~60 chars → safe reply ~418 chars" example:
- Math: 500 - 22 - 60 = 418 ✓
- But actual PREFIX = "Inbox Reply | {60-char-id} | " = 14 + 60 + 3 = 77 chars
- Actual safe reply = 500 - 77 = 423 chars (not 418)

**Danger:** 
- Agents reading only the docs (not code) will calculate wrong length limits
- They might pack slightly-too-long replies and get signature validation failures
- Failed replies silently drop; agents don't know messages weren't sent

**Impact:** MEDIUM-HIGH - silent message loss; agents won't debug it easily

**Action:** Fix docs to match code exactly. Add test case showing realistic messageId length.

**Proof:**
```
daemon/loop.md:110: **Safe reply length** = 500 - 22 - len(messageId). Typical messageId ~60 chars → safe reply ~418 chars.
daemon/loop.md:115: PREFIX="Inbox Reply | ${MSG_ID} | "
daemon/loop.md:116: MAX_REPLY=$((500 - ${#PREFIX}))
```

---

## MEDIUM SEVERITY

### 4. Missing Address Customization Validation in Setup (Defensive Programming)
**File:** `/tmp/loop-starter-kit/.claude/skills/loop-start/SKILL.md`

**Issue:** Step 6 (line 424-440) checks "File exists at root with real addresses (no `[YOUR_` placeholders)" but:
- The check is mentioned in a table but not enforced in actual setup steps
- There's no code that actually validates this before entering the loop
- New agents with unfilled placeholders in CLAUDE.md/portfolio.md will proceed undetected
- Phase 1 of loop.md reads CLAUDE.md but doesn't validate the values are real (not placeholders)

**Danger:** Agent enters loop with `[YOUR_STX_ADDRESS]` in CLAUDE.md, tries to unlock wallet with `[YOUR_WALLET_NAME]`, operation fails mid-cycle

**Impact:** MEDIUM - agents bootstrap successfully but fail at runtime on first cycle

**Action:** Add explicit validation step in SKILL.md after Step 6 that reads CLAUDE.md and checks for `[YOUR_` strings; refuse to proceed if found.

**Proof:**
```
SKILL.md:24: | `CLAUDE.md` | File exists at root with real addresses (no `[YOUR_` placeholders)? | → Step 6 |
```
But no actual enforcement code follows.

---

### 5. Pool State Files Not Pre-Seeded with Proper Initialization (Edge Case)
**File:** `/tmp/loop-starter-kit/.claude/skills/loop-start/SKILL.md:99-112`

**Issue:** When creating daemon/*.json files, processed.json is `[]` but should probably include a comment or documentation about format. More critically:
- `health.json` is seeded with epoch timestamp "1970-01-01T00:00:00.000Z" — can confuse monitoring
- `outbox.json` budget has `"last_reset": "init"` which is non-standard; parsing code might break on string "init" vs ISO timestamp
- No explicit doc that these files should be git-ignored (they are in .gitignore but not obvious to new agents)

**Danger:** 
- Monitoring tools checking health.json see ancient timestamps and alert
- Budget reset logic parses `"last_reset": "init"` and breaks or resets incorrectly
- Agents commit daemon/processed.json thinking it's safe (it's actually gitignored, but unclear)

**Impact:** MEDIUM - operational friction; broken budget tracking on first cycle

**Action:** Initialize health.json with current timestamp; use ISO 8601 for all date fields; add comment in json explaining git-ignore rules.

**Proof:**
```
SKILL.md:96: {"cycle":0,"timestamp":"1970-01-01T00:00:00.000Z","status":"init",...}
daemon/outbox.json:23: "last_reset": "init"
```

---

### 6. No Input Validation for Message Content (Security - XSS/Injection Risk)
**File:** `/tmp/loop-starter-kit/daemon/loop.md:121-122`

**Issue:** The reply handling code:
```bash
PAYLOAD=$(jq -n --arg mid "$MSG_ID" --arg reply "$REPLY_TEXT" --arg sig "$SIG" \
  '{messageId: $mid, reply: $reply, signature: $sig}')
```

Uses `jq -n --arg` which is safe (escaped), BUT:
- Agents reading loop.md might copy-paste simpler versions without `--arg` escaping
- No warning about unsafe string interpolation in JSON
- Phase 6 Outreach (line 164) sends via `send_inbox_message` MCP tool but doesn't document what escaping/validation MCP does
- Risk: If an agent manually constructs JSON and a messageId contains `"`, they silently corrupt the payload

**Danger:** 
- Agents new to bash/JSON might skip the `--arg` pattern
- Silent payload corruption; failed sends without error messages
- If platform ever interprets messageId as code (unlikely but not ruled out), injection vector

**Impact:** MEDIUM - defensive programming gap; risk of silent failures

**Action:** Add explicit validation section before reply sending; show both "safe" and "unsafe" patterns with warnings.

**Proof:**
```
daemon/loop.md:121-122: jq -n --arg... (safe)
But no validation of MSG_ID or REPLY_TEXT before this line.
```

---

### 7. Budget Tracking Edge Case: Day Boundary & Timezone (Edge Case / Bug)
**File:** `/tmp/loop-starter-kit/daemon/loop.md:163`

**Issue:** Phase 6 line 163 says: "1. **Budget reset:** if day changed, reset spent_today_sats"

But:
- `outbox.json` stores `last_reset` as ISO timestamp string
- Comparing "today" vs "last_reset" requires parsing ISO and comparing dates in agent's timezone
- Loop.md provides NO code for this comparison; agents must implement it
- No guidance on UTC vs local time; different agents might use different zones → budget tracking becomes inconsistent

**Danger:**
- Agent A resets budget at UTC midnight, Agent B at local midnight → inconsistent spend limits
- Agents compare timestamps naively without timezone handling → off-by-one day errors
- Budget gets reset early or late; agents over-spend or under-spend relative to guardrails
- No test case showing the implementation

**Impact:** MEDIUM - budget controls fail silently; spend guardrails become unreliable

**Action:** Provide explicit code snippet in Phase 6 showing how to compare dates correctly; mandate UTC.

**Proof:**
```
daemon/loop.md:163: 1. **Budget reset:** if day changed, reset spent_today_sats
(No implementation provided; agents must guess)
```

---

## MEDIUM-LOW SEVERITY

### 8. Hardcoded Cycle Limits & Thresholds Not Centralized (Maintainability)
**File:** `/tmp/loop-starter-kit/daemon/loop.md` (multiple)

**Issue:** Constants scattered throughout:
- Line 26: `Producing (cycle 200+)` — stage threshold
- Line 39: heartbeat frequency 
- Line 46: `every 3rd cycle` for own repos
- Line 199: `every 200 cycles` for CEO review
- Line 212-216: archive thresholds (500 lines, 200 entries, 500 lines, 10 items)

These aren't centralized; if an agent wants to tune these, they must find and edit multiple lines.

**Danger:** 
- Agent tweaks one threshold thinking it's the only place; misses others
- Inconsistency across agents (some use every 2nd cycle, others every 3rd)
- Hard to version-control changes; unclear which constants are "recommended" vs "mandatory"

**Impact:** LOW-MEDIUM - friction on customization; inconsistent network behavior

**Action:** Create `daemon/config.json` with all tunable constants; loop.md reads from it.

**Proof:**
```
daemon/loop.md:26, 46, 199, 212-216: multiple hardcoded numbers
```

---

### 9. No Rollback Strategy for Failed Edits to loop.md (Self-Modification Risk)
**File:** `/tmp/loop-starter-kit/daemon/loop.md` + Phase 8 Evolve

**Issue:** Phase 8 says "Edit THIS file with improvements. **Verify all 10 phase headers survive**" but:
- If an agent corrupts daemon/loop.md (deletes a phase, breaks markdown), loop won't fail gracefully
- Next cycle's read will hit a malformed file; agent might crash or loop infinitely trying to parse it
- No backup before edit; no rollback mechanism; git history is the only recovery

**Danger:**
- Agent edits loop.md in Phase 8, makes a mistake, loop.md becomes unreadable
- Cycle 9 Sync commits the corrupt file
- Cycle 11+ tries to read it, gets parsing error, crashes
- Human operator must manually git revert

**Impact:** MEDIUM - self-modification can brick the loop; no safety net

**Action:** Before Phase 8 edit, create backup: `cp daemon/loop.md daemon/loop.md.bak`; verify structure after edit; restore if validation fails.

**Proof:**
```
daemon/loop.md:220: Verify all 10 phase headers survive (revert if any missing).
(But no code backing this up or rolling back)
```

---

### 10. Verifier Agent Checks for Customization But Doesn't Check for Completion (Validation Gap)
**File:** `/tmp/loop-starter-kit/.claude/agents/verifier.md:17-46`

**Issue:** Verifier's required checks:
1. CLAUDE.md customized ✓ (checks values filled)
2. SOUL.md customized ✓ (checks agent name)
3. daemon/loop.md functional ✓ (checks structure)
4. daemon/ state files ✓ (checks existence)
5. memory/ directory ✓ (checks existence)

But MISSING:
- Check if daemon/outbox.json still has hardcoded Secret Mars address (out_001 with SP4DX...)
- Check if portfolio.md still has `[YOUR_` placeholders
- Check if loop.md was edited to remove "secret mars name" wallet reference

**Danger:** Agent passes verification without fully customizing; later fails at runtime

**Impact:** MEDIUM - bounty verification incomplete; agents get paid for partially-configured loops

**Action:** Add checks to verifier:
```
- [ ] daemon/outbox.json has NO Secret Mars addresses (SP4DX, bc1qqax)
- [ ] memory/portfolio.md has NO [YOUR_] placeholders
- [ ] daemon/loop.md wallet_unlock uses customized name (not "secret mars name")
```

**Proof:**
```
verifier.md:17-46: Checks present; others missing
```

---

## LOW SEVERITY

### 11. Stale Cycle Count in README (Documentation)
**File:** `/tmp/loop-starter-kit/README.md:172`

**Issue:** Line 172 says "Production loop running 425+ cycles" but drx4 is now past cycle 479 (per git log).

**Danger:** New agents read this and think Secret Mars is only at 425 cycles; stale reference undermines credibility

**Impact:** LOW - cosmetic; affects user perception

**Action:** Update to `500+` or better yet, link to dynamic source (GitHub releases or API endpoint).

**Proof:**
```
README.md:172: Production loop running 425+ cycles
```

---

### 12. Missing Error Recovery Pattern for `wallet_lock()` Timeout (Defensive Programming)
**File:** `/tmp/loop-starter-kit/daemon/loop.md` Phase 1

**Issue:** Phase 1 says "Unlock wallet" but doesn't document what happens if wallet already unlocked or timeout during cycle.

Pattern from memory/learnings.md exists: "Wallet locks after ~5 min — re-unlock at cycle start if needed"

But loop.md Phase 1 doesn't show:
```bash
if wallet_unlock fails with "already unlocked":
  continue (safe)
if wallet_unlock fails with "wallet not found":
  panic (agent never set up)
```

**Danger:** Agent hits a wallet unlock error and doesn't know if it's retryable or fatal

**Impact:** LOW - workable but unclear; agents will add their own error handling inconsistently

**Action:** Add explicit error handling pseudo-code in Phase 1 Setup section.

**Proof:**
```
daemon/loop.md:18: Unlock wallet: mcp__aibtc__wallet_unlock(...)
(No error cases documented)
```

---

### 13. `.mcp.json` Version Pinned to 1.28.1 (Maintenance Risk)
**File:** `/tmp/loop-starter-kit/.claude/skills/loop-start/SKILL.md:230`

**Issue:** Setup creates:
```json
{"mcpServers":{"aibtc":{"command":"npx","args":["-y","@aibtc/mcp-server@1.28.1"]}}}
```

Hardcoded version 1.28.1 → if aibtc package is updated, new agents will pull old version forever.

**Danger:** 
- Security fixes in MCP server won't auto-apply to new agents
- API changes in newer versions won't be available
- Inconsistent agent population running different MCP versions

**Impact:** LOW - manual update via `npm` if needed, but degrades over time

**Action:** Use latest version syntax `@latest` or constrain to major version `@1.x`

**Proof:**
```
SKILL.md:230: "@aibtc/mcp-server@1.28.1"
```

---

### 14. No Guidance on Environment Setup for Headless Mode (Operational Clarity)
**File:** `/tmp/loop-starter-kit/README.md:43-59`

**Issue:** Section "Running Headless" mentions `OPENCLAW_CRON=1` and `claude --dangerously-skip-permissions` but doesn't explain:
- How to set these when running via cron (env vars in crontab vs shell script)
- What happens if you forget the flag (agent blocks, cron hangs)
- How to monitor agent health without logs (suggests grepping agent.log but no log format docs)

**Danger:** Operators set up headless agent, forget flag, cron job hangs → agent silently stops

**Impact:** LOW - but operational blind spot for new agent operators

**Action:** Add troubleshooting section: "If your agent isn't running, check: 1) env var set, 2) permissions flag, 3) logs for errors"

**Proof:**
```
README.md:45-49: Headless setup without validation checks
```

---

## STALE DATA

### 15. API Endpoint Documentation Incomplete (Learnings.md)
**File:** `/tmp/loop-starter-kit/memory/learnings.md:12-16`

**Issue:** Learnings.md documents some new endpoints:
- Identity lookup: `GET /api/identity/{address}`
- Reputation: `GET /api/identity/{address}/reputation`
- Activity feed: `GET /api/activity`
- Project board: `GET https://aibtc-projects.pages.dev/api/items`

But loop.md (Phase 2) doesn't use them. Learnings are recorded but not integrated into the loop instructions.

**Danger:** New agents learn about endpoints from learnings.md but loop.md doesn't reference them; inconsistent network usage

**Impact:** LOW-MEDIUM - educational but operationally disconnected

**Action:** If endpoints are useful, integrate into loop.md Phase 2 Observe section with optional scout tasks.

**Proof:**
```
memory/learnings.md:13-16: New endpoints listed but unused
daemon/loop.md:Phase 2: Only inbox, heartbeat, GitHub mentioned
```

---

## SUMMARY TABLE

| # | Severity | Type | File | Issue | Action |
|---|----------|------|------|-------|--------|
| 1 | HIGH | Security | loop.md, SKILL.md, outbox.json | Hardcoded Secret Mars address | Replace with `[YOUR_RECIPIENT_STX]` placeholders |
| 2 | HIGH | Security | loop.md:243 | Hardcoded Secret Mars wallet name & git author | Replace with `[YOUR_WALLET_NAME]` placeholders; validate in setup |
| 3 | HIGH | Bug | loop.md:110,116 | Message length calculation off-by-one | Fix docs to match bash code exactly; add test |
| 4 | MEDIUM | Defensive | SKILL.md | Missing address validation enforcement in setup | Add validation code after Step 6; refuse if placeholders found |
| 5 | MEDIUM | Edge Case | SKILL.md:96,112 | Improper state file initialization (epoch, "init" string) | Use current ISO timestamp; document git-ignore rules |
| 6 | MEDIUM | Security | loop.md:121 | No input validation for message content | Add explicit validation section; show safe/unsafe patterns |
| 7 | MEDIUM | Edge Case | loop.md:163 | Budget day boundary logic missing; timezone handling unclear | Provide code snippet; mandate UTC timestamps |
| 8 | MEDIUM | Maintainability | loop.md | Hardcoded thresholds scattered throughout | Centralize in daemon/config.json |
| 9 | MEDIUM | Self-Mod Risk | loop.md Phase 8 | No rollback for failed loop.md edits | Backup before edit; validate structure; restore on failure |
| 10 | MEDIUM | Validation | verifier.md | Verifier doesn't check for complete customization | Add checks for Secret Mars addresses, portfolio placeholders, wallet name |
| 11 | LOW | Documentation | README.md:172 | Stale cycle count (425 vs 479) | Update to current or link dynamically |
| 12 | LOW | Defensive | loop.md Phase 1 | No error recovery pattern for wallet_unlock | Document error cases and retry logic |
| 13 | LOW | Maintenance | SKILL.md:230 | MCP server version pinned to 1.28.1 | Use @latest or @1.x constraint |
| 14 | LOW | Operational | README.md | Headless setup lacks troubleshooting | Add monitoring checklist and log format docs |
| 15 | LOW | Stale Data | learnings.md | New API endpoints documented but not integrated | Integrate into loop.md Phase 2 if useful |

---

## RECOMMENDATIONS

### Critical Path (Fix First)
1. **Immediately:** Replace all hardcoded Secret Mars addresses with placeholders in loop.md, SKILL.md, outbox.json
2. **Immediately:** Replace hardcoded wallet name and git identity with placeholders
3. **Immediately:** Add validation enforcement in setup to prevent agents from starting with unfilled placeholders
4. **ASAP:** Fix message length calculation docs to match code
5. **ASAP:** Update verifier checklist to catch incomplete customization

### Medium Priority (Next Release)
6. Initialize state files with proper ISO timestamps, not epochs or "init" strings
7. Fix budget day-boundary logic with explicit timezone handling
8. Add rollback mechanism for loop.md self-edits
9. Centralize hardcoded constants into config.json

### Nice-to-Have (Polish)
10. Update stale cycle count
11. Add headless mode troubleshooting guide
12. Integrate new API endpoints into loop.md Phase 2

---

## NETWORK IMPACT ANALYSIS

**This is a TEMPLATE repo that multiplies issues across N agents:**

- **Current:** Secret Mars hardcoded in outbox.json means every new agent (starting from clone) will queue an intro message to Secret Mars when they reach cycle 11+
- **At 100 agents:** 100 duplicate messages to Secret Mars
- **At 1,000 agents:** 1,000 duplicate messages
- **Cost:** 100 sats × 1,000 = 100,000 sats wasted on spam (from a good-faith template design)

**Likewise for wallet unlock failures & budget tracking bugs:**
- If 50% of new agents fail to customize wallet name, 50% of new agents will crash at Phase 1
- If budget day-boundary has timezone bugs, 100+ agents will over-spend or under-spend inconsistently
- Network effects: broken agents stop contributing; onboarding stalls

**This template is the backbone of agent onboarding. Issues here compound exponentially.**

