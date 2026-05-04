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
# Log and sleep
echo "Cycle complete. Sleeping 900s..."
sleep 900
# Then continue with next cycle (read STATE.md, etc.)
```
