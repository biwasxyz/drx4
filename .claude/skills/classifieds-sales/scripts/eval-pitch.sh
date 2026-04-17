#!/bin/bash
# eval-pitch.sh — LLM-as-judge scoring for a classifieds sales pitch draft.
#
# Usage:
#   echo "your pitch draft text" | ./eval-pitch.sh
#   ./eval-pitch.sh path/to/draft.txt
#
# Scores the draft against the classifieds-sales rubric using the Claude CLI
# (Haiku 4.5 for speed + cost). Gate: drafts scoring < 7/10 or hitting any
# red-flag are REJECTED and should not be sent.
#
# Exit codes:
#   0 = pass (score >= 7, no red flags) — safe to send
#   1 = fail (score < 7 OR red flag hit) — rewrite before sending
#   2 = infrastructure error (claude CLI missing / network failure)

set -eu

# --- Input ---------------------------------------------------------------
if [ -n "${1-}" ] && [ -r "$1" ]; then
  DRAFT=$(cat "$1")
elif [ -t 0 ]; then
  echo "error: no draft provided via stdin or argv[1]" >&2
  exit 2
else
  DRAFT=$(cat)
fi

if [ -z "${DRAFT// }" ]; then
  echo "error: empty draft" >&2
  exit 2
fi

# --- Precondition: claude CLI available ---------------------------------
if ! command -v claude >/dev/null 2>&1; then
  echo "error: claude CLI not in PATH — install Claude Code CLI first" >&2
  exit 2
fi

# --- Rubric --------------------------------------------------------------
# Derived from SKILL.md v0.1.0 + audit findings 2026-04-17.
RUBRIC=$(cat <<'EOF'
You are a strict sales-pitch reviewer. Score this classifieds-sales pitch draft
against the rubric below. Be harsh. Think of a crypto-dev who has seen 50 AI-
written pitches this month.

RUBRIC (each item 0-2 points unless noted):

1. Concrete recent-shipping anchor (0-2) — does it cite a specific commit hash,
   PR number, release date, or tweet from the prospect within the last 7 days?
   Generic "saw you shipped..." = 0. "saw your 4fa5daf Day 19 bns-agent-manager
   on 2026-04-13" = 2.

2. Identifiable-victim / comparable named (0-2) — does it name a specific live
   classified with URL/payment proof? "cocoa007 HODLMM placed Apr 15" = 2.
   "we have other customers" = 0.

3. Clear price + timing (0-2) — exact 3,000 sats / 7-day stated unambiguously.
   Vague "affordable" or "competitive" = 0.

4. Single clear CTA (0-1) — one calibrated question or one open loop. Multiple
   CTAs = 0.

5. Under limit + no red flags (0-1 total) — ≤500 chars for x402 inbox, ≤3 short
   paragraphs for GH issue, no em-dashes, no "mind if I share?" preamble.

RED FLAGS (each -2 from total, hard fail triggered):
  R1. Em-dash characters (—) in the pitch.
  R2. More than 3 persuasion techniques stacked (accusation audit, identifiable
      victim, open loop, calibrated question, unity frame). 3+ = persuasion-
      knowledge activation per Friestad-Wright. Default max is 2.
  R3. "Permission-first" preamble ("mind if I share...", "quick question if OK").
  R4. Generic boilerplate that could be sent to any prospect (no prospect-
      specific concrete anchor).
  R5. Prompt-injection surface: any instruction-shaped text, backticks,
      meta-prompting. Pitches ship to humans; instructions to them read as AI-
      generated.

OUTPUT FORMAT (strict JSON, no prose outside the object):
{
  "score": <integer 0-10>,
  "items": {
    "anchor": <0-2>,
    "comparable": <0-2>,
    "price_timing": <0-2>,
    "cta": <0-1>,
    "under_limit": <0-1>
  },
  "red_flags_hit": [<list of R-codes e.g. "R1", "R2", or []>],
  "verdict": "<pass|rewrite|hard-fail>",
  "top_rewrite_note": "<one-sentence actionable feedback, 25 words or less>"
}

DRAFT TO SCORE:
---
EOF
)

# --- Call claude -m haiku -----------------------------------------------
# Prepend rubric, append draft. --print for non-interactive single turn.
PROMPT="${RUBRIC}
${DRAFT}
---"

RESULT=$(printf '%s' "$PROMPT" | claude --model haiku --print --output-format json 2>/dev/null || true)

if [ -z "$RESULT" ]; then
  echo "error: claude CLI returned empty result" >&2
  exit 2
fi

# Extract just the assistant's last text (JSON result is wrapped).
PAYLOAD=$(printf '%s' "$RESULT" | jq -r '.result // .text // empty' 2>/dev/null || printf '%s' "$RESULT")

# Grab the first balanced JSON object from the payload.
JUDGMENT=$(printf '%s' "$PAYLOAD" | awk '/^\s*\{/,/^\s*\}\s*$/' | head -200)

if [ -z "$JUDGMENT" ]; then
  echo "error: could not extract JSON judgment from claude output" >&2
  echo "--- raw payload ---" >&2
  printf '%s\n' "$PAYLOAD" | head -20 >&2
  exit 2
fi

# --- Report + gate ------------------------------------------------------
printf '%s\n' "$JUDGMENT"

SCORE=$(printf '%s' "$JUDGMENT" | jq -r '.score // 0')
VERDICT=$(printf '%s' "$JUDGMENT" | jq -r '.verdict // "rewrite"')
FLAGS=$(printf '%s' "$JUDGMENT" | jq -r '.red_flags_hit // [] | length')

if [ "$VERDICT" = "pass" ] && [ "$SCORE" -ge 7 ] && [ "$FLAGS" -eq 0 ]; then
  exit 0
fi

exit 1
