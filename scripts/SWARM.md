# Swarm launcher — `scripts/swarm.sh`

One-command tmux harness for running multiple Claude Code shifts side-by-side on the VPS.

## Install (one-time)

```bash
chmod +x /home/mars/drx4/scripts/swarm.sh
# Optional aliases — add to ~/.bashrc or ~/.zshrc
alias t3='/home/mars/drx4/scripts/swarm.sh 3'
alias t4='/home/mars/drx4/scripts/swarm.sh 4'
alias ta='/home/mars/drx4/scripts/swarm.sh attach'
alias ts='/home/mars/drx4/scripts/swarm.sh status'
alias tk='/home/mars/drx4/scripts/swarm.sh stop'
alias tr='/home/mars/drx4/scripts/swarm.sh repair'
```

Then reload: `source ~/.bashrc` (or `source ~/.zshrc`).

## Daily flow

```bash
# SSH in
ssh <your-vps>

# Launch 3-shift swarm (lead + monitor + pitcher). Auto-attaches.
t3

# Inside tmux: click window name in status bar to switch between shifts,
# or Ctrl-b then <number>. Detach with Ctrl-b then d — shifts keep running.

# Come back later
ssh <your-vps>
ta                 # attach to running swarm

# Kill everything
tk

# Restart clean (e.g. after skill edits)
./swarm.sh restart
```

## What each window runs

| Window | Model | `/loop` | Skill |
|---|---|---|---|
| `lead` | Opus 4.7 | 30m | `/lead-shift` |
| `monitor` | Haiku 4.5 | 10m | `/monitor-shift` |
| `pitcher` | Haiku 4.5 | 15m | `/pitcher-shift` |
| `tracker` (only with `t4`) | Haiku 4.5 | placeholder until `/ic-tracker-shift` skill exists |

Each shift boots `claude --dangerously-skip-permissions --model <X>`, waits `BOOT_WAIT_SEC` seconds (default 10), then sends its `/loop <interval> /<shift>-shift` command.

## Environment knobs

- `BOOT_WAIT_SEC=15 ./swarm.sh` — increase if Claude CLI takes longer to initialise on this VPS
- Mouse mode is always on for the swarm session (click to switch windows, scroll wheel works)

## Crash recovery

Tmux is durable — it survives your SSH disconnect, your laptop closing, or any shell-level crash. Only a VPS reboot or `tmux kill-server` ends the session. So on the normal path, when you come back:

```bash
ssh <vps>
ts         # quick health check: which shifts are ALIVE vs DEAD
ta         # attach and look around
```

If one or more shifts died (Claude CLI crashed, OOM, got killed by a signal), you'll see `DEAD` in `ts` output, and the affected window will be sitting at a bash prompt showing the error.

```bash
tr         # repair — scans each expected window, relaunches only the dead ones
```

`tr` is surgical: it skips windows where Claude is still running, so you can run it any time without disrupting healthy shifts. The dead window gets its prompt cleared and re-run from scratch (`claude --dangerously-skip-permissions --model <X>` + `/loop`).

If the whole tmux session is gone (VPS rebooted), just run `t3` from scratch. All state is in git and memory files — nothing shift-side is lost.

## Troubleshooting

**"Session 'swarm' already exists — attaching."**
Script detected a running swarm and attached instead of clobbering. Use `./swarm.sh restart` to kill + relaunch clean.

**Window opens but `/loop` never fires.**
Claude CLI boot took longer than `BOOT_WAIT_SEC`. Increase it (`BOOT_WAIT_SEC=20 t3`) or type the `/loop` command manually after attaching.

**"claude: command not found" in a window.**
`$PATH` in tmux doesn't include Claude CLI. Add `export PATH="$HOME/.node/bin:$PATH"` (or wherever it lives) to `~/.bashrc`.

**One shift's mailbox tools missing.**
That shift's session didn't load `.mcp.json` at boot. Restart that window: switch to it (Ctrl-b then window#), `/stop` the loop, `exit` Claude, then relaunch manually.

**Two shifts commit-race and one fails to push.**
Each shift `git pull`s before writing and `git push`es after. If two finish at once, the second retries. If a retry fails persistently, check that only the owning shift writes to a given file (ownership table in `.claude/skills/README.md`).
