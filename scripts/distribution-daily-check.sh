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
# Capture headers to inspect X-Edge-Cache (SWR signal added in agent-news PR #718, refs #699).
# Expected values: HIT (fresh cache served), STALE (stale served + background refresh), MISS (cold path through DO).
# Sustained MISS during quiet periods would re-surface the #699 5xx pattern this PR was meant to fix.
ROTATION_HDRS=$(mktemp)
ROTATION=$(curl -s -D "$ROTATION_HDRS" "https://aibtc.news/api/classifieds" -H "User-Agent: $UA" 2>/dev/null)
IN_ROTATION=$(echo "$ROTATION" | jq --arg id "$CLASSIFIED_ID" '[.classifieds[]? | select(.id==$id)] | length > 0' 2>/dev/null || echo "false")
ROTATION_EDGE_CACHE=$(grep -i "^x-edge-cache:" "$ROTATION_HDRS" | tr -d '\r' | awk '{print $2}' | head -1)
ROTATION_EDGE_CACHE=${ROTATION_EDGE_CACHE:-unset}
ROTATION_HTTP_STATUS=$(head -1 "$ROTATION_HDRS" | awk '{print $2}')
ROTATION_HTTP_STATUS=${ROTATION_HTTP_STATUS:-unknown}
rm -f "$ROTATION_HDRS"

# Item 3: /api/front-page agent envelope — does it carry our id?
# Capture body + headers separately to inspect X-Classifieds-Injected (PR #662 signal)
# AND X-Edge-Cache (the brief read-path also flapped per #699; PR #718 only patched
# /api/classifieds — /api/front-page is presumed still cold-boot prone until follow-up
# lands. Tracking the header lets us measure the gap I flagged in PR #718 review).
FRONT_PAGE_HDRS=$(mktemp)
FRONT_PAGE=$(curl -s -D "$FRONT_PAGE_HDRS" "https://aibtc.news/api/front-page" -H "User-Agent: $UA" 2>/dev/null)
IN_FRONT_PAGE=$(echo "$FRONT_PAGE" | jq --arg id "$CLASSIFIED_ID" '[.classifieds[]? | select(.id==$id)] | length > 0' 2>/dev/null || echo "false")
FRONT_PAGE_INJECTED=$(grep -i "^x-classifieds-injected:" "$FRONT_PAGE_HDRS" | tr -d '\r' | awk '{print $2}' | head -1)
FRONT_PAGE_INJECTED=${FRONT_PAGE_INJECTED:-0}
FRONT_PAGE_EDGE_CACHE=$(grep -i "^x-edge-cache:" "$FRONT_PAGE_HDRS" | tr -d '\r' | awk '{print $2}' | head -1)
FRONT_PAGE_EDGE_CACHE=${FRONT_PAGE_EDGE_CACHE:-unset}
FRONT_PAGE_HTTP_STATUS=$(head -1 "$FRONT_PAGE_HDRS" | awk '{print $2}')
FRONT_PAGE_HTTP_STATUS=${FRONT_PAGE_HTTP_STATUS:-unknown}
rm -f "$FRONT_PAGE_HDRS"

# Item 4: /api/brief/{today} agent envelope (singular path; spec said plural but route is singular).
BRIEF=$(curl -s "https://aibtc.news/api/brief/$TODAY" -H "User-Agent: $UA" 2>/dev/null)
IN_BRIEF_DATED=$(echo "$BRIEF" | jq --arg id "$CLASSIFIED_ID" '[.classifieds[]? | select(.id==$id)] | length > 0' 2>/dev/null || echo "false")
BRIEF_COMPILED=$(echo "$BRIEF" | jq -r '.error // (.compiledAt // "null")' 2>/dev/null)

# Item 4b: /api/brief (latest) agent envelope.
BRIEF_LATEST=$(curl -s "https://aibtc.news/api/brief" -H "User-Agent: $UA" 2>/dev/null)
IN_BRIEF_LATEST=$(echo "$BRIEF_LATEST" | jq --arg id "$CLASSIFIED_ID" '[.classifieds[]? | select(.id==$id)] | length > 0' 2>/dev/null || echo "false")
BRIEF_LATEST_DATE=$(echo "$BRIEF_LATEST" | jq -r '.date // "null"')
BRIEF_LATEST_COMPILED_AT=$(echo "$BRIEF_LATEST" | jq -r '.compiledAt // "null"')

# Item 4c: /api/brief/{yesterday} — brief compile cadence is ~5h after midnight UTC, so previous-day's brief
# is the one most likely to be live during the window AND most likely to inject our classified.
YESTERDAY=$(date -u -d "yesterday" +%Y-%m-%d)
BRIEF_YDAY=$(curl -s "https://aibtc.news/api/brief/$YESTERDAY" -H "User-Agent: $UA" 2>/dev/null)
IN_BRIEF_YDAY=$(echo "$BRIEF_YDAY" | jq --arg id "$CLASSIFIED_ID" '[.classifieds[]? | select(.id==$id)] | length > 0' 2>/dev/null || echo "false")
BRIEF_YDAY_COMPILED=$(echo "$BRIEF_YDAY" | jq -r '.error // (.compiledAt // "null")' 2>/dev/null)
# Also check brief TEXT body for our title (compile-time CLASSIFIEDS section per EIC RCA on PR #662).
BRIEF_YDAY_TEXT=$(echo "$BRIEF_YDAY" | jq -r '.text // ""')
if echo "$BRIEF_YDAY_TEXT" | grep -qF "Build your own AIBTC agent in an hour"; then
  IN_BRIEF_YDAY_TEXT=true
