#!/usr/bin/env bash
# qualify.sh — 3-gate qualification check for classifieds-sales prospects.
#
# Usage: ./qualify.sh owner/repo
# Exits 0 if no gate failed (any mix of pass/uncertain).
# Exits 1 if any gate fails (fatal: skip this prospect).
# Exits 2 on usage / auth error.
#
# Requires `gh` CLI authenticated (gh auth login or GITHUB_TOKEN env var)
# plus `jq` on PATH.
set -euo pipefail

REPO="${1:-}"
if [[ -z "$REPO" ]]; then
  echo "Usage: $0 owner/repo" >&2
  exit 2
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "ERROR: gh CLI not authenticated. Run: gh auth login" >&2
  exit 2
fi

NOW_EPOCH=$(date -u +%s)
WEEK_AGO_EPOCH=$((NOW_EPOCH - 7*86400))

# --- Gate 1: observe-this-week ------------------------------------------------
PUSHED_AT=$(gh api "repos/$REPO" --jq '.pushed_at' 2>/dev/null || echo "")
if [[ -z "$PUSHED_AT" ]]; then
  g1_status="uncertain"
  g1_reason="repo not found or private (verify manually)"
else
  PUSHED_EPOCH=$(date -u -d "$PUSHED_AT" +%s 2>/dev/null || echo 0)
  if (( PUSHED_EPOCH >= WEEK_AGO_EPOCH )); then
    g1_status="pass"
    g1_reason="last push $PUSHED_AT"
  else
    AGE_DAYS=$(( (NOW_EPOCH - PUSHED_EPOCH) / 86400 ))
    g1_status="fail"
    g1_reason="last push $PUSHED_AT (${AGE_DAYS}d stale)"
  fi
fi

# --- Gate 2: can-agents-use ---------------------------------------------------
README_B64=$(gh api "repos/$REPO/readme" --jq '.content' 2>/dev/null || echo "")
README=$(echo "$README_B64" | base64 -d 2>/dev/null || echo "")
if echo "$README" | grep -qiE '\b(api|sdk|mcp|cli|webhook|rest|graphql|endpoint)\b'; then
  g2_status="pass"
  g2_reason="README references agent-consumable surface"
else
  g2_status="uncertain"
  g2_reason="no API/SDK/MCP/CLI keywords in README; verify manually"
fi

# --- Gate 3: would-benefit (growth posture) -----------------------------------
REPO_JSON=$(gh api "repos/$REPO" 2>/dev/null || echo "{}")
STARS=$(echo "$REPO_JSON" | jq -r '.stargazers_count // 0')
ISSUES=$(echo "$REPO_JSON" | jq -r '.open_issues_count // 0')
if (( STARS >= 500 )); then
  g3_status="fail"
  g3_reason="stars=$STARS (>=500: partnership channel, not cold classifieds pitch)"
elif (( ISSUES > 0 )); then
  g3_status="pass"
  g3_reason="stars=$STARS, open_issues=$ISSUES (growth posture)"
else
  g3_status="uncertain"
  g3_reason="stars=$STARS, open_issues=$ISSUES (verify growth signal manually)"
fi

# --- Emit JSON verdict --------------------------------------------------------
jq -n \
  --arg repo "$REPO" \
  --arg g1s "$g1_status" --arg g1r "$g1_reason" \
  --arg g2s "$g2_status" --arg g2r "$g2_reason" \
  --arg g3s "$g3_status" --arg g3r "$g3_reason" \
  '{repo:$repo,
    gate1_observe_this_week:{status:$g1s,reason:$g1r},
    gate2_can_agents_use:{status:$g2s,reason:$g2r},
    gate3_would_benefit:{status:$g3s,reason:$g3r}}'

[[ "$g1_status" == "fail" || "$g2_status" == "fail" || "$g3_status" == "fail" ]] && exit 1
exit 0
