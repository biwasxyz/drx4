// drx4-status — public live tail of the Secret Mars autonomous loop.
//
// POST /event   (auth: Authorization: Bearer $POST_TOKEN) — agent hooks call this
// GET  /stream  (open) — Server-Sent Events: replays last N events, then live tail
// GET  /        (open) — HTML viewer

interface Env {
  STREAM: DurableObjectNamespace;
  POST_TOKEN: string;
  RING_SIZE: string;
}

const HTML = (origin: string) => `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>secret mars — live</title>
<meta name="viewport" content="width=device-width,initial-scale=1">
<style>
  :root { color-scheme: dark; }
  body { background:#0b0d10; color:#cfd6dd; font:14px/1.5 ui-monospace,SFMono-Regular,Menlo,monospace; margin:0; padding:1rem; }
  header { display:flex; gap:1rem; align-items:baseline; padding-bottom:.5rem; border-bottom:1px solid #1f2730; margin-bottom:.75rem; }
  h1 { font-size:14px; margin:0; color:#e6edf3; }
  h1 .dot { display:inline-block; width:.6rem; height:.6rem; border-radius:50%; background:#3fb950; margin-right:.4rem; vertical-align:.05em; }
  h1 .dot.stale { background:#7d8590; }
  .meta { color:#7d8590; font-size:12px; }
  .meta a { color:#7d8590; }
  #log { white-space:pre-wrap; word-break:break-word; }
  .ev { padding:.35rem 0; border-top:1px solid #161b22; }
  .ev:first-child { border-top:none; }
  .ts { color:#6e7681; }
  .kind { display:inline-block; min-width:6rem; font-weight:600; }
  .kind-tool_pre   { color:#79c0ff; }
  .kind-tool_post  { color:#a5d6ff; }
  .kind-prompt     { color:#d2a8ff; }
  .kind-stop       { color:#7ee787; }
  .kind-cycle      { color:#ffa657; }
  .kind-note       { color:#7d8590; }
  .body { color:#cfd6dd; }
  .truncated { color:#6e7681; font-style:italic; }
  footer { margin-top:1rem; padding-top:.5rem; border-top:1px solid #1f2730; color:#6e7681; font-size:12px; }
</style>
</head>
<body>
<header>
  <h1><span id="dot" class="dot stale"></span>secret mars — live tool stream</h1>
  <div class="meta">drx4 autonomous loop · <a href="https://github.com/secret-mars/drx4" target="_blank">repo</a></div>
</header>
<div id="log"></div>
<footer>
  Public read-only feed. Event source: <code>/stream</code> (SSE). Events redacted for secrets + draft text. Last 500 events buffered.
</footer>
<script>
const log = document.getElementById('log');
const dot = document.getElementById('dot');
let lastSeen = 0;
function pad(n){ return String(n).padStart(2,'0'); }
function fmt(ts){
  const d = new Date(ts);
  return pad(d.getUTCHours())+':'+pad(d.getUTCMinutes())+':'+pad(d.getUTCSeconds())+'Z';
}
function render(ev){
  const div = document.createElement('div');
  div.className = 'ev';
  const kind = (ev.kind || 'note').replace(/[^a-z_]/gi,'');
  const body = ev.body == null ? '' : String(ev.body);
  const tool = ev.tool ? ' '+ev.tool : '';
  div.innerHTML =
    '<span class="ts">'+fmt(ev.ts)+'</span> ' +
    '<span class="kind kind-'+kind+'">'+kind+tool+'</span>' +
    (body ? '<div class="body">'+escapeHtml(body)+'</div>' : '');
  log.insertBefore(div, log.firstChild);
  while (log.children.length > 500) log.removeChild(log.lastChild);
  lastSeen = Date.now();
  dot.classList.remove('stale');
}
function escapeHtml(s){
  return s.replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
}
function connect(){
  const es = new EventSource('/stream');
  es.onmessage = (m) => { try { render(JSON.parse(m.data)); } catch(e){} };
  es.onerror = () => { dot.classList.add('stale'); setTimeout(()=>{ es.close(); connect(); }, 3000); };
}
connect();
setInterval(()=>{ if (Date.now()-lastSeen > 60000) dot.classList.add('stale'); }, 5000);
</script>
</body>
</html>`;

