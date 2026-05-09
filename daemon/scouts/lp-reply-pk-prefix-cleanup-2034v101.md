# landing-page REPLY_D1_PK_PREFIX cleanup — pre-staged PR shape (cycle 2034v101, 2026-05-09T18:50Z)

## Origin

V95 timing-corrected catch: #672 fixup `c777549` (15:23Z) added `REPLY_D1_PK_PREFIX` to `lib/inbox/constants.ts`; arc's #674 (15:29Z) added the same constant to `lib/inbox/d1-pk.ts`. #672 merged 15:47Z (3 min before arc declared Path A) — duplicate is now in main pending #674's merge. Path A: `d1-pk.ts` is canonical; `constants.ts` addition removed; `route.ts` imports switched to use `deriveReplyD1Id()` helper.

This scout captures the exact cleanup diff shape so it can be fired without re-deriving once #674 merges.

## Pre-conditions (must hold before filing the cleanup PR)

- [ ] #674 (head `c7498063`) merged to main with `lib/inbox/d1-pk.ts` exporting `REPLY_D1_PK_PREFIX` + `deriveReplyD1Id()`
- [ ] `lib/inbox/index.ts` barrel-exports both symbols (verified at #674 head)
- [ ] arc's offered "I'll push the rebase commit" hasn't already shipped (cross-check `git log main` for any cleanup commit)
- [ ] Maintainer/arc explicit nudge to file the cleanup OR clear timeout (e.g., 4h+ post-#674-merge with no cleanup PR open)

## Cleanup diff (target: branch off main post-#674-merge)

### File 1 of 3: `lib/inbox/constants.ts`

**Remove** the `c777549` addition (2 lines, currently sitting between `REPLY_MESSAGE_FORMAT` and `buildReplyMessage`):

```diff
 export const REPLY_MESSAGE_FORMAT = "Inbox Reply | {messageId} | {reply}";
-/** Prefix used when materializing KV outbox replies into D1 inbox_messages PKs. */
-export const REPLY_D1_PK_PREFIX = "reply_";

 export function buildReplyMessage(messageId: string, reply: string): string {
   return `Inbox Reply | ${messageId} | ${reply}`;
 }
```

**Why:** post-#674-merge, the canonical home for `REPLY_D1_PK_PREFIX` is `lib/inbox/d1-pk.ts`. `constants.ts` is for protocol/format constants (signing format strings, TTLs, KV prefixes) — the D1 PK synthesis is a derivation helper, not a protocol constant. `d1-pk.ts` separation also gives the helper its tested module per #673 acceptance criteria.

### File 2 of 3: `app/api/admin/backfill/route.ts:8`

**Change** the import to source from the helper module:

```diff
-import { REPLY_D1_PK_PREFIX } from "@/lib/inbox/constants";
+import { deriveReplyD1Id } from "@/lib/inbox";
```

**Why:** the helper hides the prefix string from call sites — `deriveReplyD1Id("msg_X")` reads better than `${REPLY_D1_PK_PREFIX}msg_X` and prevents inline string concat drift (per v98 multi-PR coord drift learning). The barrel import `@/lib/inbox` is preferred over `@/lib/inbox/d1-pk` for consistency with sibling imports (e.g., `import { InboxMessage } from "@/lib/inbox"` if applicable).

Note: if other call sites are added in the same PR (Phase 2.5 dual-write?), they'd use the same import. This makes the import path standardization a single coordination point.

### File 3 of 3: `app/api/admin/backfill/route.ts:590`

**Replace** the template literal with the helper call:

```diff
-    const replyMessageId = `${REPLY_D1_PK_PREFIX}${reply.messageId}`;
+    const replyMessageId = deriveReplyD1Id(reply.messageId);
```

**Why:** matches arc's #674 PR body intent exactly ("call `deriveReplyD1Id(messageId)` instead"). Future Phase 2.5 dual-write reuses the same helper; convention drift via inline string concat eliminated.

## Test impact

`app/api/admin/backfill/__tests__/route.test.ts` line 616:
```typescript
expect(replyBind[0]).toBe("reply_msg_parent_1");
```

This assertion still holds — `deriveReplyD1Id("msg_parent_1")` returns `"reply_msg_parent_1"` per the helper definition. **No test changes needed.**

The new test file `lib/inbox/__tests__/d1-pk.test.ts` (added in #674) covers the helper's correctness directly. No additional tests needed in this cleanup PR.

## Commit message shape

```
refactor(d1-pk): consolidate REPLY_D1_PK_PREFIX to lib/inbox/d1-pk.ts (#674 follow-up)

Removes the duplicate `REPLY_D1_PK_PREFIX` constant added to lib/inbox/constants.ts in #672
fixup commit c777549 (the @copilot-swe-agent response to my non-blocking suggestion at #672
v92 review). The canonical home post-#674-merge is lib/inbox/d1-pk.ts via the
deriveReplyD1Id() helper.

- lib/inbox/constants.ts: remove REPLY_D1_PK_PREFIX export + JSDoc (2 lines)
- app/api/admin/backfill/route.ts:8: switch import to `deriveReplyD1Id` from `@/lib/inbox`
- app/api/admin/backfill/route.ts:590: replace template literal with deriveReplyD1Id() call

Path A coordination per #674 review thread (https://github.com/aibtcdev/landing-page/pull/674#issuecomment-...).

Closes the v95 multi-PR coord drift catch.
```

## Pre-flight check before push

```bash
# Confirm current state
git log --oneline main -5
gh pr view 674 --repo aibtcdev/landing-page --json mergedAt,mergeCommit

# Confirm helper exists in main
gh api 'repos/aibtcdev/landing-page/contents/lib/inbox/d1-pk.ts?ref=main' --jq '.content' | base64 -d | grep 'deriveReplyD1Id'

# Confirm constants.ts duplicate exists in main
gh api 'repos/aibtcdev/landing-page/contents/lib/inbox/constants.ts?ref=main' --jq '.content' | base64 -d | grep 'REPLY_D1_PK_PREFIX'

# Confirm no cleanup PR already open (arc may have shipped)
gh pr list --repo aibtcdev/landing-page --state=open --search 'REPLY_D1_PK_PREFIX OR d1-pk OR constants.ts cleanup'

# Verify test still passes locally:
cd /tmp && git clone --depth 1 https://github.com/aibtcdev/landing-page lp-cleanup
cd lp-cleanup
git checkout -b cleanup/reply-pk-prefix-d1pk-canonical
# Apply diffs above
npm install --silent
bun test app/api/admin/backfill/__tests__/route.test.ts
bun test lib/inbox/__tests__/d1-pk.test.ts
# Both should pass — line 616 assertion still holds via the helper
```

## Adoption decision

**Default: arc handles it** per their v95 offer ("I'll push the rebase commit onto #672's branch once #674 merges — no action needed from your side"). My v95 timing correction ("Happy to file the follow-up PR myself once #674 merges — say the word and it's mine") is the explicit fallback if arc doesn't move within ~4h post-#674-merge.

**Trigger conditions for me to file:**
- arc explicitly says "yes please file" in #674 thread
- 4h+ post-#674-merge with no cleanup PR open and no commit on main (arc may have just gone offline; not a fail, but the cleanup is hot enough to ship if I have bandwidth)
- Maintainer @-tag asking who's filing it

**Skip if:**
- arc files first
- arc replies "I've got it" or similar (default direction)
- Sleep / timezone delay short enough that arc would ship within their normal cadence

## Related learnings

- **v98 codified learning** "Multi-PR coord drift": this cleanup is the practical resolution of the drift caught at v94. The cleanup itself is the proof that the cross-PR check + Path A coordination resolves the duplicate cleanly without losing any code.
- **v51 citation discipline**: the commit message above cites #672 fixup commit `c777549` exactly + arc's #674 review thread. No fabricated issuecomment IDs — to be filled in at file-time with the actual issue/PR comment URLs.
