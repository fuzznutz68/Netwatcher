// NetWatch - Domain Intelligence v3 (public, no auth required)
// Enhanced: crt.sh + brute-force + CDN detection + cross-domain discovery + deep PTR

// @ts-nocheck

// ══ NetWatch Phase 1 inline block (generated from security/phase1/nwhttp.mjs)
// Do not edit here; edit the module and re-run apply_patch.py.
// NetWatch — Phase 1 HTTP boundary hardening (pure logic, zero runtime dependencies).
//
// Canonical source for the inline block copied into each deployed function.
// Base44 deploys single files, so the functions cannot import this module; the
// patched function sources inline this file verbatim (minus `export`) and
// tests/nwhttp.test.mjs asserts the inlined text still matches byte for byte.
//
// Scope of Phase 1 (authorized):
//   - explicit, restrictive CORS (no wildcard, no origin reflection)
//   - JSON content-type enforcement for body-carrying requests
//   - strictly capped response reads (enforced while reading, reader cancelled)
//   - a total wall-clock deadline with cancellation of outstanding work
//   - a guarded GET whose redirects are re-validated per hop
//
// Out of scope for Phase 1 (explicitly excluded by the authorization):
//   deep=true gating, token buckets, scan tokens, authentication, caching.

// ── CORS ────────────────────────────────────────────────────────────────────
// There is no browser client. Native Android and Windows callers send no
// Origin header, and CORS never applies to them. The default allowlist is
// therefore empty: no Access-Control-Allow-Origin is emitted at all.
function nwAllowedOriginsFromEnv(getenv) {
  try {
    const raw = typeof getenv === 'function' ? getenv('NW_ALLOWED_ORIGINS') : '';
    return new Set(
      String(raw || '')
        .split(',')
        .map((s) => s.trim().replace(/\/+$/, ''))
        .filter((s) => s.length > 0),
    );
  } catch (_) {
    return new Set();
  }
}

function nwOriginAllowed(origin, allowedOrigins) {
  if (!origin || !allowedOrigins) return false;
  const o = String(origin).trim().replace(/\/+$/, '');
  if (!o) return false;
  return allowedOrigins.has(o);
}

// Explicit headers on every response. `Vary: Origin` keeps intermediaries from
// serving a cached response to the wrong origin once an allowlist is set.
function nwCorsHeaders(origin, allowedOrigins, methods) {
  const h = {
    Vary: 'Origin',
    'Access-Control-Allow-Methods': methods,
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Max-Age': '600',
  };
  if (nwOriginAllowed(origin, allowedOrigins)) {
    h['Access-Control-Allow-Origin'] = String(origin).trim().replace(/\/+$/, '');
  }
  return h;
}

function nwPreflight(origin, allowedOrigins, methods) {
  return {
    status: 204,
    headers: nwCorsHeaders(origin, allowedOrigins, methods),
    body: null,
  };
}

// ── Method and content-type gates ───────────────────────────────────────────
// Body-carrying requests must declare application/json. Parameters such as
// `; charset=utf-8` are accepted because .NET's StringContent sends them.
// GET/HEAD/OPTIONS carry no body and are exempt so the existing
// `GET /ipWhois?ip=...` path keeps working untouched.
function nwIsJsonContentType(value) {
  if (value === null || value === undefined) return false;
  const base = String(value).split(';')[0].trim().toLowerCase();
  return base === 'application/json';
}

function nwRequestCarriesBody(method) {
  const m = String(method || '').toUpperCase();
  return m !== 'GET' && m !== 'HEAD' && m !== 'OPTIONS';
}

function nwContentTypeAccepted(method, contentType) {
  if (!nwRequestCarriesBody(method)) return true;
  return nwIsJsonContentType(contentType);
}

function nwMethodAllowed(method, methods) {
  const m = String(method || '').toUpperCase();
  return String(methods || '')
    .split(',')
    .map((s) => s.trim().toUpperCase())
    .filter(Boolean)
    .includes(m);
}

// ── Deadline ────────────────────────────────────────────────────────────────
// One timer per invocation. Aborting the signal cancels every in-flight fetch
// that was given it (DNS, crt.sh, page fetch). `close()` must run in `finally`
// so a completed invocation never leaves a live timer behind.
function nwDeadline(ms, now = () => Date.now()) {
  const started = now();
  const controller = new AbortController();
  const budget = Math.max(1, Number(ms) || 1);
  const timer = setTimeout(() => {
    try {
      controller.abort(new Error('deadline exceeded'));
    } catch (_) {
      controller.abort();
    }
  }, budget);
  // Never keep a Deno/Node process alive just for the deadline timer.
  if (timer && typeof timer.unref === 'function') timer.unref();
  return {
    signal: controller.signal,
    expired: () => controller.signal.aborted,
    remaining: () => Math.max(0, budget - (now() - started)),
    elapsed: () => now() - started,
    close: () => clearTimeout(timer),
  };
}

// Combine the per-operation timeout with the invocation deadline.
function nwMergeSignals(signals) {
  const list = (signals || []).filter(Boolean);
  if (list.length === 0) return undefined;
  if (list.length === 1) return list[0];
  if (typeof AbortSignal !== 'undefined' && typeof AbortSignal.any === 'function') {
    return AbortSignal.any(list);
  }
  const controller = new AbortController();
  for (const s of list) {
    if (s.aborted) {
      controller.abort(s.reason);
      return controller.signal;
    }
    s.addEventListener('abort', () => controller.abort(s.reason), { once: true });
  }
  return controller.signal;
}

