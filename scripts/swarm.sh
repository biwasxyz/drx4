#!/bin/bash
# swarm.sh — launch / attach / stop the Secret Mars shift roster in tmux
#
# Usage
#   ./swarm.sh            launch 3 shifts (lead, monitor, pitcher) and attach
#   ./swarm.sh 4          launch 4 (add ic-tracker placeholder window)
#   ./swarm.sh attach     just attach to running swarm
#   ./swarm.sh stop       kill all swarm windows
#   ./swarm.sh restart    stop + relaunch cleanly
#   ./swarm.sh status     list windows + whether session is alive
#
# Each window runs `claude --dangerously-skip-permissions --model <X>` then
# `/loop <interval> /<shift>-shift`. Mouse mode is on so you can click
# window names in the status bar to switch. Detach with Ctrl-b then d.
# Reattach any time with `./swarm.sh attach`.

set -euo pipefail

SESSION="swarm"
REPO="/home/mars/drx4"
BOOT_WAIT_SEC="${BOOT_WAIT_SEC:-10}"    # seconds to let Claude CLI initialise before sending /loop

# Shift registry: name → model:interval:skill
declare -A SHIFTS=(
  [lead]="opus:30m:lead-shift"
  [monitor]="haiku:10m:monitor-shift"
  [pitcher]="haiku:15m:pitcher-shift"
  [tracker]="haiku:60m:ic-tracker-shift"
)

# Track pane IDs per shift name so repair/status can find them reliably.
declare -A PANE_IDS

launch_pane() {
  local name="$1"
  local first="${2:-}"
  local spec="${SHIFTS[$name]:-}"

  if [[ -z "$spec" ]]; then
    echo "unknown shift: $name" >&2
    return 1
  fi

  local model interval skill
  IFS=':' read -r model interval skill <<< "$spec"

  local pane_id
  if [[ "$first" == "first" ]]; then
    # New session, single window "shifts", first pane is the shell created by new-session
    tmux new-session -d -s "$SESSION" -n "shifts" -c "$REPO"
    pane_id=$(tmux list-panes -t "$SESSION:shifts" -F '#{pane_id}' | head -1)
  else
    # Split the window into a new pane; -P prints the new pane id, -F formats it
    pane_id=$(tmux split-window -t "$SESSION:shifts" -c "$REPO" -P -F '#{pane_id}')
  fi

  PANE_IDS[$name]="$pane_id"

  # Name the pane so the status bar / pane titles identify the shift
  tmux select-pane -t "$pane_id" -T "$name"

  # Skip the /loop auto-start for tracker until that skill exists
  if [[ "$name" == "tracker" ]]; then
    tmux send-keys -t "$pane_id" \
      "echo 'ic-tracker-shift skill not yet built — placeholder pane'" Enter
    return 0
  fi

  # Start Claude CLI
  tmux send-keys -t "$pane_id" \
    "claude --dangerously-skip-permissions --model $model" Enter

  # Let Claude boot, then send the /loop command
  sleep "$BOOT_WAIT_SEC"
  tmux send-keys -t "$pane_id" "/loop $interval /$skill" Enter
}

cmd_launch() {
  local n="${1:-3}"

  if tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "Session '$SESSION' already exists. Attaching. Use './swarm.sh restart' to restart clean."
    exec tmux attach -t "$SESSION"
  fi

  if ! command -v claude >/dev/null 2>&1; then
    echo "error: 'claude' CLI not in PATH. Install or fix your shell profile." >&2
    exit 2
  fi

  echo "Launching $n-shift swarm..."

  launch_pane lead first
  launch_pane monitor
  launch_pane pitcher
  if (( n >= 4 )); then
    launch_pane tracker
  fi

  # Tiled layout so all panes are visible at once, roughly equal size
  tmux select-layout -t "$SESSION:shifts" tiled

  # Mouse + pane borders with titles so you can see which pane is which
  tmux set-option -t "$SESSION" mouse on
  tmux set-option -t "$SESSION" status-interval 2
  tmux set-option -t "$SESSION" pane-border-status top
  tmux set-option -t "$SESSION" pane-border-format ' #P: #{pane_title} '

  # Focus the lead pane by default
  tmux select-pane -t "${PANE_IDS[lead]}"

  local panes
  panes=$(tmux list-panes -t "$SESSION:shifts" -F '#{pane_index}:#{pane_title}' | tr '\n' ' ')

  cat <<EOF

Swarm up.  Panes: $panes

Attach:     tmux attach -t $SESSION     (or ./swarm.sh attach)
Detach:     Ctrl-b then d
Switch:     click a pane (mouse on), or Ctrl-b then arrow-key / Ctrl-b q <number>
Stop all:   ./swarm.sh stop
Restart:    ./swarm.sh restart
Logs:       tail -f $REPO/daemon/outputs.log
EOF

  if [[ -t 0 ]]; then
    attach_or_switch
  fi
}

