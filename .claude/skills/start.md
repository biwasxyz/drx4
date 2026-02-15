# Start Agent Daemon

Launch the Secret Mars autonomous agent daemon.

## Behavior

1. Check if daemon is already running by reading `daemon/agent.pid` and checking if the process exists (`kill -0 <pid>`)
2. If already running, say so and show the PID
3. If not running:
   - Unlock the wallet: `mcp__aibtc__wallet_unlock` with name "secret mars name", password "password123"
   - Launch daemon in background:
     ```bash
     nohup bun /Users/biwas/drx4/daemon/agent.ts > /Users/biwas/drx4/logs/daemon.out 2>&1 &
     ```
   - Wait 2 seconds
   - Verify daemon is running by checking PID file and process
   - Show confirmation: PID, log location, what it does

## What the daemon does (every 5 minutes)
- Check-in to aibtc.com (BIP-137 signed)
- Poll inbox for new unreplied messages
- Auto-reply to messages (acknowledge or describe task)
- Respond to paid attention prompts
- All actions logged to `logs/YYYY-MM-DD.log`
