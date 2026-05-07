#!/usr/bin/env bash
# Claude Code hook → drx4-status worker (Server-Sent Events feed).
# Wired in ~/.claude/settings.json under "hooks":
#   PreToolUse, PostToolUse, UserPromptSubmit, Stop, Notification.
#
# Hook input is JSON on stdin per Claude Code spec. We read what we need,
# sanitize, and POST to $STATUS_ENDPOINT with $STATUS_TOKEN.
#
# Env (set via launcher or .env propagation):
#   STATUS_ENDPOINT — e.g. https://status.drx4.xyz/event
#   STATUS_TOKEN    — Bearer token matching the worker's POST_TOKEN secret
# Optional:
#   STATUS_HOOK_KIND — override the kind (defaults from $CLAUDE_HOOK_EVENT)
#
# Always exits 0; never blocks the agent on a failed POST.

set -u
endpoint="${STATUS_ENDPOINT:-}"
token="${STATUS_TOKEN:-}"
[ -z "$endpoint" ] && exit 0
[ -z "$token" ] && exit 0

raw="$(cat)"

# Map Claude hook event to short kind. Event name is in $CLAUDE_HOOK_EVENT
# when Claude Code sets it; otherwise read .hook_event_name from the JSON.
event="${CLAUDE_HOOK_EVENT:-${STATUS_HOOK_KIND:-}}"
if [ -z "$event" ] && command -v jq >/dev/null 2>&1; then
  event="$(printf '%s' "$raw" | jq -r '.hook_event_name // empty' 2>/dev/null)"
fi
[ -z "$event" ] && event="note"
case "$event" in
  PreToolUse)        kind="tool_pre" ;;
  PostToolUse)       kind="tool_post" ;;
  UserPromptSubmit)  kind="prompt" ;;
  Stop)              kind="stop" ;;
  Notification)      kind="note" ;;
  *)                 kind="$(printf '%s' "$event" | tr '[:upper:]' '[:lower:]')" ;;
esac

# Best-effort field extraction with jq (skipped silently if jq missing).
tool=""
body=""
if command -v jq >/dev/null 2>&1; then
  tool="$(printf '%s' "$raw"   | jq -r '.tool_name // .tool // empty' 2>/dev/null)"
  case "$kind" in
    tool_pre)
      body="$(printf '%s' "$raw" | jq -r '.tool_input // empty | tostring' 2>/dev/null)"
      ;;
    tool_post)
      body="$(printf '%s' "$raw" | jq -r '
        ((.tool_input // empty) | tostring) as $i
        | ((.tool_response.output // .tool_response // empty) | tostring) as $o
        | $i + "\n→ " + $o' 2>/dev/null)"
      ;;
    prompt)
      body="$(printf '%s' "$raw" | jq -r '.prompt // .user_prompt // empty' 2>/dev/null)"
      ;;
    stop)
      body="$(printf '%s' "$raw" | jq -r '.transcript_path // empty' 2>/dev/null)"
      ;;
    *)
      body="$(printf '%s' "$raw" | jq -r '.message // empty' 2>/dev/null)"
      ;;
  esac
fi

# Sanitize: drop secrets + draft contents before publishing.
redact() {
  local s="$1"
  # Hard secrets — drop entire lines containing wallet/env/token-shaped material.
  s="$(printf '%s' "$s" | sed -E '/(\.wallet-password|\.env|mnemonic|xprv|xpriv|BEGIN [A-Z ]*PRIVATE KEY|ssh-rsa|ssh-ed25519|sk-[A-Za-z0-9_-]{20,}|ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|gho_[A-Za-z0-9]{20,}|sbp_[A-Za-z0-9]{20,}|xoxb-[A-Za-z0-9-]{20,}|AKIA[A-Z0-9]{16}|password|POST_TOKEN|STATUS_TOKEN|CLOUDFLARE_API_TOKEN|TG_BOT_TOKEN|ANTHROPIC_API_KEY)/d')"
  # Draft text in /tmp/*.md or daemon/drafts/**/*.md — replace content with placeholder.
  if printf '%s' "$s" | grep -qE '/(tmp|daemon/drafts)/[^[:space:]]*\.md'; then
    s="$(printf '%s' "$s" | sed -E 's#("?file_path"?[: ]+"?/(tmp|home/agent/drx4/daemon/drafts)/[^"]+\.md"?)[^}]*#\1 <DRAFT REDACTED>#g')"
  fi
  # Generic high-entropy token guard: long opaque alphanum-runs get masked.
  s="$(printf '%s' "$s" | sed -E 's/[A-Za-z0-9_-]{40,}/<REDACTED>/g')"
  # Hard cap.
  printf '%s' "$s" | head -c 6000
}

tool="$(redact "$tool")"
body="$(redact "$body")"

payload="$(jq -n \
  --arg kind "$kind" \
  --arg tool "$tool" \
  --arg body "$body" \
  '{kind:$kind, tool: ($tool|select(.!="")), body: ($body|select(.!=""))}' 2>/dev/null)"

[ -z "$payload" ] && exit 0

# Fire-and-forget. 1s timeout so a slow worker can't stall the agent.
curl -sS -m 1 -o /dev/null \
  -H "authorization: Bearer $token" \
  -H "content-type: application/json" \
  --data-binary "$payload" \
  "$endpoint" >/dev/null 2>&1 || true

exit 0