// ── Capped read ─────────────────────────────────────────────────────────────
// Enforced while reading: once the cap is reached the stream is cancelled, so an
// oversized or hostile response can never be buffered past `maxBytes`.
// Fallback rule: if the body cannot be read as a stream, the response is
// discarded unread. A non-streaming read (res.text()/res.arrayBuffer()) buffers
// the entire body, and a declared Content-Length is a claim by the remote server,
// not a guarantee, so no such path is acceptable here.
async function nwReadCapped(res, maxBytes) {
  const cap = Math.max(0, Number(maxBytes) || 0);
  if (!res || !res.body) return { text: '', truncated: false, bytes: 0 };
  if (!res.body || typeof res.body.getReader !== 'function') {
    try { if (res.body && typeof res.body.cancel === 'function') await res.body.cancel(); } catch (_) {}
    return { text: '', truncated: true, bytes: 0, unreadable: true };
  }
  const reader = res.body.getReader();
  const chunks = [];
  let total = 0;
  let truncated = false;
  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    const room = cap - total;
    if (value.length > room) {
      if (room > 0) chunks.push(value.slice(0, room));
      total += Math.max(0, room);
      truncated = true;
      try { await reader.cancel(); } catch (_) {}
      break;
    }
    chunks.push(value);
    total += value.length;
    if (total >= cap) {
      truncated = true;
      try { await reader.cancel(); } catch (_) {}
      break;
    }
  }
  const buf = new Uint8Array(chunks.reduce((n, c) => n + c.length, 0));
  let off = 0;
  for (const c of chunks) { buf.set(c, off); off += c.length; }
  return { text: new TextDecoder().decode(buf), truncated, bytes: total };
}

// ── Guarded GET ─────────────────────────────────────────────────────────────
// Same contract as the function-local safeGet it replaces, plus an invocation
// deadline signal. Validation is injected so this module stays dependency-free.
//
// LIMITATION (unchanged by Phase 1): the request is issued by hostname, so the
// runtime resolves the name again at connect time. See PINNING_INVESTIGATION.md.
// JSON read through the same cap: parsing never sees more than `maxBytes`, and a
// truncated body is a failure rather than a partial parse.
async function nwReadJson(res, maxBytes) {
  const r = await nwReadCapped(res, maxBytes);
  if (r.unreadable) return { ok: false, reason: 'unreadable', truncated: true, bytes: 0 };
  if (r.truncated) return { ok: false, reason: 'too-large', truncated: true, bytes: r.bytes };
  try { return { ok: true, value: JSON.parse(r.text), bytes: r.bytes }; }
  catch (_) { return { ok: false, reason: 'bad-json', bytes: r.bytes }; }
}

async function nwSafeGet(url, opts) {
  const fetchImpl = opts.fetchImpl;
  const resolve = opts.resolve;
  const validateHostname = opts.validateHostname;
  const checkResolved = opts.checkResolved;
  const readCapped = opts.readCapped || nwReadCapped;
  const maxHops = opts.maxHops === undefined ? 3 : opts.maxHops;
  const timeoutMs = opts.timeoutMs === undefined ? 9000 : opts.timeoutMs;
  const maxBytes = opts.maxBytes === undefined ? 1500000 : opts.maxBytes;
  const deadline = opts.signal;

  const hops = [];
  let current = url;

  for (let hop = 0; hop <= maxHops; hop++) {
    if (deadline && deadline.aborted) throw new Error('deadline exceeded');
    let u;
    try { u = new URL(current); } catch (_) { throw new Error('blocked_url: unparseable'); }
    if (u.protocol !== 'https:') throw new Error('blocked_url: https required');
    if (u.username || u.password) throw new Error('blocked_url: credentials rejected');
    if (u.port && u.port !== '443') throw new Error('blocked_url: port rejected');
    hops.push(current);

    const hostCheck = validateHostname(u.hostname);
    if (!hostCheck.ok) throw new Error('blocked_host: ' + hostCheck.error);

    const ips = await resolve(u.hostname);
    const ipCheck = checkResolved(ips);
    if (!ipCheck.ok) throw new Error('blocked_resolution: ' + ipCheck.error);

    const res = await fetchImpl(current, {
      method: 'GET',
      redirect: 'manual',
      signal: nwMergeSignals([AbortSignal.timeout(timeoutMs), deadline]),
      headers: {
        'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 ' +
          '(KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36',
        Accept: 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      },
    });

    if (res.status >= 300 && res.status < 400) {
      const loc = res.headers && res.headers.get ? res.headers.get('location') : null;
      if (!loc) throw new Error('redirect_without_location');
      current = new URL(loc, current).toString();
      continue;
    }

    const { text, truncated } = await readCapped(res, maxBytes);
    return { status: res.status, body: text, url: current, hops, truncated };
  }

  throw new Error('too_many_redirects');
}

// ── Phase 1 glue (generated) ────────────────────────────────────────────────
const nwGetenv = (k) => { try { return Deno.env.get(k); } catch (_) { return undefined; } };
const NW_METHODS = 'POST, OPTIONS';
// Ops knob, clamped: 12 s default sits below the 20 s client read timeout.
const nwDeadlineMs = () => Math.min(20000, Math.max(1000, Number(nwGetenv('NW_DEADLINE_MS')) || 12000));
const NW_CRTSH_MAX_BYTES = 400000;         // strict cap, enforced while reading
const NW_CRTSH_MAX_ROWS = 2000;
// crt.sh gets its own sub-budget: a hung CT query must never eat the whole
// invocation deadline and starve the rest of the scan.
const NW_CRTSH_MAX_MS = 6000;

// Configuration is read per request, not at import time, so module import order
// or a mid-deployment env change can never alter behaviour unexpectedly.
const nwOrigins = () => nwAllowedOriginsFromEnv(nwGetenv);
const nwCors = (req) => nwCorsHeaders(req.headers.get('origin'), nwOrigins(), NW_METHODS);
const nwPreflightFor = (req) => {
  const p = nwPreflight(req.headers.get('origin'), nwOrigins(), NW_METHODS);
  return new Response(p.body, { status: p.status, headers: p.headers });
};
const nwUnsupportedMediaType = (req) =>
  Response.json({ error: 'Content-Type must be application/json' },
    { status: 415, headers: { ...nwCors(req), 'Cache-Control': 'no-store' } });
const nwMethodNotAllowed = (req) =>
  Response.json({ error: 'Method not allowed' },
    { status: 405, headers: { ...nwCors(req), Allow: NW_METHODS, 'Cache-Control': 'no-store' } });
