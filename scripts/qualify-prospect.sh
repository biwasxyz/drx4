#!/usr/bin/env bash
# qualify-prospect.sh — apply Sales DRI Prospect Qualification Rubric v1
# (daemon/sales-quality-rubric-v1.md) to a GitHub repo.
#
# Usage:
#   scripts/qualify-prospect.sh <owner>/<repo>
#   scripts/qualify-prospect.sh https://github.com/owner/repo
#
# Outputs a 100-point qualification card. Exit 0 if score >= 70 (pitch-ready),
# 1 if 50-69 (hold), 2 if <50 or anti-pattern hit (skip).
#
# Auth: relies on $GITHUB_PAT_SECRET_MARS in .env (or pre-existing $GH_TOKEN).

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: $0 <owner>/<repo> | https://github.com/<owner>/<repo>" >&2
  exit 64
fi

cd "$(dirname "$0")/.."
[[ -f .env ]] && source .env
export GH_TOKEN="${GH_TOKEN:-${GITHUB_PAT_SECRET_MARS:-}}"

# Normalize input
input="$1"
input="${input#https://github.com/}"
input="${input%/}"
input="${input%/issues*}"
input="${input%/pull*}"
input="${input%/discussions*}"
repo="$input"

if [[ ! "$repo" =~ ^[^/]+/[^/]+$ ]]; then
  echo "error: could not parse repo from '$1' — expected owner/repo" >&2
  exit 64
fi

owner="${repo%%/*}"

echo "=== Prospect: $repo ==="

# Fetch repo + owner data
repo_json=$(gh api "repos/$repo" 2>/dev/null || echo '{}')
owner_json=$(gh api "users/$owner" 2>/dev/null || echo '{}')

if [[ "$repo_json" == "{}" || "$(echo "$repo_json" | jq -r '.message // ""')" == "Not Found" ]]; then
  echo "ERROR: repo not found" >&2
  exit 2
fi

archived=$(echo "$repo_json" | jq -r '.archived // false')
disabled=$(echo "$repo_json" | jq -r '.disabled // false')
has_issues=$(echo "$repo_json" | jq -r '.has_issues // false')
license=$(echo "$repo_json" | jq -r '.license.spdx_id // "?"')
stars=$(echo "$repo_json" | jq -r '.stargazers_count // 0')
pushed_at=$(echo "$repo_json" | jq -r '.pushed_at // ""')
description=$(echo "$repo_json" | jq -r '.description // ""')
default_branch=$(echo "$repo_json" | jq -r '.default_branch // "main"')

owner_type=$(echo "$owner_json" | jq -r '.type // "?"')
owner_created=$(echo "$owner_json" | jq -r '.created_at // ""')
owner_repos=$(echo "$owner_json" | jq -r '.public_repos // 0')
owner_blog=$(echo "$owner_json" | jq -r '.blog // ""')
owner_name=$(echo "$owner_json" | jq -r '.name // ""')

# === Anti-pattern checks (auto-skip if hit) ===
antipattern_hits=()

if [[ "$archived" == "true" ]]; then antipattern_hits+=("repo archived"); fi
if [[ "$disabled" == "true" ]]; then antipattern_hits+=("repo disabled"); fi

# 20k+ stars → auto-triage risk
if (( stars >= 20000 )); then
  antipattern_hits+=("20k+ stars (auto-triage risk per cycle 2034cf)")
fi

# Owner age check
owner_age_days=0
if [[ -n "$owner_created" ]]; then
  owner_age_days=$(( ($(date -u +%s) - $(date -u -d "$owner_created" +%s)) / 86400 ))
fi

# 1mo-old solo org → high deletion risk
if [[ "$owner_type" == "Organization" ]] && (( owner_age_days < 30 )); then
  antipattern_hits+=("1mo-old org high-deletion-risk per p081 learning")
fi

# Topic tag check (talent-protocol, buildathon, hackathon)
topics=$(echo "$repo_json" | jq -r '.topics[]?' 2>/dev/null | tr '\n' ',' || echo "")
if echo "$topics" | grep -qE '(talent-protocol|buildathon|hackathon)'; then
  antipattern_hits+=("buildathon/grinder topic tag: $topics")
fi

# Owner farming pattern (40+ repos)
if (( owner_repos >= 40 )); then
  antipattern_hits+=("owner has $owner_repos public repos (farming pattern threshold)")
fi

# === Score calculation ===
score=0

# Activity-this-week (25 pts)
activity_pts=0
activity_note="no recent push"
if [[ -n "$pushed_at" ]]; then
  push_age_h=$(( ($(date -u +%s) - $(date -u -d "$pushed_at" +%s)) / 3600 ))
  if (( push_age_h < 24 )); then activity_pts=25; activity_note="push <24h ago"
  elif (( push_age_h < 72 )); then activity_pts=20; activity_note="push <72h ago"
  elif (( push_age_h < 168 )); then activity_pts=15; activity_note="push <7d ago"
  elif (( push_age_h < 336 )); then activity_pts=5; activity_note="push <14d ago"
  else activity_pts=0; activity_note="push >14d ago — stale"
  fi
