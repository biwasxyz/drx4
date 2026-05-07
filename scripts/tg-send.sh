#!/bin/bash
# Send a Telegram message via the Secret Mars bot.
# Token + chat ID loaded from <repo>/.env.
#
# Usage:
#   tg-send.sh "message text"
#   echo "message" | tg-send.sh -
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$REPO_ROOT/.env"
[ -f "$ENV_FILE" ] || { echo "missing $ENV_FILE" >&2; exit 1; }

TG_TOKEN=$(grep '^TG_TOKEN=' "$ENV_FILE" | cut -d= -f2-)
TG_CHAT_ID=$(grep '^TG_CHAT_ID=' "$ENV_FILE" | cut -d= -f2-)
[ -n "$TG_TOKEN" ] || { echo "TG_TOKEN missing in $ENV_FILE" >&2; exit 1; }
[ -n "$TG_CHAT_ID" ] || { echo "TG_CHAT_ID missing in $ENV_FILE" >&2; exit 1; }

if [ "${1:-}" = "-" ] || [ $# -eq 0 ]; then
  TEXT=$(cat)
else
  TEXT="$*"
fi

curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
  -H "Content-Type: application/json" \
  --data "$(jq -Rn --arg chat "$TG_CHAT_ID" --arg text "$TEXT" '{chat_id: $chat, text: $text, parse_mode: "Markdown", disable_web_page_preview: true}')"
echo
