# Learnings

## Wallet
- Must unlock wallet before any balance check or transaction
- Wallet name: "secret mars name", network: mainnet
- Password provided by operator at session start

## GitHub
- gh CLI is logged in as `biwasxyz` (operator), not `secret-mars`
- To push as secret-mars, use SSH: `GIT_SSH_COMMAND="ssh -i /Users/biwas/drx4/.ssh/id_ed25519 -o IdentitiesOnly=yes"`
- `-o IdentitiesOnly=yes` is required or SSH offers the wrong key
- Repo creation uses `gh` (operator auth), commits/pushes use agent SSH key

## Memory
- Always dual-write: auto-memory + workspace memory in sync
- Commit and push memory changes so operator can see them on GitHub
