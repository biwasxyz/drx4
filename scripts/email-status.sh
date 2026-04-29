#!/usr/bin/env bash
# email-status.sh — concise deliverability snapshot from Resend API.
# Reads daemon/outbox/email-sent.jsonl, queries Resend for each ID, prints status table.
# Use: bash scripts/email-status.sh [N]   # default last 10 sends
set -euo pipefail

REPO_DIR="/home/mars/drx4"
LOG="$REPO_DIR/daemon/outbox/email-sent.jsonl"
LIMIT="${1:-10}"

if [[ ! -f "$LOG" ]]; then
  echo "no send log at $LOG"
  exit 1
fi

RESEND_KEY=$(grep '^RESEND_API_KEY=' "$REPO_DIR/.env" | cut -d= -f2)
if [[ -z "$RESEND_KEY" ]]; then
  echo "error: RESEND_API_KEY not in .env"
  exit 1
fi

TOTAL=$(wc -l < "$LOG")
TODAY=$(date -u +%Y-%m-%d)
TODAY_COUNT=$(awk -F'"' -v d="$TODAY" '$0 ~ d' "$LOG" | wc -l)

printf "=== Email send log: %d total · today=%d (UTC %s) · showing last %d ===\n\n" "$TOTAL" "$TODAY_COUNT" "$TODAY" "$LIMIT"
printf "%-20s  %-30s  %-10s  %-12s\n" "sent_at" "to" "type" "resend_status"
printf "%-20s  %-30s  %-10s  %-12s\n" "--------------------" "------------------------------" "----------" "-------------"

tail -n "$LIMIT" "$LOG" | while read -r line; do
  sent_at=$(echo "$line" | jq -r '.sent_at[0:19]')
  to=$(echo "$line" | jq -r '.to[0]')
  send_type=$(echo "$line" | jq -r '.type')
  rid=$(echo "$line" | jq -r '.resend_id')

  if [[ -n "$rid" && "$rid" != "null" ]]; then
    status=$(curl -s -H "Authorization: Bearer $RESEND_KEY" "https://api.resend.com/emails/$rid" \
      | jq -r '.last_event // "unknown"')
  else
    status="no_id"
  fi

  printf "%-20s  %-30s  %-10s  %-12s\n" "$sent_at" "${to:0:30}" "$send_type" "$status"
done

echo ""
echo "Status legend: queued / delivered / bounced / complained / opened / clicked"
echo "Note: 'delivered' = recipient SMTP accepted; doesn't say which folder Gmail sorted to."
echo "If receiver says 'didn't get it', check Spam + Promotions tabs first."