// NetWatch inline security block — generated from security/netGuard.mjs and
// security/safeGet.mjs. Base44 deploys single files, so no imports.
// Covered by netGuard.test.mjs + safeGet.test.mjs (22 tests).
// NetWatch — SSRF / abuse guard (pure logic, no runtime dependencies).
// Deployed copies inline this module; keeping it dependency-free makes it testable
// under Node and portable into Deno functions.

const V4_BLOCKED = [
  ['0.0.0.0', 8],          // "this" network
  ['10.0.0.0', 8],         // RFC1918
  ['100.64.0.0', 10],      // CGNAT (includes Alibaba metadata 100.100.100.200)
  ['127.0.0.0', 8],        // loopback
  ['169.254.0.0', 16],     // link-local + AWS/GCP/Azure metadata
  ['172.16.0.0', 12],      // RFC1918
  ['192.0.0.0', 24],       // IETF protocol assignments
  ['192.0.2.0', 24],       // TEST-NET-1
  ['192.88.99.0', 24],     // 6to4 relay anycast
  ['192.168.0.0', 16],     // RFC1918
  ['198.18.0.0', 15],      // benchmarking
  ['198.51.100.0', 24],    // TEST-NET-2
  ['203.0.113.0', 24],     // TEST-NET-3
  ['224.0.0.0', 4],        // multicast
  ['240.0.0.0', 4],        // reserved + broadcast
];

export const METADATA_HOSTS = new Set([
  'metadata.google.internal', 'metadata.goog', 'instance-data',
  'metadata', 'metadata.azure.com', 'metadata.tencentyun.com',
]);

function parseIPv4(s) {
  if (typeof s !== 'string') return null;
  const m = /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/.exec(s.trim());
  if (!m) return null;
  const p = m.slice(1).map(Number);
  if (p.some((n) => n > 255)) return null;
  return p;
}

function ipv4ToInt(p) {
  return ((p[0] << 24) >>> 0) + (p[1] << 16) + (p[2] << 8) + p[3];
}

function isBlockedIPv4(str) {
  const p = parseIPv4(str);
  if (!p) return true;             // unparseable is treated as unsafe
  const n = ipv4ToInt(p);
  for (const [base, bits] of V4_BLOCKED) {
    const b = ipv4ToInt(parseIPv4(base));
    const mask = bits === 0 ? 0 : (~0 << (32 - bits)) >>> 0;
    if ((n & mask) >>> 0 === (b & mask) >>> 0) return true;
  }
  return false;
}

/** Expand an IPv6 literal (no zone, no brackets) into 8 hextets, or null. */
function parseIPv6(s) {
  if (typeof s !== 'string') return null;
  let t = s.replace(/^\[|\]$/g, '').split('%')[0].toLowerCase();
  if (!t.includes(':')) return null;

  // embedded IPv4 tail (::ffff:1.2.3.4)
  const v4tail = /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})$/.exec(t);
  if (v4tail) {
    const p = parseIPv4(v4tail[1]);
    if (!p) return null;
    const hi = ((p[0] << 8) | p[1]).toString(16);
    const lo = ((p[2] << 8) | p[3]).toString(16);
    t = t.slice(0, -v4tail[1].length) + hi + ':' + lo;
  }

  const dbl = t.indexOf('::');
  let head = [], tail = [];
  if (dbl >= 0) {
    if (t.indexOf('::', dbl + 1) >= 0) return null;
    head = t.slice(0, dbl).split(':').filter(Boolean);
    tail = t.slice(dbl + 2).split(':').filter(Boolean);
  } else {
    head = t.split(':');
  }
  const missing = 8 - (head.length + tail.length);
  if (dbl < 0 && missing !== 0) return null;
  if (missing < 0) return null;
  const parts = [...head, ...Array(missing).fill('0'), ...tail];
  if (parts.length !== 8) return null;
  const out = parts.map((h) => parseInt(h, 16));
  if (out.some((n) => Number.isNaN(n) || n < 0 || n > 0xffff)) return null;
  return out;
}

function isBlockedIPv6(str) {
  const h = parseIPv6(str);
  if (!h) return true;
  const allZero = h.every((x) => x === 0);
  if (allZero) return true;                                    // ::
  if (h.slice(0, 7).every((x) => x === 0) && h[7] === 1) return true;  // ::1

  const embeddedV4 = () => {
    const p = [h[6] >> 8, h[6] & 0xff, h[7] >> 8, h[7] & 0xff];
    return `${p[0]}.${p[1]}.${p[2]}.${p[3]}`;
  };
  const isV4Mapped  = h.slice(0, 5).every((x) => x === 0) && h[5] === 0xffff;
  const isV4Compat  = h.slice(0, 6).every((x) => x === 0);
  const isNat64     = h[0] === 0x64 && h[1] === 0xff9b && h.slice(2, 6).every((x) => x === 0);
  const is6to4      = h[0] === 0x2002;
  if (isV4Mapped || isV4Compat || isNat64 || is6to4) {
    return isBlockedIPv4(embeddedV4());                        // unwrap and re-check
  }

  if ((h[0] & 0xfe00) === 0xfc00) return true;                 // fc00::/7 ULA
  if ((h[0] & 0xffc0) === 0xfe80) return true;                 // fe80::/10 link-local
  if ((h[0] & 0xff00) === 0xff00) return true;                 // ff00::/8 multicast
  if (h[0] === 0x2001 && h[1] === 0x0db8) return true;         // 2001:db8::/32 doc
  if (h[0] === 0x2001 && h[1] === 0x0000) return true;         // 2001::/32 Teredo
  if (h[0] === 0x0100 && h[1] === 0 && h[2] === 0 && h[3] === 0) return true; // 100::/64 discard
  return false;
}

function isBlockedAddress(ip) {
  if (parseIPv4(ip)) return isBlockedIPv4(ip);
  if (parseIPv6(ip)) return isBlockedIPv6(ip);
  return true;                                                 // not an IP at all
}

