#!/usr/bin/env bash
# Apr 30 PT fire queue — 3 v3 pitches (presidio / Br0ski / PipeNetwork)
# Pre-flighted cycle 2034p0; lint 0/0; canonical pipeline updated
set -euo pipefail

REPO_DIR="/home/mars/drx4"
DRAFTS="$REPO_DIR/daemon/drafts/2026-04-30"
GIT_SSH_COMMAND="ssh -i $REPO_DIR/.ssh/id_ed25519 -o IdentitiesOnly=yes"
export GIT_SSH_COMMAND

fire_one() {
  local prospect_id="$1" target_repo="$2" draft_file="$3"
  local title body_file body
  title=$(grep '^\*\*Title:' "$draft_file" | sed 's/\*\*Title:\*\* //')
  # Body = everything after **Body:** line, single blob
  body=$(awk '/^\*\*Body:\*\*/{flag=1;sub(/^\*\*Body:\*\* /,"",$0); print; next} flag{print}' "$draft_file")

  echo "=== $prospect_id → $target_repo ==="
  echo "Title: $title"
  echo "Body length: $(echo "$body" | wc -c) chars"

  local issue_url
  issue_url=$(gh issue create -R "$target_repo" --title "$title" --body "$body" 2>&1 | tail -1)
  echo "Result: $issue_url"
  echo ""

  # Update pipeline last_touch + first_touch + touches
  local now
  now=$(date -u +%FT%TZ)
  jq --arg id "$prospect_id" --arg now "$now" --arg url "$issue_url" '
    .prospects |= map(
      if .id == $id then
        . + {
          stage: "pitched",
          first_touch_at: $now,
          last_touch_at: $now,
          touches: (.touches + [{
            timestamp: $now,
            channel: "github-issue",
            direction: "outbound",
            url: $url,
            summary: "Apr 30 PT v3 pitch fire (cycle 2034p0 pre-flight). 3k sats / 7d, measurement in progress."
          }])
        } |
        .contact.issue_url = $url
      else . end
    )
  ' "$REPO_DIR/daemon/sales-pipeline.json" > /tmp/pipeline-fire.json

  if jq empty /tmp/pipeline-fire.json && [ "$(jq '.prospects | length' /tmp/pipeline-fire.json)" = "94" ]; then
    mv /tmp/pipeline-fire.json "$REPO_DIR/daemon/sales-pipeline.json"
    echo "Pipeline updated for $prospect_id"
  else
    echo "Pipeline update FAILED for $prospect_id — manual recovery needed"
    exit 1
  fi
}

fire_one "p094" "presidio-v/presidio-hardened-x402" "$DRAFTS/p094-presidio.md"
fire_one "p095" "Br0ski777/x402-agent-tools" "$DRAFTS/p095-x402-agent-tools.md"
fire_one "p096" "PipeNetwork/lib-storage" "$DRAFTS/p096-pipenetwork.md"

echo ""
echo "=== Apr 30 PT fire complete ==="
