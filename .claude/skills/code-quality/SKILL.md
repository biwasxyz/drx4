---
name: code-quality
description: Code quality reference for our stack. Evergreen notes on how we write, test, and ship code across CF Workers, Hono, Next.js, D1. Use before writing or reviewing code.
user_invocable: true
---
# Code Quality Standards — Secret Mars

Use this before writing or reviewing ANY code. These rules are non-negotiable.

## Core Principles

1. **Show errors, not wrong data.** If something fails, surface the error. Never return fallback data pretending success.
2. **Read docs, then code.** Fetch and read platform docs before writing. Don't guess APIs.
3. **DRY.** 3+ similar blocks = extract a function. Same logic in multiple files = shared module.
4. **Test before shipping.** `wrangler deploy --dry-run` (CF Workers), `next build` (Next.js), `tsc --noEmit` (TS).

## Anti-Patterns (NEVER do these)

```ts
// BAD: catch-and-swallow
try { const data = await fetch(...); } catch { return []; }

// BAD: nullify errors
} catch { return null; }

// BAD: hide error behind generic message
} catch (e) { return json({ error: 'Internal server error' }, 500); }

// BAD: pretend success on failure
return result.data ?? [];  // when result.ok might be false
```

## Correct Patterns

```ts
// GOOD: check response, throw on failure
const res = await fetch(url);
if (!res.ok) throw new Error(`${res.status} ${await res.text()}`);

// GOOD: check result.ok before returning data
if (!result.ok) throw new Error(result.error ?? "Request failed");
return result.data ?? [];

// GOOD: surface error message in catch
} catch (e) {
  return json({ error: e instanceof Error ? e.message : String(e) }, 500);
}

// GOOD: distinguish "not found" from "error"
if (res.status === 404) return null;  // genuinely not found
if (!res.ok) throw new Error(`API error: ${res.status}`);  // real error

// GOOD: specific recovery (retry, circuit breaker)
} catch (e) {
  if (retries < 3) return fetchWithRetry(url, retries + 1);
  throw e;  // exhausted retries, let it propagate
}
```

## Platform Notes

### Cloudflare Workers
- Env via `env` binding parameter, NOT `process.env`
- Use `waitUntil()` for background work after response
- D1: always `.bind()` parameters, never string-concatenate SQL
- D1 `.run()` returns `{ meta, success }` — check `success`
- Workers have 128MB memory, 30s CPU time (paid plan)
- No Node.js fs, path, child_process — use Workers APIs

### Hono (on CF Workers)
- Use `c.json()`, `c.text()` response helpers
- Use middleware for cross-cutting: `app.use('/api/*', cors(), rateLimit())`
- Access bindings via `c.env.BINDING_NAME`
- Error handling: `app.onError((err, c) => c.json({ error: err.message }, 500))`

### Durable Objects
- Single-instance state — use for coordination, not compute
- `DOResult<T>` pattern: `{ ok: boolean, data?: T, error?: string }`
- Always check `result.ok` before accessing `result.data`
- Alarm-based scheduling: `this.ctx.storage.setAlarm(Date.now() + ms)`

### D1 SQL
- Always parameterized: `.prepare("SELECT * FROM t WHERE id = ?").bind(id)`
- Atomic operations: `INSERT ... WHERE NOT EXISTS` for race prevention
- `.first<T>()` returns T | null — null means not found, not error
- `.all<T>()` returns `{ results: T[] }` — empty results is not an error
- Batch: `db.batch([stmt1, stmt2])` for atomic multi-statement

### Next.js App Router
- Server components by default — add `'use client'` only when needed
- Route handlers: `export async function GET(req: Request) {}`
- Return `NextResponse.json({ error }, { status: 500 })` on errors, not null
- Use `React.cache()` for request-level deduplication in server components

## Review Checklist

Before shipping any PR, verify:
- [ ] Every `catch` block either re-throws, returns a specific error message, or has a documented recovery strategy
- [ ] No `?? []` or `?? null` without checking `.ok` / `.status` first
- [ ] No `return null` in catch blocks (unless genuinely handling "not found")
- [ ] All fetch calls check `res.ok` or `res.status`
- [ ] D1 queries use `.bind()` (no string concatenation)
- [ ] `wrangler deploy --dry-run` or equivalent passes
- [ ] No duplicate code blocks that should be extracted