/** Strict hostname: RFC1123 labels, no IP literal, no scheme, no port, no userinfo. */
function validateHostname(host) {
  if (typeof host !== 'string') return { ok: false, error: 'missing host' };
  const h = host.trim().toLowerCase();
  if (!h) return { ok: false, error: 'empty host' };
  if (h.length > 253) return { ok: false, error: 'host too long' };
  if (h.includes('@') || h.includes('/') || h.includes('\\') || h.includes(':'))
    return { ok: false, error: 'host contains forbidden characters' };
  if (h.endsWith('.')) return { ok: false, error: 'trailing dot not accepted' };
  if (METADATA_HOSTS.has(h)) return { ok: false, error: 'metadata hostname blocked' };
  if (parseIPv4(h) || parseIPv6(h)) return { ok: false, error: 'IP literals not accepted' };
  if (h === 'localhost' || h.endsWith('.localhost') || h.endsWith('.local') || h.endsWith('.internal'))
    return { ok: false, error: 'local hostname blocked' };
  const labels = h.split('.');
  if (labels.length < 2) return { ok: false, error: 'host must be qualified' };
  for (const l of labels) {
    if (l.length === 0 || l.length > 63) return { ok: false, error: 'bad label length' };
    if (!/^[a-z0-9]([a-z0-9-]*[a-z0-9])?$/.test(l))
      return { ok: false, error: 'bad label syntax' };
  }
  if (!/^[a-z]{2,63}$/.test(labels[labels.length - 1]))
    return { ok: false, error: 'non-alphabetic TLD' };
  return { ok: true, host: h };
}


/** Every resolved address must pass; one bad record rejects the host. */
function checkResolved(records) {
  if (!Array.isArray(records) || records.length === 0)
    return { ok: false, error: 'no DNS records' };
  for (const r of records) {
    if (isBlockedAddress(r)) return { ok: false, error: `resolved to blocked address ${r}` };
  }
  return { ok: true, ips: [...new Set(records)] };
}

/**
 * Resolve + validate, then return the pinned address. Callers must connect to
 * `pinned` rather than re-resolving the hostname (rebinding defence).
 */

/** Redirect target validation. Rejects scheme changes, ports and blocked hosts. */

/** Best-effort in-isolate limiter. Not a substitute for gateway rate limiting. */

/**
 * Queuing semaphore: unlike createLimiter (which rejects when busy), this waits.
 * Used to cap concurrent DNS queries inside a deep scan.
 */

// NetWatch — guarded HTTP GET for user-controlled destinations.
// Manual redirect handling: every hop is re-validated (host rules + resolved IPs).
// No automatic redirects, no unbounded body reads, no unbounded hops.


/**
 * @param {string} url            absolute https URL
 * @param {object} opts
 * @param {Function} opts.fetchImpl   fetch-compatible function
 * @param {Function} opts.resolve     async (host) => string[]  (A/AAAA)
 * @param {number} [opts.maxHops]     default 3
 * @param {number} [opts.timeoutMs]   per-hop, default 9000
 * @param {number} [opts.maxBytes]    default 1_500_000
 * @returns {Promise<{status:number, body:string, url:string, hops:string[], truncated:boolean}>}
 */
async function safeGet(url, opts) {
  return nwSafeGet(url, {
    ...opts,
    fetchImpl: opts.fetchImpl,
    resolve: opts.resolve,
    validateHostname,
    checkResolved,
    readCapped,
    signal: opts.signal,
  });
}

async function readCapped(res, maxBytes) {
  return nwReadCapped(res, maxBytes);
}

/** Queuing semaphore: waits when full (unlike createLimiter, which rejects). */
function createSemaphore(max) {
  let active = 0;
  const queue = [];
  return async function run(fn) {
    if (active >= max) await new Promise((resolve) => queue.push(resolve));
    active++;
    try {
      return await fn();
    } finally {
      active--;
      const next = queue.shift();
      if (next) next();
    }
  };
}

const CDN_CNAME_PATTERNS: Record<string, string> = {
  'cloudflare': 'Cloudflare',
  'akamai': 'Akamai',
  'akamaitechnologies': 'Akamai',
  'fastly': 'Fastly',
  'cloudfront': 'AWS CloudFront',
  'amazonaws': 'AWS',
  'googleusercontent': 'Google Cloud',
  'googleplex': 'Google',
  'goog': 'Google',
  'azureedge': 'Azure CDN',
  'azure': 'Microsoft Azure',
  'msecnd': 'Azure CDN',
  'cdn77': 'CDN77',
  'stackpathcdn': 'StackPath',
  'netdna-cdn': 'StackPath',
  'maxcdn': 'StackPath',
  'edgekey': 'Akamai Edge',
  'edgesuite': 'Akamai Edge',
  'edgecastcdn': 'Verizon EdgeCast',
  'llnwd': 'Limelight',
  'limelight': 'Limelight',
  'incapdns': 'Imperva/Incapsula',
  'impervadns': 'Imperva',
  'sucuri': 'Sucuri',
  'zendesk': 'Zendesk',
  'shopify': 'Shopify',
  'github.io': 'GitHub Pages',
  'netlify': 'Netlify',
  'vercel': 'Vercel',
  'pages.dev': 'Cloudflare Pages',
  'workers.dev': 'Cloudflare Workers',
  'heroku': 'Heroku',
  'wpengine': 'WP Engine',
  'kinsta': 'Kinsta',
  'bunny.net': 'BunnyCDN',
  'b-cdn.net': 'BunnyCDN',
};

const CDN_IP_RANGES: Array<{prefix: string, label: string}> = [
  { prefix: '104.16.', label: 'Cloudflare' },
  { prefix: '104.17.', label: 'Cloudflare' },
  { prefix: '104.18.', label: 'Cloudflare' },
  { prefix: '104.19.', label: 'Cloudflare' },
  { prefix: '104.20.', label: 'Cloudflare' },
  { prefix: '104.21.', label: 'Cloudflare' },
  { prefix: '172.64.', label: 'Cloudflare' },
  { prefix: '172.65.', label: 'Cloudflare' },
  { prefix: '172.66.', label: 'Cloudflare' },
  { prefix: '172.67.', label: 'Cloudflare' },
  { prefix: '162.158.', label: 'Cloudflare' },
  { prefix: '198.41.', label: 'Cloudflare' },
  { prefix: '23.227.38.', label: 'Shopify' },
  { prefix: '151.101.', label: 'Fastly' },
  { prefix: '199.232.', label: 'Fastly/GitHub' },
  { prefix: '13.', label: 'AWS' },
  { prefix: '52.', label: 'AWS' },
  { prefix: '54.', label: 'AWS' },
  { prefix: '34.', label: 'Google Cloud' },
  { prefix: '35.', label: 'Google Cloud' },
  { prefix: '142.250.', label: 'Google' },
  { prefix: '216.58.', label: 'Google' },
  { prefix: '172.217.', label: 'Google' },
  { prefix: '20.', label: 'Microsoft Azure' },
  { prefix: '40.', label: 'Microsoft Azure' },
];

