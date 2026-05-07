#!/usr/bin/env bash
# Claude Code hook → drx4-status worker (assistant text only).
#
# Strategy: on every hook fire, scan the active transcript JSONL for new
# assistant `text` blocks (the natural-language narration) and POST each one.
# Tool calls, tool results, and thinking blocks are NOT published.
#
# Wired in ~/.claude/settings.json under hooks: PreToolUse, PostToolUse,
# UserPromptSubmit, Stop, Notification.
#
# Required env (set in settings.json or by launcher):
#   STATUS_ENDPOINT — e.g. https://status.drx4.xyz/event
#   STATUS_TOKEN    — Bearer token matching the worker's POST_TOKEN secret

set -u
endpoint="${STATUS_ENDPOINT:-}"
token="${STATUS_TOKEN:-}"
[ -z "$endpoint" ] && exit 0
[ -z "$token" ] && exit 0
command -v jq >/dev/null 2>&1 || exit 0
command -v curl >/dev/null 2>&1 || exit 0

raw="$(cat)"

# Find the active transcript: prefer .transcript_path from the hook payload;
# fall back to the most recently modified .jsonl in the project's transcripts dir.
transcript="$(printf '%s' "$raw" | jq -r '.transcript_path // empty' 2>/dev/null)"
if [ -z "$transcript" ] || [ ! -f "$transcript" ]; then
  transcript="$(ls -t /home/agent/.claude/projects/-home-agent-drx4/*.jsonl 2>/dev/null | head -1)"
fi
[ -z "$transcript" ] || [ ! -f "$transcript" ] && exit 0

# Per-transcript state file (so a new session's first fire doesn't flood
# with the previous session's post-anchor uuid that won't match).
state_dir="$(dirname "$transcript")"
transcript_base="$(basename "$transcript" .jsonl)"
state_file="$state_dir/.status-stream-last-uuid.$transcript_base"
last_uuid="$(cat "$state_file" 2>/dev/null || true)"

# Safety cap: never POST more than this many text blocks per hook fire,
# so a missing-anchor case can't dump an entire transcript.
MAX_PER_FIRE=5

# Sanitize before publishing (defense-in-depth — assistant text occasionally
# echoes file contents or tokens it just read).
#
# Two layers:
#   1. Drop whole lines that mention known-secret keywords or token formats.
#   2. Redact any remaining 40+-char alphanumeric run, EXCEPT public on-chain
#      identifiers (Stacks addresses, BTC bech32 addresses, 64-hex txids) —
#      those are safe to publish and the loop narrates them constantly.
redact() {
  local s="$1"
  s="$(printf '%s' "$s" | sed -E '/(\.wallet-password|\.env|mnemonic|xprv|xpriv|BEGIN [A-Z ]*PRIVATE KEY|sk-[A-Za-z0-9_-]{20,}|ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|gho_[A-Za-z0-9]{20,}|sbp_[A-Za-z0-9]{20,}|xoxb-[A-Za-z0-9-]{20,}|AKIA[A-Z0-9]{16}|POST_TOKEN|STATUS_TOKEN|CLOUDFLARE_API_TOKEN|TG_BOT_TOKEN|ANTHROPIC_API_KEY)/d')"
  if command -v perl >/dev/null 2>&1; then
    s="$(printf '%s' "$s" | perl -pe '
      BEGIN { our @stash = (); }
      s{(?<![A-Za-z0-9_-])(?:(?:SP|SM|ST|SN)[0-9A-Z]{37,40}|bc1[a-z0-9]{8,87}|(?:0x)?[a-f0-9]{64})(?![A-Za-z0-9_-])}{ push @::stash, $&; "\x01@{[$#::stash]}\x01" }ge;
      s/[A-Za-z0-9_-]{40,}/<REDACTED>/g;
      s/\x01(\d+)\x01/$::stash[$1]/g;
    ')"
  else
    # Fallback: aggressive scrub if perl is unavailable.
    s="$(printf '%s' "$s" | sed -E 's/[A-Za-z0-9_-]{40,}/<REDACTED>/g')"
  fi
  printf '%s' "$s" | head -c 8000
}

post_event() {
  local kind="$1" body="$2"
  if [ -n "$body" ]; then
    body="$(redact "$body")"
    [ -z "$body" ] && return 0
  fi
  local payload
  payload="$(jq -n --arg kind "$kind" --arg body "$body" '{kind:$kind, body: ($body|select(.!=""))}' 2>/dev/null)"
  [ -z "$payload" ] && return 0
  curl -sS -m 1 -o /dev/null \
    -H "authorization: Bearer $token" \
    -H 'content-type: application/json' \
    --data-binary "$payload" \
    "$endpoint" >/dev/null 2>&1 || true
}

# Walk the transcript newest-first, collecting text-block uuids until we hit
# last_uuid. Reverse to chronological order, then POST each one in turn.
mapfile -t new_uuids < <(
  tac "$transcript" 2>/dev/null \
    | jq -rc 'select(.type=="assistant"
                     and (.message.content | type == "array")
                     and (.message.content[]? | .type == "text"))
             | .uuid' 2>/dev/null \
    | awk -v last="$last_uuid" -v cap="$MAX_PER_FIRE" '
        last != "" && $0 == last { exit }
        { print; n++; if (n >= cap) exit }
      '
)

# Reverse to chronological order.
n=${#new_uuids[@]}
[ "$n" -eq 0 ] && exit 0
ordered=()
for ((i=n-1; i>=0; i--)); do ordered+=("${new_uuids[i]}"); done

for u in "${ordered[@]}"; do
  text="$(jq -r --arg u "$u" '
    select(.uuid==$u and .type=="assistant")
    | .message.content[]?
    | select(.type=="text")
    | .text' "$transcript" 2>/dev/null | head -c 8000)"
  [ -z "$text" ] && continue
  post_event "assistant" "$text"
  printf '%s' "$u" > "$state_file"
done

# Heartbeat on every hook fire so the page can show "live" between
# text emissions (the agent runs tools constantly, even when not talking).
post_event "heartbeat" ""

exit 0
