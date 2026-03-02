#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTBOX_FILE="$ROOT/daemon/outbox.json"
OUTBOX_ARCHIVE_FILE="$ROOT/daemon/outbox-archive.json"
PROCESSED_FILE="$ROOT/daemon/processed.json"

# Thresholds from daemon/loop.md
OUTBOX_ARCHIVE_THRESHOLD=50
OUTBOX_ARCHIVE_DAYS=7
PROCESSED_TRIM_THRESHOLD=200
PROCESSED_KEEP_DAYS=30

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

if [ ! -f "$OUTBOX_FILE" ] || [ ! -f "$PROCESSED_FILE" ]; then
  echo "Missing daemon state files; nothing to archive."
  exit 0
fi

if [ ! -f "$OUTBOX_ARCHIVE_FILE" ]; then
  echo '{"archived":[]}' > "$OUTBOX_ARCHIVE_FILE"
fi

if ! jq -e '.archived | type == "array"' "$OUTBOX_ARCHIVE_FILE" >/dev/null 2>&1; then
  echo '{"archived":[]}' > "$OUTBOX_ARCHIVE_FILE"
fi

sent_len="$(jq '.sent | length' "$OUTBOX_FILE" 2>/dev/null || echo 0)"
cutoff_epoch="$(($(date -u +%s) - OUTBOX_ARCHIVE_DAYS * 24 * 60 * 60))"

archived_count=0
if [ "$sent_len" -gt "$OUTBOX_ARCHIVE_THRESHOLD" ]; then
  jq --argjson cutoff "$cutoff_epoch" '
    .sent as $sent
    | {
        archive: ($sent | map(
          select(
            (
              (.sent_at // "")
              | sub("\\.[0-9]+Z$"; "Z")
              | fromdateiso8601?
            ) as $ts
            | ($ts != null and $ts < $cutoff)
          )
        )),
        keep: ($sent | map(
          select(
            (
              (.sent_at // "")
              | sub("\\.[0-9]+Z$"; "Z")
              | fromdateiso8601?
            ) as $ts
            | ($ts == null or $ts >= $cutoff)
          )
        ))
      }
  ' "$OUTBOX_FILE" > "$TMP_DIR/outbox_split.json"

  archived_count="$(jq '.archive | length' "$TMP_DIR/outbox_split.json")"
  if [ "$archived_count" -gt 0 ]; then
    jq --slurpfile split "$TMP_DIR/outbox_split.json" '
      .archived += $split[0].archive
      | .archived |= unique_by(.message_id // .id // .sent_at // .content)
    ' "$OUTBOX_ARCHIVE_FILE" > "$TMP_DIR/outbox_archive_new.json"
    mv "$TMP_DIR/outbox_archive_new.json" "$OUTBOX_ARCHIVE_FILE"

    jq --slurpfile split "$TMP_DIR/outbox_split.json" '
      .sent = $split[0].keep
    ' "$OUTBOX_FILE" > "$TMP_DIR/outbox_new.json"
    mv "$TMP_DIR/outbox_new.json" "$OUTBOX_FILE"
  fi
fi

processed_len="$(jq 'length' "$PROCESSED_FILE" 2>/dev/null || echo 0)"
processed_trimmed=0
if [ "$processed_len" -gt "$PROCESSED_TRIM_THRESHOLD" ]; then
  cutoff_ms="$(($(date -u +%s) * 1000 - PROCESSED_KEEP_DAYS * 24 * 60 * 60 * 1000))"
  jq --argjson cutoff_ms "$cutoff_ms" '
    map(
      select(
        if test("^msg_[0-9]+_") then
          ((capture("^msg_(?<ts>[0-9]+)_").ts | tonumber) >= $cutoff_ms)
        else
          true
        end
      )
    )
  ' "$PROCESSED_FILE" > "$TMP_DIR/processed_filtered.json"

  filtered_len="$(jq 'length' "$TMP_DIR/processed_filtered.json")"
  if [ "$filtered_len" -gt "$PROCESSED_TRIM_THRESHOLD" ]; then
    jq '.[-200:]' "$TMP_DIR/processed_filtered.json" > "$TMP_DIR/processed_new.json"
  else
    cp "$TMP_DIR/processed_filtered.json" "$TMP_DIR/processed_new.json"
  fi

  processed_trimmed="$((processed_len - $(jq 'length' "$TMP_DIR/processed_new.json")))"
  mv "$TMP_DIR/processed_new.json" "$PROCESSED_FILE"
fi

echo "archive_maintenance: outbox_archived=$archived_count processed_trimmed=$processed_trimmed"