function detectCdn(cname: string, ips: string[]): string | null {
  if (cname) {
    const cn = cname.toLowerCase();
    for (const [pattern, label] of Object.entries(CDN_CNAME_PATTERNS)) {
      if (cn.includes(pattern)) return label;
    }
  }
  for (const ip of ips) {
    for (const range of CDN_IP_RANGES) {
      if (ip.startsWith(range.prefix)) return range.label;
    }
  }
  return null;
}

// Extract the registrable domain (e.g. "api.paypal.com" -> "paypal.com")
function getRegistrableDomain(host: string): string {
  const parts = host.split('.');
  if (parts.length <= 2) return host;
  const multiTlds = ['co.uk', 'co.jp', 'com.au', 'com.br', 'co.kr', 'com.cn', 'com.tw', 'com.hk', 'com.sg', 'co.in', 'com.mx', 'co.za'];
  const lastTwo = parts.slice(-2).join('.');
  if (multiTlds.includes(lastTwo)) return parts.slice(-3).join('.');
  return parts.slice(-2).join('.');
}

Deno.serve(async (req) => {
  // Phase 1: explicit CORS, JSON-only bodies, POST only, one hard deadline.
  if (req.method === 'OPTIONS') return nwPreflightFor(req);
  if (!nwMethodAllowed(req.method, NW_METHODS)) return nwMethodNotAllowed(req);
  if (!nwContentTypeAccepted(req.method, req.headers.get('content-type')))
    return nwUnsupportedMediaType(req);

  const dl = nwDeadline(nwDeadlineMs());
  let nwTruncated = false;
  const nwGuard = () => {
    if (!dl.expired()) return true;
    nwTruncated = true;
    return false;
  };
  try {
    const body = await req.json().catch(() => ({}));
    const { domain, deep } = body;
    if (!domain) return Response.json({ error: 'Domain is required' }, { status: 400 });

    // ── D14 guard: normalise, then validate strictly. Scheme/path/userinfo are
    // stripped for backward compatibility with clients that send a full URL.
    const rawHost = String(domain)
      .trim()
      .replace(/^[a-z][a-z0-9+.-]*:\/\//i, '')
      .replace(/\/.*$/, '')
      .replace(/^[^@]*@/, '')
      .toLowerCase();
    const hostCheck = validateHostname(rawHost);
    if (!hostCheck.ok) {
      return Response.json(
        { error: 'Invalid or disallowed domain' },
        { status: 400, headers: { 'Cache-Control': 'no-store' } },
      );
    }
    const cleanDomain = hostCheck.host;

    const isDeep = deep === true || deep === 'true';

    const results: any = {
      domain: cleanDomain,
      timestamp: new Date().toISOString(),
      deep: isDeep,
      truncated: false,
      ipv4: [],
      ipv6: [],
      cname: null,
      cdn: null,
      subdomains: [],
      sharedHostDomains: [],
      crossDomains: [],
      certNames: [],
      pageHosts: [],
      errors: []
    };

    // ── DNS helper via Cloudflare DoH ────────────────────────────────────────
    // Bounded: hard query budget per invocation + max 8 concurrent lookups.
    let nwDnsCount = 0;
    const NW_DNS_BUDGET = 400;
    const nwDnsGate = createSemaphore(8);
    const fetchDns = async (name: string, type: string) => {
      if (++nwDnsCount > NW_DNS_BUDGET) throw new Error('dns query budget exceeded');
      const r = await nwDnsGate(() => fetch(
        `https://cloudflare-dns.com/dns-query?name=${encodeURIComponent(name)}&type=${type}`,
        { headers: { Accept: 'application/dns-json' },
          signal: nwMergeSignals([AbortSignal.timeout(7000), dl.signal]) }
      ));
      // The DoH body is capped like every other network read: a hostile or
      // broken resolver cannot make us buffer an unbounded JSON document.
      const jr = await nwReadJson(r, 262144);
      if (!jr.ok) throw new Error('dns-json: ' + jr.reason);
      const d: any = jr.value;
      return (d.Answer || []) as any[];
    };

    // ── 1. Root domain DNS ───────────────────────────────────────────────────
    try {
      const recs = await fetchDns(cleanDomain, 'A');
      results.ipv4 = [...new Set(recs.map((r: any) => r.data as string))];
    } catch (e: any) { results.errors.push('A: ' + e.message); }

    try {
      const recs = await fetchDns(cleanDomain, 'AAAA');
      results.ipv6 = [...new Set(recs.map((r: any) => r.data as string))];
    } catch (e: any) { results.errors.push('AAAA: ' + e.message); }

    try {
      const recs = await fetchDns(cleanDomain, 'CNAME');
      if (recs.length > 0) results.cname = recs[0].data.replace(/\.$/, '');
    } catch (_) {}

    // ── D14 guard: fail closed if the domain resolves to a non-public address.
    const nwRootIps = [...results.ipv4, ...results.ipv6];
    const resolvedCheck = checkResolved(nwRootIps);
    // Empty answers are left to the normal "no records" handling below, so a typo
    // or a CNAME-only apex behaves exactly as it does today. Non-empty answers
    // containing anything private, loopback, link-local or metadata are refused.
    if (nwRootIps.length > 0 && !resolvedCheck.ok) {
      return Response.json(
        { error: 'Domain does not resolve to a public address' },
        { status: 400, headers: { 'Cache-Control': 'no-store' } },
      );
    }

    results.cdn = detectCdn(results.cname || '', results.ipv4);

    // ── 2. crt.sh certificate transparency ──────────────────────────────────
    const subSet = new Set<string>();
    const crossDomainSet = new Set<string>();
    const certNameSet = new Set<string>();

    try {
      if (!nwGuard()) throw new Error('deadline');
      const r = await fetch(
        `https://crt.sh/?q=%25.${cleanDomain}&output=json`,
        { signal: nwMergeSignals([AbortSignal.timeout(NW_CRTSH_MAX_MS), dl.signal]) }
      );
      if (r.ok) {
        // Strict cap enforced while reading: an oversized CT response is cut
        // off and the reader cancelled instead of being buffered in full.
        const capped = await nwReadCapped(r, NW_CRTSH_MAX_BYTES);
        if (capped.truncated) {
          nwTruncated = true;
          results.errors.push('crt.sh: response truncated at ' + NW_CRTSH_MAX_BYTES + ' bytes');
        }
        const text = capped.text;
        if (text.trim().startsWith('[')) {
          let rows = [];
          try { rows = JSON.parse(text); } catch (_) { rows = []; }
          if (!Array.isArray(rows)) rows = [];
          for (const row of rows.slice(0, NW_CRTSH_MAX_ROWS)) {
            const names = [
              ...(row.name_value || '').split('\n'),
              row.common_name || ''
            ];
            for (const raw of names) {
              const n = raw.trim().toLowerCase().replace(/^\*\./, '');
              if (!n || n.includes(' ') || n.includes('@')) continue;
              certNameSet.add(n);

              if (n.endsWith('.' + cleanDomain) && n !== cleanDomain) {
                subSet.add(n);
              }

              // Cross-domain: cert SANs referencing different root domains
              const regDomain = getRegistrableDomain(n);
              if (regDomain !== cleanDomain && regDomain !== getRegistrableDomain(cleanDomain)) {
                const queryLabels = cleanDomain.split('.').slice(-2)[0];
                const regLabels = regDomain.split('.').slice(-2)[0];
                if (queryLabels && regLabels && (regLabels.includes(queryLabels) || queryLabels.includes(regLabels))) {
                  crossDomainSet.add(regDomain);
                }
              }
            }
          }
        }
      }
    } catch (e: any) { results.errors.push('crt.sh: ' + e.message); }

    results.certNames = Array.from(certNameSet).slice(0, 100);

    // ── 3. DNS brute-force common prefixes ───────────────────────────────────
    const commonPrefixes = [
      'www', 'www2', 'mail', 'ftp', 'smtp', 'pop', 'imap',
      'api', 'api2', 'api3', 'rest', 'graphql', 'ws', 'websocket',
      'dev', 'staging', 'stage', 'uat', 'test', 'beta', 'alpha', 'preview',
      'prod', 'production', 'old', 'new', 'v1', 'v2', 'v3',
      'app', 'apps', 'web', 'portal', 'dashboard', 'console', 'panel',
      'admin', 'manage', 'management', 'cp', 'cpanel', 'plesk',
      'cdn', 'cdn2', 'static', 'assets', 'media', 'img', 'images', 'video',
      'upload', 'uploads', 'files', 'download', 'downloads', 'content',
      'blog', 'news', 'forum', 'community', 'shop', 'store', 'pay',
      'auth', 'sso', 'login', 'oauth', 'accounts', 'id', 'identity',
      'support', 'help', 'docs', 'documentation', 'kb', 'status', 'monitor',
      'vpn', 'remote', 'secure', 'ssl', 'mobile', 'm', 'wap',
      'smtp', 'mx', 'mx1', 'mx2', 'relay', 'bounce',
      'analytics', 'track', 'tracking', 'pixel', 'stats',
      'search', 'data', 'db', 'sql', 'cache', 'redis',
      'git', 'gitlab', 'github', 'ci', 'jenkins', 'build',
      'grafana', 'kibana', 'elastic', 'logs',
      'ns1', 'ns2', 'ns3', 'dns', 'dns1', 'dns2',
      // Additional prefixes for deep scan
      'checkout', 'payment', 'payments', 'billing', 'invoice', 'subscription',
      'sdk', 'hooks', 'webhooks', 'callback', 'redirect',
      'i', 'css', 'js', 'fonts', 'static1', 'static2',
      'edge', 'origin', 'backend', 'server', 'node', 'worker',
      'proxy', 'gateway', 'router', 'lb', 'loadbalancer',
      'sandbox', 'demo', 'trial', 'free', 'plus', 'pro', 'enterprise',
      'internal', 'private', 'public', 'ext', 'external',
      'go', 'link', 'links', 'short', 's', 'r',
      'widget', 'embed', 'iframe', 'frame',
      'notifications', 'push', 'fcm', 'apns', 'firebase',
      'collector', 'ingest', 'event', 'events', 'telemetry',
      'config', 'settings', 'env', 'metadata',
      'health', 'ready', 'alive', 'ping',
      'swagger', 'openapi', 'api-docs',
      'gql', 'query',
      'stream', 'streaming', 'live', 'rtmp', 'hls',
      'storage', 'bucket', 's3', 'blob',
      'ml', 'ai', 'model', 'inference', 'predict',
    ];

    if (nwGuard()) {
      await Promise.allSettled(
        commonPrefixes.map(async (prefix) => {
          const fqdn = `${prefix}.${cleanDomain}`;
          try {
            const recs = await fetchDns(fqdn, 'A');
            if (recs.length > 0) subSet.add(fqdn);
          } catch (_) {}
        })
      );
    }

    // ── 4. Resolve all discovered subdomains in parallel (batched) ────────────
    const allSubs = Array.from(subSet).sort();
    const BATCH = 20;
    const subdomainResults: any[] = [];

    for (let i = 0; i < Math.min(allSubs.length, 200); i += BATCH) {
      if (dl.expired()) { nwTruncated = true; results.errors.push('deadline: subdomain scan stopped'); break; }
      const batch = allSubs.slice(i, i + BATCH);
      const resolved = await Promise.allSettled(
        batch.map(async (sub) => {
          try {
            const [aRecs, cnameRecs] = await Promise.allSettled([
              fetchDns(sub, 'A'),
              fetchDns(sub, 'CNAME'),
            ]);
            const ips: string[] = aRecs.status === 'fulfilled'
              ? [...new Set(aRecs.value.map((r: any) => r.data as string))]
              : [];
            const subCname = cnameRecs.status === 'fulfilled' && cnameRecs.value.length > 0
              ? cnameRecs.value[0].data.replace(/\.$/, '')
              : null;
            const cdn = detectCdn(subCname || '', ips);
            const live = ips.length > 0;
            return { name: sub, ips, cname: subCname, cdn, live };
          } catch (_) {
            return { name: sub, ips: [], cname: null, cdn: null, live: false };
          }
        })
      );
      for (const r of resolved) {
        if (r.status === 'fulfilled') subdomainResults.push(r.value);
      }
    }

    subdomainResults.sort((a, b) => {
      if (a.live !== b.live) return a.live ? -1 : 1;
      return a.name.localeCompare(b.name);
    });

    results.subdomains = subdomainResults;
    results.totalDiscovered = allSubs.length;
    results.liveCount = subdomainResults.filter(s => s.live).length;

    // ── 4b. Page-Embedded Host Discovery (hidden dependencies) ────────────────
    // Fetches the live site and extracts every external hostname referenced in
    // scripts, stylesheets, images, iframes, form actions and inline JS.
    // This is the ONLY way to find domains like ttua.nu that share no DNS,
    // certificate or name similarity with the primary domain.
    try {
      if (!nwGuard()) throw new Error('deadline');
      const UAs = { 
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.9'
      };
      
      // ── D14 guard: manual redirect handling, every hop validated.
      const nwResolve = async (h: string): Promise<string[]> => {
        const out: string[] = [];
        for (const t of ['A', 'AAAA']) {
          try {
            const rs = await fetchDns(h, t);
            for (const r of rs) out.push(r.data as string);
          } catch (_) {}
        }
        return out;
      };
      const htmlPages = await Promise.allSettled([
        safeGet(`https://${cleanDomain}/`, { fetchImpl: fetch, resolve: nwResolve, timeoutMs: 9000, maxHops: 3, signal: dl.signal }),
        safeGet(`https://www.${cleanDomain}/`, { fetchImpl: fetch, resolve: nwResolve, timeoutMs: 9000, maxHops: 3, signal: dl.signal }),
      ]);

      let html = '';
      if (dl.expired()) {
        nwTruncated = true;
        results.errors.push('deadline: page fetch aborted');
      }
      for (const p of htmlPages) {
        if (p.status === 'rejected') {
          results.errors.push('page fetch: ' + ((p.reason && p.reason.message) || 'failed'));
        }
        if (p.status === 'fulfilled' && p.value && p.value.status < 400) {
          html += p.value.body || '';
        }
      }
      html = html.slice(0, 1500000); // safety cap

      if (html.length > 0) {
        const queryReg = getRegistrableDomain(cleanDomain);
        const hostSource = new Map<string, string>(); // host -> source type (first match wins)
        const sourcePriority = ['script', 'iframe', 'form', 'stylesheet', 'img', 'inline'];
        // Social-media SITE domains are boilerplate on every corporate page (footer share
        // links, og: meta tags) and carry zero dependency intel — filter them out.
        // Their actual code infrastructure (connect.facebook.net SDK, twimg.com,
        // fbcdn.net CDNs) lives on different registrable domains and is still reported.
        const socialSiteDomains = new Set([
          'facebook.com', 'fb.com', 'fb.me',
          'instagram.com',
          'tiktok.com',
          'linkedin.com', 'lnkd.in',
          'twitter.com', 'x.com',
          'youtube.com', 'youtu.be',
        ]);
        
        const classify = (host: string, src: string) => {
          if (!host || host.includes(' ') || host.includes('@')) return;
          // Skip the query domain itself and its subdomains
          if (host === cleanDomain || host.endsWith('.' + cleanDomain)) return;
          if (getRegistrableDomain(host) === queryReg) return;
          // Skip pure IPs and localhost
          if (/^\d+\.\d+\.\d+\.\d+$/.test(host) || host === 'localhost') return;
          if (!host.includes('.') || host.length > 253) return;
          // Skip social-media site links (marketing boilerplate, not dependencies)
          if (socialSiteDomains.has(getRegistrableDomain(host))) return;
          const existing = hostSource.get(host);
          if (existing && sourcePriority.indexOf(existing) <= sourcePriority.indexOf(src)) return;
          hostSource.set(host, src);
        };

        const extractHost = (u: string): string | null => {
          if (!u) return null;
          const m = u.match(/^(?:https?:)?\/\/([^\/?#'"]+)/);
          if (!m) return null;
          return m[1].toLowerCase().split(':')[0].replace(/\.$/, '');
        };

        // script src= (including trackers, tag managers, analytics)
        let re = /<script[^>]+src=["']([^"']+)["']/gi; let m;
        while ((m = re.exec(html))) classify(extractHost(m[1]) || '', 'script');
        // iframe src=
        re = /<iframe[^>]+src=["']([^"']+)["']/gi;
        while ((m = re.exec(html))) classify(extractHost(m[1]) || '', 'iframe');
        // form action=
        re = /<form[^>]+action=["']([^"']+)["']/gi;
        while ((m = re.exec(html))) classify(extractHost(m[1]) || '', 'form');
        // link href= (stylesheets, preconnect, preloads)
        re = /<link[^>]+href=["']([^"']+)["']/gi;
        while ((m = re.exec(html))) classify(extractHost(m[1]) || '', 'stylesheet');
        // img src=
        re = /<img[^>]+src=["']([^"']+)["']/gi;
        while ((m = re.exec(html))) classify(extractHost(m[1]) || '', 'img');
        // meta refresh + og tags
        re = /<meta[^>]+(?:url|content)=["']([^"']*https?[^"']*)["']/gi;
        while ((m = re.exec(html))) classify(extractHost(m[1]) || '', 'iframe');
        // Generic https:// URLs anywhere (inline JS, JSON blobs, srcset)
        re = /(?:https?:)?\/\/([a-zA-Z0-9][a-zA-Z0-9.-]*\.[a-zA-Z]{2,})(?:[\/"'?#:]|$)/gi;
        while ((m = re.exec(html))) classify(m[1].toLowerCase(), 'inline');

        // Resolve the top external hosts (max 15, scripts first)
        const sortedHosts = Array.from(hostSource.entries())
          .sort((a, b) => {
            const pi = sourcePriority.indexOf(a[1]), pj = sourcePriority.indexOf(b[1]);
            if (pi !== pj) return pi - pj;
            return a[0].localeCompare(b[0]);
          })
          .slice(0, 15);

        const pageResolved = await Promise.allSettled(
          sortedHosts.map(async ([host, src]) => {
            try {
              const [aRecs, cnameRecs] = await Promise.allSettled([
                fetchDns(host, 'A'),
                fetchDns(host, 'CNAME'),
              ]);
              const ips: string[] = aRecs.status === 'fulfilled'
                ? [...new Set(aRecs.value.map((r: any) => r.data as string))]
                : [];
              const cname = cnameRecs.status === 'fulfilled' && cnameRecs.value.length > 0
                ? cnameRecs.value[0].data.replace(/\.$/, '')
                : null;
              const cdn = detectCdn(cname || '', ips);
              return { domain: host, source: src, ips, cname, cdn, live: ips.length > 0 };
            } catch (_) {
              return { domain: host, source: src, ips: [], cname: null, cdn: null, live: false };
            }
          })
        );
        for (const r of pageResolved) {
          if (r.status === 'fulfilled') results.pageHosts.push(r.value);
        }
        // live first, then scripts first
        results.pageHosts.sort((a: any, b: any) => {
          if (a.live !== b.live) return a.live ? -1 : 1;
          const pi = sourcePriority.indexOf(a.source), pj = sourcePriority.indexOf(b.source);
          if (pi !== pj) return pi - pj;
          return a.domain.localeCompare(b.domain);
        });
      }
    } catch (e: any) { results.errors.push('pageEmbed: ' + e.message); }

    // ── 5. Cross-domain discovery ────────────────────────────────────────────
    if (crossDomainSet.size > 0) {
      const crossResults: any[] = [];
      const crossArr = Array.from(crossDomainSet).slice(0, 10);
      const crossResolved = await Promise.allSettled(
        crossArr.map(async (cd) => {
          try {
            const recs = await fetchDns(cd, 'A');
            const ips = [...new Set(recs.map((r: any) => r.data as string))];
            const cnameRecs = await fetchDns(cd, 'CNAME').catch(() => [] as any[]);
            const cname = cnameRecs.length > 0 ? cnameRecs[0].data.replace(/\.$/, '') : null;
            const cdn = detectCdn(cname || '', ips);
            return { domain: cd, ips, cname, cdn, live: ips.length > 0 };
          } catch (_) {
            return { domain: cd, ips: [], cname: null, cdn: null, live: false };
          }
        })
      );
      for (const r of crossResolved) {
        if (r.status === 'fulfilled') crossResults.push(r.value);
      }
      results.crossDomains = crossResults;
    }

    // ── 6. PTR / Shared-host (deep: check ALL resolved IPs) ───────────────────
    const ptrDomains = new Set<string>();
    const ipsToCheck = isDeep
      ? [...new Set([
          ...results.ipv4,
          ...subdomainResults.filter(s => s.live).flatMap(s => s.ips).filter(ip => /^\d+\.\d+\.\d+\.\d+$/.test(ip))
        ])].slice(0, 10)
      : results.ipv4.slice(0, 3);

    await Promise.allSettled(ipsToCheck.map(async (ip: string) => {
      try {
        const reversed = ip.split('.').reverse().join('.') + '.in-addr.arpa';
        const recs = await fetchDns(reversed, 'PTR');
        for (const r of recs) {
          const ptr = r.data.replace(/\.$/, '').toLowerCase();
          if (ptr && ptr !== cleanDomain) {
            ptrDomains.add(ptr);
            const ptrReg = getRegistrableDomain(ptr);
            if (ptrReg !== cleanDomain && ptrReg !== getRegistrableDomain(cleanDomain)) {
              const queryLabel = cleanDomain.split('.').slice(-2)[0];
              const ptrLabel = ptrReg.split('.').slice(-2)[0];
              if (ptrLabel && queryLabel && (ptrLabel.includes(queryLabel) || queryLabel.includes(ptrLabel))) {
                crossDomainSet.add(ptrReg);
              }
            }
          }
        }
      } catch (_) {}
    }));
    results.sharedHostDomains = Array.from(ptrDomains).slice(0, 30);

    // Update crossDomains if PTR revealed more
    if (isDeep && crossDomainSet.size > (results.crossDomains?.length || 0)) {
      const existing = new Set((results.crossDomains || []).map((c: any) => c.domain));
      const newOnes = Array.from(crossDomainSet).filter(d => !existing.has(d)).slice(0, 5);
      if (newOnes.length > 0) {
        const newResolved = await Promise.allSettled(
          newOnes.map(async (cd) => {
            try {
              const recs = await fetchDns(cd, 'A');
              const ips = [...new Set(recs.map((r: any) => r.data as string))];
              return { domain: cd, ips, cname: null, cdn: detectCdn('', ips), live: ips.length > 0 };
            } catch (_) {
              return { domain: cd, ips: [], cname: null, cdn: null, live: false };
            }
          })
        );
        for (const r of newResolved) {
          if (r.status === 'fulfilled') results.crossDomains.push(r.value);
        }
      }
    }

    results.truncated = results.truncated || nwTruncated;
    return Response.json(results, {
      headers: { ...nwCors(req), 'Content-Type': 'application/json', 'Cache-Control': 'no-store' }
    });

  } catch (err) {
    return Response.json({ error: err.message },
      { status: 500, headers: { ...nwCors(req), 'Cache-Control': 'no-store' } });
  } finally {
    dl.close();
  }
});
