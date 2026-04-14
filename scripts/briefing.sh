#!/usr/bin/env bash
# Cycle-start briefing: prints goal + backlog + drift tells.
# Run at the top of every cycle so "what am I trying to do" is unambiguous.

set -euo pipefail
cd "$(dirname "$0")/.."

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
echo "Open BFF PRs:"
gh search prs --author secret-mars --state open --json number,title,repository --jq '.[] | "  \(.repository.name)#\(.number) \(.title)"' 2>/dev/null | head -10
echo ""
echo "Unreviewed GH notifications: $(gh api /notifications?all=false --jq 'length' 2>/dev/null || echo '?')"
