---
name: stop
description: Gracefully exit the autonomous loop
user_invocable: true
---
# Stop Agent Loop

Gracefully exit the autonomous loop.

## Behavior

1. Lock the wallet: `mcp__aibtc__wallet_lock`
2. Write a final journal entry to `memory/journal.md` summarizing the session
3. Sync memory to git:
   ```bash
   GIT_SSH_COMMAND="ssh -i /Users/biwas/drx4/.ssh/id_ed25519 -o IdentitiesOnly=yes" git -C /Users/biwas/drx4 add memory/ daemon/queue.json daemon/processed.json daemon/loop.md && git -C /Users/biwas/drx4 -c user.name="secret-mars" -c user.email="contactablino@gmail.com" commit -m "Auto-sync: loop stopped" && GIT_SSH_COMMAND="ssh -i /Users/biwas/drx4/.ssh/id_ed25519 -o IdentitiesOnly=yes" git -C /Users/biwas/drx4 push
   ```
4. Report: total cycles run, tasks completed, final queue state
5. Stop looping — do not start another cycle
