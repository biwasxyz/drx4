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

launch_window() {
  local name="$1"
  local first="${2:-}"   # "first" if this is the session-creator, else empty
  local spec="${SHIFTS[$name]:-}"

  if [[ -z "$spec" ]]; then
    echo "unknown shift: $name" >&2
    return 1
  fi

  local model interval skill
  IFS=':' read -r model interval skill <<< "$spec"

  if [[ "$first" == "first" ]]; then
    tmux new-session -d -s "$SESSION" -n "$name" -c "$REPO"
  else
    tmux new-window -t "$SESSION" -n "$name" -c "$REPO"
  fi

  # Skip the /loop auto-start for tracker until that skill exists
  if [[ "$name" == "tracker" ]]; then
    tmux send-keys -t "$SESSION:$name" \
      "echo 'ic-tracker-shift skill not yet built — placeholder window'" Enter
    return 0
  fi

  # Start Claude CLI
  tmux send-keys -t "$SESSION:$name" \
    "claude --dangerously-skip-permissions --model $model" Enter

  # Let Claude boot, then send the /loop command. Running sequentially is
  # fine — total launch for 3 shifts is ~30s.
  sleep "$BOOT_WAIT_SEC"
  tmux send-keys -t "$SESSION:$name" "/loop $interval /$skill" Enter
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

  launch_window lead first
  launch_window monitor
  launch_window pitcher
  if (( n >= 4 )); then
    launch_window tracker
  fi

  tmux set-option -t "$SESSION" mouse on
  tmux set-option -t "$SESSION" status-interval 2
  tmux select-window -t "$SESSION:lead"

  local windows
  windows=$(tmux list-windows -t "$SESSION" -F '#{window_index}:#{window_name}' | tr '\n' ' ')

  cat <<EOF

Swarm up.  Windows: $windows

Attach:     tmux attach -t $SESSION     (or ./swarm.sh attach)
Detach:     Ctrl-b then d
Switch:     click window name in the status bar, or Ctrl-b then <window number>
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
    local idx name
    idx=$(echo "$line" | cut -d: -f1)
    name=$(echo "$line" | cut -d: -f2)
    local cmd
    cmd=$(tmux display-message -p -t "$SESSION:$name" '#{pane_current_command}' 2>/dev/null || echo "?")
    # claude spawns node, so either is "alive"
    local alive="DEAD"
    case "$cmd" in
      claude|node|npm|npx) alive="ALIVE" ;;
    esac
    printf '  %s: %-10s  pane=%-8s  %s\n' "$idx" "$name" "$cmd" "$alive"
  done < <(tmux list-windows -t "$SESSION" -F '#{window_index}:#{window_name}')
}

cmd_repair() {
  if ! tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "no swarm running — use ./swarm.sh to launch fresh"
    return 1
  fi

  local repaired=0
  local ok=0
  for name in lead monitor pitcher; do
    # Does the window exist at all?
    if ! tmux list-windows -t "$SESSION" -F '#{window_name}' 2>/dev/null | grep -qx "$name"; then
      echo "window '$name' missing — recreating"
      launch_window "$name"
      ((repaired++))
      continue
    fi

    # Is Claude running inside it?
    local cmd
    cmd=$(tmux display-message -p -t "$SESSION:$name" '#{pane_current_command}' 2>/dev/null || echo "?")
    case "$cmd" in
      claude|node|npm|npx)
        echo "window '$name': $cmd — ALIVE, skipping"
        ((ok++))
        ;;
      *)
        echo "window '$name': $cmd — DEAD, relaunching"
        local spec="${SHIFTS[$name]}"
        local model interval skill
        IFS=':' read -r model interval skill <<< "$spec"
        # Reset the prompt cleanly first
        tmux send-keys -t "$SESSION:$name" C-c " clear" Enter
        sleep 1
        tmux send-keys -t "$SESSION:$name" "claude --dangerously-skip-permissions --model $model" Enter
        sleep "$BOOT_WAIT_SEC"
        tmux send-keys -t "$SESSION:$name" "/loop $interval /$skill" Enter
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
