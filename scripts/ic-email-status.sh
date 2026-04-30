#!/usr/bin/env bash
# ic-email-status.sh — Per-IC email setup status from sales-pipeline.json.
# Reads ic_pool[].email_setup. Reports the active subset (anyone NOT "invited" sole status).
#
# email_setup values:
#   "confirmed"        — test send received at mars@drx4.xyz, IC operational on email
#   "in-progress"      — IC acked mandate, setup underway, test send pending
#   "silent"           — IC has not acked mandate filed at secret-mars/drx4#34
#   "n/a-twitter-only" — off-GH IC, email channel not applicable
#   null               — not yet evaluated (cold pool / not active)
#
# Mandate deadline: 2026-05-02T23:59:00Z (filed 2026-04-29 cycle 2034p7).
set -euo pipefail

REPO_DIR="/home/mars/drx4"
PIPELINE="$REPO_DIR/daemon/sales-pipeline.json"

if [[ ! -f "$PIPELINE" ]]; then
  echo "no pipeline at $PIPELINE"
  exit 1
fi

echo "=== IC Email Setup Status — Mandate deadline 2026-05-02T23:59Z ==="
echo ""

confirmed=$(jq '[.ic_pool[] | select(.email_setup=="confirmed")] | length' "$PIPELINE")
in_progress=$(jq '[.ic_pool[] | select(.email_setup=="in-progress")] | length' "$PIPELINE")
silent=$(jq '[.ic_pool[] | select(.email_setup=="silent")] | length' "$PIPELINE")
twitter_only=$(jq '[.ic_pool[] | select(.email_setup=="n/a-twitter-only")] | length' "$PIPELINE")
gh_active=$((confirmed + in_progress + silent))

printf "%-30s %s\n" "GH-reachable active ICs:" "$gh_active"
printf "  %-28s %d\n" "confirmed:" "$confirmed"
printf "  %-28s %d\n" "in-progress:" "$in_progress"
printf "  %-28s %d (mandate not ack'd)\n" "silent:" "$silent"
printf "%-30s %d (mandate n/a)\n" "Twitter-only ICs:" "$twitter_only"
echo ""
echo "Active IC roster (per-IC):"

jq -r '.ic_pool[] | select(.email_setup != null) | "  \(.name) (\(.handle // "no-gh")) — \(.email_setup)\(if .email_address then " · " + .email_address else "" end)\(if .email_test_send_deadline then " · deadline " + .email_test_send_deadline else "" end)"' "$PIPELINE"

echo ""
echo "Source: \`daemon/sales-pipeline.json\` — \`ic_pool[].email_setup\`."
echo "Mandate: https://github.com/secret-mars/drx4/issues/34"