# If we're already inside tmux, switch-client into the swarm session
# (tmux refuses to nest attach by default). Otherwise, attach normally.
attach_or_switch() {
  if [[ -n "${TMUX:-}" ]]; then
    exec tmux switch-client -t "$SESSION"
  else
    exec tmux attach -t "$SESSION"
  fi
}

cmd_attach() {
  if ! tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "no swarm session running. Launch with ./swarm.sh" >&2
    exit 1
  fi
  attach_or_switch
}

cmd_stop() {
  if tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux kill-session -t "$SESSION"
    echo "swarm stopped"
  else
    echo "no swarm session running"
  fi
}

cmd_restart() {
  cmd_stop || true
  cmd_launch "${1:-3}"
}

cmd_status() {
  if ! tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "swarm: DOWN"
    return 0
  fi
  echo "swarm: UP"
  while IFS= read -r line; do
    local idx title cmd
    idx=$(echo "$line" | cut -d'|' -f1)
    title=$(echo "$line" | cut -d'|' -f2)
    cmd=$(echo "$line" | cut -d'|' -f3)
    local alive="DEAD"
    case "$cmd" in
      claude|node|npm|npx) alive="ALIVE" ;;
    esac
    printf '  pane %s (%s): cmd=%-8s  %s\n' "$idx" "$title" "$cmd" "$alive"
  done < <(tmux list-panes -t "$SESSION:shifts" -F '#{pane_index}|#{pane_title}|#{pane_current_command}')
}

cmd_repair() {
  if ! tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "no swarm running — use ./swarm.sh to launch fresh"
    return 1
  fi

  local repaired=0
  local ok=0

  for name in lead monitor pitcher; do
    # Find the pane whose title matches the shift name
    local pane_id
    pane_id=$(tmux list-panes -t "$SESSION:shifts" -F '#{pane_id} #{pane_title}' 2>/dev/null \
      | awk -v n="$name" '$2 == n { print $1; exit }')

    if [[ -z "$pane_id" ]]; then
      echo "pane '$name' missing — splitting fresh"
      launch_pane "$name"
      tmux select-layout -t "$SESSION:shifts" tiled
      ((repaired++))
      continue
    fi

    local cmd
    cmd=$(tmux display-message -p -t "$pane_id" '#{pane_current_command}' 2>/dev/null || echo "?")
    case "$cmd" in
      claude|node|npm|npx)
        echo "pane '$name': $cmd — ALIVE, skipping"
        ((ok++))
        ;;
      *)
        echo "pane '$name': $cmd — DEAD, relaunching"
        local spec="${SHIFTS[$name]}"
        local model interval skill
        IFS=':' read -r model interval skill <<< "$spec"
        tmux send-keys -t "$pane_id" C-c " clear" Enter
        sleep 1
        tmux send-keys -t "$pane_id" "claude --dangerously-skip-permissions --model $model" Enter
        sleep "$BOOT_WAIT_SEC"
        tmux send-keys -t "$pane_id" "/loop $interval /$skill" Enter
        ((repaired++))
        ;;
    esac
  done

  echo ""
  echo "repair done: $repaired relaunched, $ok already alive"
}

case "${1:-}" in
  ""|3|4|5)
    cmd_launch "${1:-3}"
    ;;
  attach|a)
    cmd_attach
    ;;
  stop|kill)
    cmd_stop
    ;;
  restart)
    cmd_restart "${2:-3}"
    ;;
  status|s)
    cmd_status
    ;;
  repair|fix|r)
    cmd_repair
    ;;
  *)
    echo "usage: $0 [3|4|attach|stop|restart|status|repair]" >&2
    exit 2
    ;;
esac