fi
score=$((score + activity_pts))

# Agent-usable surface (20 pts) — heuristic: description mentions MCP/SDK/CLI/agent
agent_pts=0
agent_note="not detected"
desc_lower=$(echo "$description" | tr '[:upper:]' '[:lower:]')
if echo "$desc_lower" | grep -qE '(mcp|sdk|cli|agent|x402|skill)'; then
  agent_pts=20
  agent_note="MCP/SDK/CLI/agent term in description"
elif echo "$topics" | grep -qE '(mcp|x402|agent|sdk)'; then
  agent_pts=20
  agent_note="agent-relevant topic tag: $topics"
fi
score=$((score + agent_pts))

# Growth-mode signal (20 pts) — commits in last 7 days
growth_pts=0
growth_note="no recent commits"
recent_commits=$(gh api "repos/$repo/commits?since=$(date -u -d '7 days ago' +%Y-%m-%dT%H:%M:%SZ)" --jq '. | length' 2>/dev/null || echo "0")
if (( recent_commits >= 5 )); then growth_pts=20; growth_note="$recent_commits commits past 7d (active shipping)"
elif (( recent_commits >= 1 )); then growth_pts=15; growth_note="$recent_commits commits past 7d"
fi
score=$((score + growth_pts))

# License clarity (10 pts)
license_pts=0
license_note="$license"
case "$license" in
  MIT|Apache-2.0|BSD-3-Clause|BSD-2-Clause|ISC|MPL-2.0|GPL-3.0|AGPL-3.0|LGPL-3.0)
    license_pts=10 ;;
  NOASSERTION|""|"?") license_pts=3; license_note="$license (manual review)" ;;
  *) license_pts=5 ;;
esac
score=$((score + license_pts))

# Owner trust signal (10 pts)
trust_pts=0
trust_note="$owner_type, age=${owner_age_days}d, repos=$owner_repos"
if [[ "$owner_type" == "User" ]] && (( owner_age_days >= 180 )); then
  trust_pts=10
  trust_note="$owner_type 6mo+ ($owner_age_days days)${owner_name:+, name=$owner_name}${owner_blog:+, blog=$owner_blog}"
elif [[ "$owner_type" == "Organization" ]] && (( owner_age_days >= 90 )); then
  trust_pts=10
  trust_note="$owner_type 3mo+ ($owner_age_days days)${owner_name:+, name=$owner_name}${owner_blog:+, blog=$owner_blog}"
elif (( owner_age_days >= 30 )); then
  trust_pts=5
  trust_note="age $owner_age_days days (above 30d threshold)"
elif (( owner_age_days > 0 )); then
  trust_pts=0
  trust_note="age $owner_age_days days (below 30d, deletion risk per p081)"
fi
score=$((score + trust_pts))

# Outreach channel fit (10 pts)
channel_pts=0
channel_note="no path detected"
if [[ "$has_issues" == "true" ]]; then
  channel_pts=10
  channel_note="has_issues=true"
fi
score=$((score + channel_pts))

# Anti-pattern absence (5 pts)
antipattern_pts=5
if (( ${#antipattern_hits[@]} > 0 )); then
  antipattern_pts=0
fi
score=$((score + antipattern_pts))

# === Output ===
printf "  Activity-this-week  (25): %2d  %s\n" "$activity_pts" "$activity_note"
printf "  Agent-usable surface (20): %2d  %s\n" "$agent_pts" "$agent_note"
printf "  Growth-mode signal  (20): %2d  %s\n" "$growth_pts" "$growth_note"
printf "  License clarity     (10): %2d  %s\n" "$license_pts" "$license_note"
printf "  Owner trust signal  (10): %2d  %s\n" "$trust_pts" "$trust_note"
printf "  Outreach channel    (10): %2d  %s\n" "$channel_pts" "$channel_note"
printf "  Anti-pattern absent  (5): %2d  %s\n" "$antipattern_pts" "$([ ${#antipattern_hits[@]} -eq 0 ] && echo 'clean' || printf '%s; ' "${antipattern_hits[@]}")"
echo "  -----"
printf "  Total: %d / 100\n\n" "$score"

# Channel tier
tier="3"
if [[ "$has_issues" == "true" ]]; then tier="1"; fi
echo "  Channel tier: $tier"

# Verdict
if (( ${#antipattern_hits[@]} > 0 )); then
  echo "  Verdict: SKIP (anti-pattern: ${antipattern_hits[*]})"
  exit 2
elif (( score >= 70 )); then
  echo "  Verdict: PITCH-READY"
  exit 0
elif (( score >= 50 )); then
  echo "  Verdict: HOLD (50-69 range — wait for growth signal)"
  exit 1
else
  echo "  Verdict: SKIP (<50)"
  exit 2
fi