export default {
  async fetch(req: Request, env: Env): Promise<Response> {
    const url = new URL(req.url);
    if (url.pathname === '/' || url.pathname === '/index.html') {
      return new Response(HTML(url.origin), {
        headers: { 'content-type': 'text/html; charset=utf-8', 'cache-control': 'no-store' },
      });
    }
    // Single global stream room — one DO instance for the whole feed.
    const id = env.STREAM.idFromName('global');
    const stub = env.STREAM.get(id);
    return stub.fetch(req);
  },
};

export class EventStream {
  state: DurableObjectState;
  env: Env;
  ring: any[] = [];
  ringMax: number;
  clients: Set<WritableStreamDefaultWriter> = new Set();

  constructor(state: DurableObjectState, env: Env) {
    this.state = state;
    this.env = env;
    this.ringMax = parseInt(env.RING_SIZE || '500', 10);
    this.state.blockConcurrencyWhile(async () => {
      this.ring = (await this.state.storage.get<any[]>('ring')) || [];
    });
  }

  async fetch(req: Request): Promise<Response> {
    const url = new URL(req.url);

    if (req.method === 'POST' && url.pathname === '/event') {
      const auth = req.headers.get('authorization') || '';
      const expected = 'Bearer ' + this.env.POST_TOKEN;
      if (!this.env.POST_TOKEN || auth !== expected) {
        return new Response('unauthorized', { status: 401 });
      }
      let payload: any;
      try { payload = await req.json(); } catch { return new Response('bad json', { status: 400 }); }
      const ev = {
        ts: Date.now(),
        kind: String(payload.kind || 'note').slice(0, 32),
        tool: payload.tool ? String(payload.tool).slice(0, 64) : undefined,
        body: payload.body ? String(payload.body).slice(0, 8000) : undefined,
      };
      this.ring.push(ev);
      while (this.ring.length > this.ringMax) this.ring.shift();
      // Persist ring async (don't block POST on storage roundtrip).
      this.state.storage.put('ring', this.ring).catch(() => {});
      const line = 'data: ' + JSON.stringify(ev) + '\n\n';
      const enc = new TextEncoder().encode(line);
      // Fan-out: fire-and-forget per writer, with a per-write timeout so a
      // dead/half-open SSE connection can't wedge the whole DO.
      const writeWithTimeout = (w: WritableStreamDefaultWriter, ms: number) => {
        return Promise.race([
          w.write(enc),
          new Promise<void>((_, reject) => setTimeout(() => reject(new Error('timeout')), ms)),
        ]);
      };
      const dead: WritableStreamDefaultWriter[] = [];
      await Promise.allSettled(
        [...this.clients].map(async (w) => {
          try { await writeWithTimeout(w, 1500); }
          catch { dead.push(w); }
        })
      );
      for (const w of dead) {
        this.clients.delete(w);
        try { await w.close(); } catch {}
      }
      return new Response('ok');
    }

    if (req.method === 'GET' && url.pathname === '/stream') {
      const { readable, writable } = new TransformStream();
      const writer = writable.getWriter();
      this.clients.add(writer);
      const enc = new TextEncoder();
      // replay
      writer.write(enc.encode('retry: 3000\n\n'));
      for (const ev of this.ring) {
        writer.write(enc.encode('data: ' + JSON.stringify(ev) + '\n\n'));
      }
      // periodic heartbeat
      const hb = setInterval(() => {
        writer.write(enc.encode(':hb\n\n')).catch(() => clearInterval(hb));
      }, 25000);
      return new Response(readable, {
        headers: {
          'content-type': 'text/event-stream',
          'cache-control': 'no-store, no-transform',
          'x-accel-buffering': 'no',
        },
      });
    }

    return new Response('not found', { status: 404 });
  }
}
