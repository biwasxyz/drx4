#!/bin/bash
# Daily reach check for our active classified.
# Polls the 4 surfaces Robotbot69 committed to report on (#664 discussioncomment-16747033)
# and writes a JSON snapshot to daemon/distribution-daily/YYYY-MM-DD.json.
#
# Cross-checks Distribution DRI's report. Run daily during the 7-day live test
# window (2026-04-28 → 2026-05-05) for our classified id 6cc36734.

set -eu

CLASSIFIED_ID="${CLASSIFIED_ID:-6cc36734-c270-4f9d-bcb7-756898e3a4aa}"
OUT_DIR="${OUT_DIR:-/home/mars/drx4/daemon/distribution-daily}"
TODAY=$(date -u +%Y-%m-%d)
NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)
OUT="$OUT_DIR/$TODAY.json"

mkdir -p "$OUT_DIR"

UA="agent-test-distribution-check/1.0"

# Item 1: Listing record itself (active + status).
LISTING=$(curl -s "https://aibtc.news/api/classifieds/$CLASSIFIED_ID" 2>/dev/null)

# Item 2: /api/classifieds rotation list (does our id appear?).
ROTATION=$(curl -s "https://aibtc.news/api/classifieds" -H "User-Agent: $UA" 2>/dev/null)
IN_ROTATION=$(echo "$ROTATION" | jq --arg id "$CLASSIFIED_ID" '[.classifieds[]? | select(.id==$id)] | length > 0' 2>/dev/null || echo "false")

# Item 3: /api/front-page agent envelope — does it carry our id?
FRONT_PAGE=$(curl -s "https://aibtc.news/api/front-page" -H "User-Agent: $UA" 2>/dev/null)
IN_FRONT_PAGE=$(echo "$FRONT_PAGE" | jq --arg id "$CLASSIFIED_ID" '[.classifieds[]? | select(.id==$id)] | length > 0' 2>/dev/null || echo "false")

# Item 4: /api/briefs/{today} agent envelope — same check.
BRIEF=$(curl -s "https://aibtc.news/api/briefs/$TODAY" -H "User-Agent: $UA" 2>/dev/null)
IN_BRIEF=$(echo "$BRIEF" | jq --arg id "$CLASSIFIED_ID" '[.classifieds[]? | select(.id==$id)] | length > 0' 2>/dev/null || echo "false")

# Bonus: /api/signals agent envelope.
SIGNALS=$(curl -s "https://aibtc.news/api/signals?limit=1" -H "User-Agent: $UA" 2>/dev/null)
IN_SIGNALS=$(echo "$SIGNALS" | jq --arg id "$CLASSIFIED_ID" '[.classifieds[]? | select(.id==$id)] | length > 0' 2>/dev/null || echo "false")

# Bonus: total active classifieds in pool (denominator for rotation odds).
ACTIVE_COUNT=$(echo "$ROTATION" | jq '[.classifieds[]? | select(.active==true)] | length' 2>/dev/null || echo "0")

LISTING_STATUS=$(echo "$LISTING" | jq -r '.status // "null"')
LISTING_ACTIVE=$(echo "$LISTING" | jq -r '.active // false')

cat > "$OUT" <<EOF
{
  "checked_at": "$NOW",
  "classified_id": "$CLASSIFIED_ID",
  "listing": {
    "status": "$LISTING_STATUS",
    "active": $LISTING_ACTIVE
  },
  "surfaces": {
    "in_rotation_list": $IN_ROTATION,
    "in_front_page_envelope": $IN_FRONT_PAGE,
    "in_brief_envelope": $IN_BRIEF,
    "in_signals_envelope": $IN_SIGNALS
  },
  "context": {
    "active_pool_size": $ACTIVE_COUNT,
    "user_agent": "$UA"
  }
}
EOF

echo "wrote $OUT"
cat "$OUT" | jq '.surfaces'
