#!/usr/bin/env bash
# Cycle-start briefing: prints goal + backlog + drift tells.
# Run at the top of every cycle so "what am I trying to do" is unambiguous.

set -euo pipefail
cd "$(dirname "$0")/.."

# Self-repair: if core.hooksPath drifted away from scripts/hooks, reset it.
# This is the first thing the briefing does so future cycles can't silently
# bypass the cruise-mode block.
current_hooks_path=$(git config --get core.hooksPath || echo "")
if [[ "$current_hooks_path" != "scripts/hooks" ]]; then
  echo "⚠  core.hooksPath drifted ($current_hooks_path) — resetting to scripts/hooks"
  git config core.hooksPath scripts/hooks
fi

echo "============================================"
bash scripts/sales-status.sh 2>/dev/null || echo "(sales-status.sh not available)"
echo "============================================"
echo ""

echo "=== NORTH STAR ==="
cat daemon/NORTH_STAR.md
echo ""
echo "=== LAST CYCLE STATE ==="
cat daemon/STATE.md
echo ""
echo "=== DRIFT CHECK ==="

# Count consecutive state-only commits (cruise cycles that bypassed the hook)
recent=$(git log --format="%s%n%an%x00" -20 --name-only | tr '\n' ' ')
echo "Last 5 commits:"
git log --oneline -5
echo ""

# Count today's outputs (calendar day UTC)
today=$(date -u +%Y-%m-%d)
signals_today=$(grep -c "signals_today" daemon/health.json || echo 0)
prs_open=$(git log --since="${today}T00:00:00Z" --oneline 2>/dev/null | wc -l)

echo "Commits today (UTC): $(git log --since="${today}T00:00:00Z" --oneline 2>/dev/null | wc -l)"
echo ""
echo "CRM route count: $(jq '[.routes // [], .listings_p2p // [], .listings_prediction // []] | add | length' daemon/crm.json 2>/dev/null || echo '?')"
echo "CRM listings live: $(jq '.stats.listings_live' daemon/crm.json 2>/dev/null || echo '?')"
echo ""
echo "Open PRs (all repos):"
gh search prs --author secret-mars --state open --json number,title,repository --jq '.[] | "  \(.repository.nameWithOwner)#\(.number) \(.title)"' 2>/dev/null | head -25
echo ""
echo "=== OUTPUT FLOW (Anthropic harness rule: self-verify before mark complete) ==="
if [[ -f daemon/outputs.log ]]; then
  outputs_today=$(grep -c "^$(date -u +%Y-%m-%d)" daemon/outputs.log 2>/dev/null || echo 0)
  last_output=$(tail -1 daemon/outputs.log 2>/dev/null | head -c 200)
  echo "Outputs logged today (UTC): $outputs_today"
  echo "Most recent: $last_output"
  if [[ "$outputs_today" -lt 1 ]]; then
    echo "⚠  NO OUTPUTS LOGGED TODAY. Daily minimum: 2 BD + 1 signal + 1 BFF + 1 distribution. Pick a backlog item NOW."
  fi
else
  echo "(outputs.log missing — create it before next external-only action)"
fi
echo ""

# Drift signal: commits today touched only STATE/health beyond a threshold = cruise trend
state_only_today=$(git log --since="$(date -u +%Y-%m-%d)T00:00:00Z" --name-only --pretty=format:"---%h" 2>/dev/null | awk '
  /^---/{ if(non_state==0 && has_state==1){cruise++} has_state=0; non_state=0; next }
  /daemon\/STATE\.md|daemon\/health\.json/{ has_state=1; next }
  /./{ non_state=1 }
  END { if(non_state==0 && has_state==1){cruise++} print cruise+0 }')
echo "State-only commits today: $state_only_today (ideal: 0 — hook should block, but drift if it slips through)"
echo ""

echo "=== GH mentions you haven't acted on (drift tell — mentions are never 'stale'; check the thread) ==="
gh api /notifications?all=false --jq '.[] | select(.reason == "mention" or .reason == "review_requested") | "  [\(.reason)] \(.repository.full_name)  \(.subject.title)"' 2>/dev/null | head -20
echo ""
echo "Unreviewed GH notifications total: $(gh api /notifications?all=false --jq 'length' 2>/dev/null || echo '?')"
echo ""
echo "=== Unreplied inbox messages (free-reply eligible) ==="
curl -s "https://aibtc.com/api/inbox/SP4DXVEC16FS6QR7RBKGWZYJKTXPC81W49W0ATJE?status=unread&limit=5" 2>/dev/null \
  | jq -r '.inbox.messages[] | "  \(.peerDisplayName): \(.content[:120])"' 2>/dev/null | head -10