else
  IN_BRIEF_YDAY_TEXT=false
fi

# Combined IN_BRIEF: true if any of today/yesterday/latest shows our id.
if [ "$IN_BRIEF_DATED" = "true" ] || [ "$IN_BRIEF_LATEST" = "true" ] || [ "$IN_BRIEF_YDAY" = "true" ]; then
  IN_BRIEF=true
else
  IN_BRIEF=false
fi

# Bonus: /api/signals agent envelope.
SIGNALS_HDRS=$(mktemp)
SIGNALS=$(curl -s -D "$SIGNALS_HDRS" "https://aibtc.news/api/signals?limit=1" -H "User-Agent: $UA" 2>/dev/null)
IN_SIGNALS=$(echo "$SIGNALS" | jq --arg id "$CLASSIFIED_ID" '[.classifieds[]? | select(.id==$id)] | length > 0' 2>/dev/null || echo "false")
SIGNALS_INJECTED=$(grep -i "^x-classifieds-injected:" "$SIGNALS_HDRS" | tr -d '\r' | awk '{print $2}' | head -1)
SIGNALS_INJECTED=${SIGNALS_INJECTED:-0}
rm -f "$SIGNALS_HDRS"

# Item 5: /api/correspondents agent envelope.
CORRES=$(curl -s "https://aibtc.news/api/correspondents" -H "User-Agent: $UA" 2>/dev/null)
IN_CORRES=$(echo "$CORRES" | jq --arg id "$CLASSIFIED_ID" '[.classifieds[]? | select(.id==$id)] | length > 0' 2>/dev/null || echo "false")

# Item 6: /api/skills agent envelope.
SKILLS=$(curl -s "https://aibtc.news/api/skills" -H "User-Agent: $UA" 2>/dev/null)
IN_SKILLS=$(echo "$SKILLS" | jq --arg id "$CLASSIFIED_ID" '[.classifieds[]? | select(.id==$id)] | length > 0' 2>/dev/null || echo "false")

# Item 7: /api/beats/{slug} agent envelope (use aibtc-network as the most-fetched active beat).
BEATS=$(curl -s "https://aibtc.news/api/beats/aibtc-network" -H "User-Agent: $UA" 2>/dev/null)
IN_BEATS=$(echo "$BEATS" | jq --arg id "$CLASSIFIED_ID" '[.classifieds[]? | select(.id==$id)] | length > 0' 2>/dev/null || echo "false")

# Item 8: /api/status/{btc_address} agent envelope (BTC address only — STX returns 404).
STATUS=$(curl -s "https://aibtc.news/api/status/bc1qxhj8qdlw2yalqpdwka8en9h29m6h4n3kyw8vcm" -H "User-Agent: $UA" 2>/dev/null)
IN_STATUS=$(echo "$STATUS" | jq --arg id "$CLASSIFIED_ID" '[.classifieds[]? | select(.id==$id)] | length > 0' 2>/dev/null || echo "false")

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
    "in_signals_envelope": $IN_SIGNALS,
    "in_correspondents_envelope": $IN_CORRES,
    "in_skills_envelope": $IN_SKILLS,
    "in_beats_envelope": $IN_BEATS,
    "in_status_envelope": $IN_STATUS
  },
  "context": {
    "active_pool_size": $ACTIVE_COUNT,
    "user_agent": "$UA",
    "brief_today_compiled_or_error": "$BRIEF_COMPILED",
    "brief_yesterday_date": "$YESTERDAY",
    "brief_yesterday_compiled_or_error": "$BRIEF_YDAY_COMPILED",
    "brief_yesterday_envelope_includes_us": $IN_BRIEF_YDAY,
    "brief_yesterday_text_includes_us": $IN_BRIEF_YDAY_TEXT,
    "brief_latest_date": "$BRIEF_LATEST_DATE",
    "brief_latest_compiled_at": "$BRIEF_LATEST_COMPILED_AT",
    "x_classifieds_injected": {
      "front_page": "$FRONT_PAGE_INJECTED",
      "signals": "$SIGNALS_INJECTED"
    },
    "rotation_endpoint": {
      "http_status": "$ROTATION_HTTP_STATUS",
      "x_edge_cache": "$ROTATION_EDGE_CACHE"
    },
    "front_page_endpoint": {
      "http_status": "$FRONT_PAGE_HTTP_STATUS",
      "x_edge_cache": "$FRONT_PAGE_EDGE_CACHE"
    }
  }
}
EOF

echo "wrote $OUT"
cat "$OUT" | jq '.surfaces'
