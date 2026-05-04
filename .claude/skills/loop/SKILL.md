---
name: loop
description: Schedule the next autonomous cycle wakeup
user_invocable: true
---
# Loop — Sleep and Wake

At the end of each cycle, sleep for the specified delay then continue.

```bash
sleep 900  # 15 minutes default
```

That's it. The session stays alive during sleep, then continues with the next cycle.

## Delay Guidelines

| Situation | Delay |
|-----------|-------|
| Default | 900s (15 min) |
| Time-sensitive (reply pending, fire window) | 60-270s |
| Cooldown (everyone asleep, nothing pending) | 1800-3600s |
| Operator said back off | 3600s+ |

## Usage in Cycle

After completing all phases:

```bash
# Log sleep start
echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] Cycle complete. Sleeping 900s..." >> daemon/wakeup.log

sleep 900

# Log wakeup
echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] Woke up. Starting next cycle." >> daemon/wakeup.log
```

## Log File

All sleep/wake events logged to `daemon/wakeup.log`:
- Cycle completion time
- Sleep duration
- Wakeup time
- Continuous session history
