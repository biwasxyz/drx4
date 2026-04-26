#!/usr/bin/env bash
# fire-queue-2026-04-27.sh — fire the 3 Apr 27 PT unlock drafts sequentially.
# Uses **Title:** / **Body:** markdown format (drafts post-2034hx use this).
#
# Pre-flight performed in cycle 2034kn:
# - Rule 10: all 3 owners verified HTTP 200 (peacprotocol / reflectt / leventilo)
# - Rule 11: bug_report + feature_request only (none have ISSUE_TEMPLATE dirs)
# - Gate 1 freshness: all pushed within last 60 min at draft time (01:09Z-01:42Z Apr 26)
# - Owner trust: STRICTER per Apr 25 outcome learning (Org >= 90d / User >= 180d)
#   - peacprotocol Org 285d ✓
#   - reflectt Org 175d ✓
#   - leventilo User 284d ✓
# - lint-pitches.py: 0 hard / 0 soft on all 3
# - qualify-prospect.sh v1.1 (DNC fail-closed): 100/100/95 PITCH-READY all
#
# Auto-emits strict-format proof lines into daemon/sales-proofs/YYYY-MM-DD.md
# per learning 2034jn (briefing.sh / sales-status.sh need machine-counted lines).
#
# Fire AT or AFTER 2026-04-27T07:00:00Z (Apr 27 PT day start).

set -euo pipefail

cd /home/mars/drx4
source .env
export GH_TOKEN="$GITHUB_PAT_SECRET_MARS"

PROOF_FILE="daemon/sales-proofs/$(date -u +%Y-%m-%d).md"
FIRELOG="${PROOF_FILE}.firelog"

# Initialize proof file with strict-format block header if it doesn't exist
if [[ ! -f "$PROOF_FILE" ]]; then
  cat > "$PROOF_FILE" <<'HEADER'
# Apr 27 PT day — Sales DRI unlock proofs

## Strict-format machine-readable proofs

HEADER
fi

fire() {
  local draft="$1"
  local repo="$2"
  local prospect="$3"
  local summary="$4"
  local title
  local body

  title="$(awk '/^\*\*Title:\*\*/{sub(/^\*\*Title:\*\*[[:space:]]*/,""); print; exit}' "$draft")"
  body="$(awk 'f{print} /^\*\*Body:\*\*/{f=1}' "$draft")"

  if [[ -z "$title" || -z "$body" ]]; then
    echo "error: could not extract title/body from $draft" >&2
    return 1
  fi

  python3 scripts/lint-pitches.py "$draft" | grep -E '^(HARD|scanned)' || true

  echo "firing $draft → $repo..."
  local url
  url="$(gh issue create --repo "$repo" --title "$title" --body "$body")"
  local ts
  ts="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "✓ $url"
  echo "$url" >> "$FIRELOG"
  # Strict-format proof line for sales-status.sh machine-counting
  echo "- ${ts} | ${prospect} | github_issue | outbound | ${url} | ${summary}" >> "$PROOF_FILE"
}

fire daemon/drafts/2026-04-27/p085-peac.md peacprotocol/peac "peacprotocol/peac" "Apr 27 PT direct first-touch — portable signed proof for agent/API/MCP (Apache-2.0 11⭐), Org 285d"
sleep 1
fire daemon/drafts/2026-04-27/p086-reflectt.md reflectt/reflectt-node "reflectt/reflectt-node" "Apr 27 PT direct first-touch — AI agent team coordination (Apache-2.0 12⭐), Org 175d"
sleep 1
fire daemon/drafts/2026-04-27/p087-boltzpay.md leventilo/boltzpay "leventilo/boltzpay" "Apr 27 PT direct first-touch — fetch() that pays, multi-protocol/multi-chain (MIT 5⭐), User 284d"

echo ""
echo "== Apr 27 PT unlock fired 3/3 =="
echo "Now:"
echo "  1. Verify with: bash scripts/briefing.sh"
echo "  2. Update daemon/sales-pipeline.json prospect touches[] (p085/p086/p087)"
echo "  3. Update daemon/health.json (apr27_fired=3, cold_count_today=3)"
