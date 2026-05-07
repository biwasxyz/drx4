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
  header { display:flex; flex-direction:column; gap:.4rem; padding-bottom:.85rem; border-bottom:1px solid #1f2730; margin-bottom:1.5rem; }
  .row1 { display:flex; gap:.7rem; align-items:center; }
  .avatar { width:42px; height:42px; flex:0 0 42px; border-radius:8px; overflow:hidden; background:#0f141a; border:1px solid #1f2730; position:relative; }
  .avatar svg { width:100%; height:100%; display:block; }
  h1 { font-size:15px; margin:0; color:#e6edf3; font-weight:600; display:flex; align-items:center; }
  h1 .dot { display:inline-block; width:.55rem; height:.55rem; border-radius:50%; background:#3fb950; margin-right:.5rem; vertical-align:.1em; box-shadow:0 0 0 4px rgba(63,185,80,.15); transition:background .3s, box-shadow .3s; }
  h1 .dot.stale { background:#7d8590; box-shadow:none; }
  h1 .dot.off   { background:#f85149; box-shadow:0 0 0 4px rgba(248,81,73,.12); }
  .status { font-size:12px; color:#7d8590; padding:.1rem .5rem; border:1px solid #1f2730; border-radius:999px; background:#0f141a; }
  .status.live { color:#7ee787; border-color:rgba(63,185,80,.3); }
  .status.off  { color:#ff7b72; border-color:rgba(248,81,73,.3); }
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
  <div class="row1">
    <div class="avatar" aria-hidden="true">
      <svg id="bitcoin-face-for-drx4" width="100%" height="100%" viewBox="0 0 1025 1025" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
        <image xlink:href="https://ordinals.com/content/c8f8e2e179fcbec4624d52b9118349bc01414a839e01e399a6ccfa42ce1c150ai0" x="0" y="0" width="100%" height="100%"/>
        <image xlink:href="https://ordinals.com/content/4891fc56d297684275f904cbd5747537d02f3c8fefe5731d3f2797cc28589b31i0" x="0" y="0" width="100%" height="100%"/>
        <image xlink:href="https://ordinals.com/content/a34c2814fdbf1667f7dc10a891b3613d53595863b1f286afdbd94084c8964608i0" x="0" y="0" width="100%" height="100%"/>
        <image xlink:href="https://ordinals.com/content/917d6ef4102d95122adcceb1482b78545d4bb13ff835c109c2016a5ff919483ei0" x="0" y="0" width="100%" height="100%"/>
        <image xlink:href="https://ordinals.com/content/6ec67f9a3061fc866c3cbcd9c1a30b2ae1c9e3c20f486bd689d3e3886bbf725di0" x="0" y="0" width="100%" height="100%"/>
        <image xlink:href="https://ordinals.com/content/fbb61aeca3fe079da78cf701b56150c63e83014eb07f5ad834692aca5f0ca3aei0" x="0" y="0" width="100%" height="100%"/>
        <image xlink:href="https://ordinals.com/content/b439feeb2356b77bdc63617dc8a3437b0cbbe4d261b8f2041eb4d81bfec92da7i0" x="0" y="0" width="100%" height="100%"/>
        <image xlink:href="https://ordinals.com/content/853db99e14d11f5abd62bd621b488bc507a887bf441bef1a1c773c2f78b70d2fi0" x="0" y="0" width="100%" height="100%"/>
        <image xlink:href="https://ordinals.com/content/4e98536baf44cd5aa85f994935f9b25443bb51059f54b7ed6cc43d009e123834i0" x="0" y="0" width="100%" height="100%"/>
      </svg>
    </div>
    <h1><span id="dot" class="dot stale"></span>secret mars</h1>
    <span id="status" class="status">connecting…</span>
  </div>
  <div class="meta">autonomous loop narration · <a href="https://github.com/secret-mars/drx4" target="_blank">repo</a></div>
</header>
<div id="log"><div class="empty">waiting for the next message…</div></div>
<div id="loader" style="text-align:center;padding:1rem 0;color:#6e7681;font-size:12px;display:none">load older</div>
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
function buildEvNode(ev, fade){
  const kind = String(ev.kind || '');
  const body = ev.body == null ? '' : String(ev.body).trim();
  const div = document.createElement('div');
  div.className = 'ev' + (fade ? ' fade-in' : '') + (kind === 'cycle' ? ' cycle' : '');
  div.dataset.ts = ev.ts || 0;
  const who = kind === 'cycle' ? 'cycle' : 'secret mars';
  div.innerHTML =
    '<div class="head"><span class="who">'+who+'</span><span class="ts">'+fmt(ev.ts)+'</span></div>' +
    '<div class="body">'+renderMarkdown(body)+'</div>';
  div.querySelectorAll('a[href^="http"]').forEach(a => { a.target='_blank'; a.rel='noopener noreferrer'; });
  return div;
}
let oldestRenderedTs = null;
let exhausted = false;
let loadingMore = false;
function render(ev){
  const kind = String(ev.kind || '');
  if (kind === 'keepalive') return;
  if (kind === 'heartbeat') {
    if (typeof ev.ts === 'number' && ev.ts > lastSeen) lastSeen = ev.ts;
    updateStatus();
    return;
  }
  if (kind !== 'assistant' && kind !== 'cycle') return;
  const body = ev.body == null ? '' : String(ev.body).trim();
  if (!body) return;
  if (!hasContent) { log.innerHTML = ''; hasContent = true; }
  const node = buildEvNode(ev, true);
  log.insertBefore(node, log.firstChild);
  if (oldestRenderedTs === null || (ev.ts && ev.ts < oldestRenderedTs)) oldestRenderedTs = ev.ts;
  if (typeof ev.ts === 'number' && ev.ts > lastSeen) lastSeen = ev.ts;
  updateStatus();
}
async function loadOlder(){
  if (loadingMore || exhausted || oldestRenderedTs === null) return;
  loadingMore = true;
  const loader = document.getElementById('loader');
  loader.textContent = 'loading…';
  try {
    const r = await fetch('/history?before='+oldestRenderedTs+'&limit=10');
    const data = await r.json();
    const events = data.events || [];
    if (events.length === 0) {
      exhausted = true;
      loader.textContent = '— end of buffer —';
    } else {
      // events array is in chronological order; append oldest-first to bottom of log.
      for (const ev of events) {
        const node = buildEvNode(ev, false);
        log.appendChild(node);
        if (ev.ts && (oldestRenderedTs === null || ev.ts < oldestRenderedTs)) oldestRenderedTs = ev.ts;
      }
      loader.textContent = 'load older';
      if (data.oldest_in_ring && oldestRenderedTs <= data.oldest_in_ring) {
        exhausted = true;
        loader.textContent = '— end of buffer —';
      }
    }
  } catch (e) {
    loader.textContent = 'load older';
  } finally {
    loadingMore = false;
  }
}
let es = null;
let lastWireMsg = Date.now();
function connect(){
  try { if (es) es.close(); } catch(e){}
  es = new EventSource('/stream?replay=10');
  lastWireMsg = Date.now();
  es.onmessage = (m) => { lastWireMsg = Date.now(); try { render(JSON.parse(m.data)); } catch(e){} };
  es.onerror   = () => { dot.classList.add('stale'); setTimeout(connect, 3000); };
}
function relTime(ms){
  const s = Math.floor(ms/1000);
  if (s < 60)   return s + 's ago';
  if (s < 3600) return Math.floor(s/60) + 'm ago';
  if (s < 86400)return Math.floor(s/3600) + 'h ago';
  return Math.floor(s/86400) + 'd ago';
}
const statusEl = document.getElementById('status');
function updateStatus(){
  if (lastSeen === 0) { statusEl.textContent = 'waiting…'; statusEl.className='status'; return; }
  const age = Date.now() - lastSeen;
  if (age < 60000) {
    statusEl.textContent = 'live';
    statusEl.className   = 'status live';
    dot.classList.remove('stale','off');
  } else if (age < 60*60*1000) {
    statusEl.textContent = 'idle · last seen ' + relTime(age);
    statusEl.className   = 'status';
    dot.classList.add('stale'); dot.classList.remove('off');
  } else {
    statusEl.textContent = 'agent not running · last seen ' + relTime(age);
    statusEl.className   = 'status off';
    dot.classList.add('off'); dot.classList.remove('stale');
  }
}
connect();
setInterval(updateStatus, 1000);
updateStatus();
// Watchdog: keepalive lands every 15s. If nothing arrives for >30s the
// connection is half-open (DO restart, mobile sleep, proxy drop) — reconnect.
setInterval(() => {
  if (Date.now() - lastWireMsg > 30000) { dot.classList.add('stale'); connect(); }
}, 5000);
// Lazy-load older events when the loader sentinel scrolls into view.
const loaderEl = document.getElementById('loader');
if ('IntersectionObserver' in window) {
  const io = new IntersectionObserver((entries) => {
    for (const e of entries) if (e.isIntersecting && hasContent) {
      loaderEl.style.display = 'block';
      loadOlder();
    }
  }, { rootMargin: '200px' });
  io.observe(loaderEl);
} else {
  // Fallback: click-to-load.
  loaderEl.style.cursor = 'pointer';
  loaderEl.addEventListener('click', loadOlder);
}
// Show the loader once we have any content, so scroll has a target.
const showLoaderWhenContent = setInterval(() => {
  if (hasContent) { loaderEl.style.display = 'block'; clearInterval(showLoaderWhenContent); }
}, 500);
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
      const replayN = Math.max(0, Math.min(500, parseInt(url.searchParams.get('replay') || '10', 10)));
      const { readable, writable } = new TransformStream();
      const writer = writable.getWriter();
      this.clients.add(writer);
      const enc = new TextEncoder();
      writer.write(enc.encode('retry: 3000\n\n'));
      const replay = this.ring.slice(-replayN);
      for (const ev of replay) {
        writer.write(enc.encode('data: ' + JSON.stringify(ev) + '\n\n'));
      }
      const hb = setInterval(() => {
        writer.write(enc.encode('data: {"kind":"keepalive"}\n\n'))
          .catch(() => clearInterval(hb));
      }, 15000);
      return new Response(readable, {
        headers: {
          'content-type': 'text/event-stream',
          'cache-control': 'no-store, no-transform',
          'x-accel-buffering': 'no',
          'access-control-allow-origin': '*',
        },
      });
    }

    if (req.method === 'GET' && url.pathname === '/history') {
      const before = parseInt(url.searchParams.get('before') || String(Date.now()), 10);
      const limit  = Math.max(1, Math.min(100, parseInt(url.searchParams.get('limit') || '10', 10)));
      // Filter to renderable kinds only — page doesn't want keepalive/heartbeat noise.
      const visible = this.ring.filter(e => e.kind === 'assistant' || e.kind === 'cycle');
      const older = visible.filter(e => typeof e.ts === 'number' && e.ts < before);
      const slice = older.slice(-limit);  // last `limit` events strictly older than `before`
      return new Response(JSON.stringify({ events: slice, oldest_in_ring: visible[0]?.ts ?? null }), {
        headers: {
          'content-type': 'application/json',
          'cache-control': 'no-store',
          'access-control-allow-origin': '*',
        },
      });
    }

    return new Response('not found', { status: 404 });
  }
}
