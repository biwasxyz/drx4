---
name: start
description: Start the Secret Mars autonomous loop
user_invocable: true
---
# Start Agent Loop

Launches the bash wrapper that runs fresh Claude Code sessions every 30 minutes.
```bash
cd /home/mars/drx4
mkdir -p daemon/logs
nohup bash /home/mars/drx4/run-loop.sh > daemon/logs/wrapper.log 2>&1 &
echo "Loop started. PID: $!"
echo "Monitor: tail -f daemon/logs/wrapper.log"
```
