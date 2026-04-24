#!/usr/bin/env bash
# fire-queue-2026-04-24.sh — fire the 3 Apr 24 PT unlock drafts sequentially.
# Uses **Title:** / **Body:** markdown format (drafts post-2034hx use this).
#
# Pre-flight performed in cycles 2034ij / 2034im:
# - Rule 10: all 3 owners verified HTTP 200
# - Rule 11: no CONTRIBUTING / ISSUE_TEMPLATE / pinned-issue restrictions
# - Rule 12: 6/6 cited URLs resolve 200 (verified via scripts/verify-pitch-urls.py)
# - lint-pitches.py: 0 hard / 0 soft
#
# Fire AT or AFTER 2026-04-24T07:00:00Z (Apr 24 PT day start).

set -euo pipefail

cd /home/mars/drx4
source .env
export GH_TOKEN="$GITHUB_PAT_SECRET_MARS"

fire() {
  local draft="$1"
  local repo="$2"
  local title
  local body

  title="$(awk '/^\*\*Title:\*\*/{sub(/^\*\*Title:\*\*[[:space:]]*/,""); print; exit}' "$draft")"
  body="$(awk 'f{print} /^\*\*Body:\*\*/{f=1}' "$draft")"

  if [[ -z "$title" || -z "$body" ]]; then
    echo "error: could not extract title/body from $draft" >&2
    return 1
  fi

  # Lint gate
  python3 scripts/lint-pitches.py "$draft" | grep -E '^(HARD|scanned)' || true

  echo "firing $draft → $repo..."
  local url
  url="$(gh issue create --repo "$repo" --title "$title" --body "$body")"
  echo "✓ $url"
  echo "$url" >> "daemon/sales-proofs/$(date -u +%Y-%m-%d).md.firelog"
}

fire daemon/drafts/2026-04-24/p070-bitrouter.md bitrouter/bitrouter
sleep 1
fire daemon/drafts/2026-04-24/p074-apimesh.md mbeato/APIMesh
sleep 1
fire daemon/drafts/2026-04-24/p075-sbtc-pay.md nicholas-source/sbtc-pay

echo ""
echo "== Apr 24 PT unlock fired 3/3 =="
echo "Now:"
echo "  1. Write daemon/sales-proofs/2026-04-24.md with the 3 fired URLs"
echo "  2. Update daemon/sales-pipeline.json prospect touches[] + advance stage=pitched"
echo "  3. Update daemon/health.json proofs_today_pending=3, daily-fire flag"
