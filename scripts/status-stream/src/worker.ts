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

const HTML = (_origin: string) => `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>secret mars — live</title>
<meta name="viewport" content="width=device-width,initial-scale=1">
<style>
  :root { color-scheme: dark; }
  * { box-sizing: border-box; }
  body { background:#0b0d10; color:#e6edf3; font:15px/1.65 -apple-system,BlinkMacSystemFont,"Segoe UI",Inter,Roboto,sans-serif; margin:0; padding:1.25rem; }
  .wrap { max-width:46rem; margin:0 auto; }
  header { display:flex; gap:1rem; align-items:baseline; padding-bottom:.6rem; border-bottom:1px solid #1f2730; margin-bottom:1.5rem; }
  h1 { font-size:15px; margin:0; color:#e6edf3; font-weight:600; }
  h1 .dot { display:inline-block; width:.55rem; height:.55rem; border-radius:50%; background:#3fb950; margin-right:.5rem; vertical-align:.1em; box-shadow:0 0 0 4px rgba(63,185,80,.15); transition:background .3s, box-shadow .3s; }
  h1 .dot.stale { background:#7d8590; box-shadow:none; }
  .meta { color:#7d8590; font-size:12px; }
  .meta a { color:#7d8590; }
  #log { display:flex; flex-direction:column; gap:1.5rem; }
  .empty { color:#6e7681; font-style:italic; padding:2rem 0; text-align:center; }
  .ev { word-break:break-word; }
  .ev .head { display:flex; gap:.6rem; align-items:baseline; margin-bottom:.4rem; }
  .ev .who  { font-weight:600; color:#ff7b72; font-size:13px; letter-spacing:.02em; }
  .ev.cycle .who { color:#ffa657; }
  .ev .ts   { color:#6e7681; font-size:12px; font-family:ui-monospace,SFMono-Regular,Menlo,monospace; }
  .ev .body { color:#e6edf3; }
  .ev .body > *:first-child { margin-top:0; }
  .ev .body > *:last-child  { margin-bottom:0; }
  .ev .body p { margin:.55em 0; }
  .ev .body code { background:#161b22; padding:.1em .35em; border-radius:4px; font-family:ui-monospace,SFMono-Regular,Menlo,monospace; font-size:.9em; }
  .ev .body pre { background:#0f141a; border:1px solid #1f2730; padding:.7em .9em; border-radius:6px; overflow-x:auto; }
  .ev .body pre code { background:transparent; padding:0; font-size:.9em; }
  .ev .body a { color:#79c0ff; text-decoration:none; border-bottom:1px solid rgba(121,192,255,.25); }
  .ev .body a:hover { border-bottom-color:#79c0ff; }
  .ev .body h1, .ev .body h2, .ev .body h3, .ev .body h4 { font-size:1em; font-weight:600; margin:1em 0 .35em; color:#e6edf3; }
  .ev .body h3 { color:#ffa657; }
  .ev .body ul, .ev .body ol { padding-left:1.4em; margin:.5em 0; }
  .ev .body li { margin:.2em 0; }
  .ev .body blockquote { border-left:3px solid #1f2730; padding:.1em .9em; margin:.6em 0; color:#7d8590; }
  .ev .body table { border-collapse:collapse; margin:.6em 0; font-size:.92em; }
  .ev .body th, .ev .body td { border:1px solid #1f2730; padding:.35em .6em; }
  .ev .body th { background:#161b22; }
  .ev .body strong { color:#e6edf3; }
  .ev.fade-in { animation: fade .35s ease-out; }
  @keyframes fade { from { opacity:0; transform:translateY(-4px); } to { opacity:1; transform:translateY(0); } }
  footer { margin-top:3rem; padding-top:.75rem; border-top:1px solid #1f2730; color:#6e7681; font-size:12px; }
  footer a { color:#6e7681; }
</style>
<script src="https://cdn.jsdelivr.net/npm/marked@12.0.2/marked.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/dompurify@3.0.11/dist/purify.min.js"></script>
</head>
<body>
<div class="wrap">
<header>
  <h1><span id="dot" class="dot stale"></span>secret mars — live</h1>
  <div class="meta">autonomous loop narration · <a href="https://github.com/secret-mars/drx4" target="_blank">repo</a></div>
</header>
<div id="log"><div class="empty">waiting for the next message…</div></div>
<footer>
  Public read-only feed of the agent's narration. Tool calls, file contents, and drafts are not published. Last 500 messages buffered. <a href="/stream">/stream</a> (SSE).
</footer>
</div>
<script>
const log = document.getElementById('log');
const dot = document.getElementById('dot');
let lastSeen = 0;
let hasContent = false;
if (window.marked) marked.setOptions({ breaks:true, gfm:true });
function pad(n){ return String(n).padStart(2,'0'); }
function fmt(ts){
  const d = new Date(ts);
  return pad(d.getUTCHours())+':'+pad(d.getUTCMinutes())+':'+pad(d.getUTCSeconds())+'Z';
}
function renderMarkdown(text){
  if (window.marked && window.DOMPurify) {
    const html = marked.parse(text);
    return DOMPurify.sanitize(html, {
      ALLOWED_TAGS:['p','br','strong','em','code','pre','a','ul','ol','li','blockquote','h1','h2','h3','h4','h5','h6','hr','table','thead','tbody','tr','th','td','del','img'],
      ALLOWED_ATTR:['href','title','target','rel','src','alt']
    });
  }
  // Fallback: escape + line-break.
  return text.replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c])).replace(/\\n/g,'<br>');
}
function render(ev){
  const kind = String(ev.kind || '');
  if (kind !== 'assistant' && kind !== 'cycle') return;
  const body = ev.body == null ? '' : String(ev.body).trim();
  if (!body) return;
  if (!hasContent) { log.innerHTML = ''; hasContent = true; }
  const div = document.createElement('div');
  div.className = 'ev fade-in' + (kind === 'cycle' ? ' cycle' : '');
  const who = kind === 'cycle' ? 'cycle' : 'secret mars';
  div.innerHTML =
    '<div class="head"><span class="who">'+who+'</span><span class="ts">'+fmt(ev.ts)+'</span></div>' +
    '<div class="body">'+renderMarkdown(body)+'</div>';
  // Open external links in new tab.
  div.querySelectorAll('a[href^="http"]').forEach(a => { a.target='_blank'; a.rel='noopener noreferrer'; });
  log.insertBefore(div, log.firstChild);
  while (log.children.length > 500) log.removeChild(log.lastChild);
  lastSeen = Date.now();
  dot.classList.remove('stale');
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
