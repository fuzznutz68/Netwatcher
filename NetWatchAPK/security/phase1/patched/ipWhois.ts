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
async function nwReadCapped(res, maxBytes) {
  const cap = Math.max(0, Number(maxBytes) || 0);
  if (!res || !res.body || typeof res.body.getReader !== 'function') {
    const t = await (res ? res.text() : Promise.resolve(''));
    const s = String(t);
    return { text: s.slice(0, cap), truncated: s.length > cap, bytes: Math.min(s.length, cap) };
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
const NW_METHODS = 'GET, POST, OPTIONS';

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
// D14 zero-cost core: Cymru IP-to-ASN over Cloudflare DoH, PTR, cache.
const V4_BLOCKED = [
  ['0.0.0.0', 8], ['10.0.0.0', 8], ['100.64.0.0', 10], ['127.0.0.0', 8],
  ['169.254.0.0', 16], ['172.16.0.0', 12], ['192.0.0.0', 24], ['192.0.2.0', 24],
  ['192.88.99.0', 24], ['192.168.0.0', 16], ['198.18.0.0', 15], ['198.51.100.0', 24],
  ['203.0.113.0', 24], ['224.0.0.0', 4], ['240.0.0.0', 4],
];
const METADATA_HOSTS = new Set(['metadata.google.internal', 'metadata.goog', 'instance-data',
  'metadata', 'metadata.azure.com', 'metadata.tencentyun.com']);

function parseIPv4(s) {
  if (typeof s !== 'string') return null;
  const m = /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/.exec(s.trim());
  if (!m) return null;
  const p = m.slice(1).map(Number);
  if (p.some((n) => n > 255)) return null;
  return p;
}
function ipv4ToInt(p) { return ((p[0] << 24) >>> 0) + (p[1] << 16) + (p[2] << 8) + p[3]; }
function isBlockedIPv4(str) {
  const p = parseIPv4(str);
  if (!p) return true;
  const n = ipv4ToInt(p);
  for (const [base, bits] of V4_BLOCKED) {
    const b = ipv4ToInt(parseIPv4(base));
    const mask = bits === 0 ? 0 : (~0 << (32 - bits)) >>> 0;
    if (((n & mask) >>> 0) === ((b & mask) >>> 0)) return true;
  }
  return false;
}
function parseIPv6(s) {
  if (typeof s !== 'string') return null;
  let t = s.replace(/^\[|\]$/g, '').split('%')[0].toLowerCase();
  if (!t.includes(':')) return null;
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
  if (h.every((x) => x === 0)) return true;
  if (h.slice(0, 7).every((x) => x === 0) && h[7] === 1) return true;
  const embedded = () => `${h[6] >> 8}.${h[6] & 0xff}.${h[7] >> 8}.${h[7] & 0xff}`;
  const mapped = h.slice(0, 5).every((x) => x === 0) && h[5] === 0xffff;
  const compat = h.slice(0, 6).every((x) => x === 0);
  const nat64 = h[0] === 0x64 && h[1] === 0xff9b && h.slice(2, 6).every((x) => x === 0);
  const sixtofour = h[0] === 0x2002;
  if (mapped || compat || nat64 || sixtofour) return isBlockedIPv4(embedded());
  if ((h[0] & 0xfe00) === 0xfc00) return true;
  if ((h[0] & 0xffc0) === 0xfe80) return true;
  if ((h[0] & 0xff00) === 0xff00) return true;
  if (h[0] === 0x2001 && h[1] === 0x0db8) return true;
  if (h[0] === 0x2001 && h[1] === 0x0000) return true;
  if (h[0] === 0x0100 && h[1] === 0 && h[2] === 0 && h[3] === 0) return true;
  return false;
}
function isBlockedAddress(ip) {
  if (parseIPv4(ip)) return isBlockedIPv4(ip);
  if (parseIPv6(ip)) return isBlockedIPv6(ip);
  return true;
}
function canonicalIp(raw) {
  if (typeof raw !== 'string') return null;
  const s = raw.trim();
  if (parseIPv4(s)) return s;
  if (parseIPv6(s)) return s.toLowerCase();
  return null;
}
function isPublicIp(raw) {
  const c = canonicalIp(raw);
  if (!c) return false;
  return !isBlockedAddress(c);
}

// ---- reverse query names -------------------------------------------------
function reverseV4(ip) { return ip.split('.').reverse().join('.'); }
function reverseV6(ip) {
  const h = parseIPv6(ip);
  if (!h) return null;
  const hex = h.map((x) => x.toString(16).padStart(4, '0')).join('');
  return hex.split('').reverse().join('.');
}
function originQName(ip) {
  if (parseIPv4(ip)) return reverseV4(ip) + '.origin.asn.cymru.com';
  const v6 = reverseV6(ip);
  if (v6) return v6 + '.origin6.asn.cymru.com';
  return null;
}
function ptrQName(ip) {
  if (parseIPv4(ip)) return reverseV4(ip) + '.in-addr.arpa';
  const v6 = reverseV6(ip);
  if (v6) return v6 + '.ip6.arpa';
  return null;
}
function asnQName(asn) {
  const n = String(asn || '').replace(/^AS/i, '');
  return /^\d{1,10}$/.test(n) ? 'AS' + n + '.asn.cymru.com' : null;
}

// ---- TXT parsing ---------------------------------------------------------
function joinTxtChunks(chunks) {
  if (!Array.isArray(chunks) || !chunks.length) return '';
  return chunks.map((c) => String(c == null ? '' : c)).join('')
    .replace(/"\s*"/g, '').replace(/"/g, '').trim();
}
function parseOriginTXT(answers) {
  const txt = joinTxtChunks(answers);
  if (!txt) return null;
  const parts = txt.split('|').map((s) => s.trim());
  if (parts.length < 3) return null;
  const asns = parts[0].split(/[\s,]+/).map((s) => s.replace(/^AS/i, ''))
    .filter((s) => /^\d{1,10}$/.test(s));
  const prefix = /^[0-9a-f:.]{2,45}\/\d{1,3}$/i.test(parts[1]) ? parts[1] : '';
  const cc = /^[A-Za-z]{2}$/.test(parts[2]) ? parts[2].toUpperCase() : '';
  if (!asns.length && !prefix) return null;
  return { asns, prefix, cc, registry: (parts[3] || '').toLowerCase(), allocated: parts[4] || '' };
}
function parseAsNameTXT(answers) {
  const txt = joinTxtChunks(answers);
  if (!txt) return null;
  const parts = txt.split('|').map((s) => s.trim());
  if (parts.length < 5) return null;
  const asn = parts[0].replace(/^AS/i, '');
  if (!/^\d{1,10}$/.test(asn)) return null;
  const name = parts.slice(4).join('|').trim();
  return { asn, cc: /^[A-Za-z]{2}$/.test(parts[1]) ? parts[1].toUpperCase() : '', name: cleanOrg(name) };
}
function cleanOrg(name) {
  let n = String(name || '').trim();
  if (!n) return '';
  n = n.replace(/,\s*[A-Za-z]{2}$/, '').trim();          // drop trailing ", US"
  const i = n.indexOf(' - ');
  if (i > 0) n = n.slice(i + 3).trim();                   // "GOOGLE - Google LLC"
  return n.replace(/\s{2,}/g, ' ').slice(0, 120);
}
function flagFor(cc) {
  const c = String(cc || '').toUpperCase();
  if (!/^[A-Z]{2}$/.test(c)) return String.fromCodePoint(0x1F310);
  const base = 0x1F1E6;
  return String.fromCodePoint(base + c.charCodeAt(0) - 65, base + c.charCodeAt(1) - 65);
}

// ---- bounded TTL cache ---------------------------------------------------
function createCache({ max = 1000, ttlMs = 6 * 3600 * 1000 } = {}) {
  const m = new Map();
  return {
    get(k) {
      const e = m.get(k);
      if (!e) return undefined;
      if (Date.now() > e.exp) { m.delete(k); return undefined; }
      m.delete(k); m.set(k, e);           // LRU touch
      return e.v;
    },
    set(k, v, ttl = ttlMs) {
      if (m.has(k)) m.delete(k);
      else if (m.size >= max) m.delete(m.keys().next().value);
      m.set(k, { v, exp: Date.now() + ttl });
    },
    get size() { return m.size; },
    clear() { m.clear(); },
  };
}

// ---- DoH ---------------------------------------------------------------
const DOH_URL = 'https://cloudflare-dns.com/dns-query';
async function dohQuery(name, type = 'TXT', { timeoutMs = 4000 } = {}) {
  if (typeof name !== 'string' || !name || name.length > 255) return { ok: false, reason: 'bad-name' };
  const url = `${DOH_URL}?name=${encodeURIComponent(name)}&type=${type}`;
  let r;
  try {
    r = await fetch(url, {
      headers: { Accept: 'application/dns-json' },
      redirect: 'manual',
      signal: AbortSignal.timeout(timeoutMs),
    });
  } catch (e) {
    return { ok: false, reason: 'network', error: String((e && e.message) || e) };
  }
  if (!r.ok) return { ok: false, reason: 'http', status: r.status };
  let d;
  try { d = await r.json(); } catch { return { ok: false, reason: 'bad-json' }; }
  if (d.Status === 3) return { ok: false, reason: 'nxdomain' };
  if (d.Status !== 0) return { ok: false, reason: 'rcode', status: d.Status };
  const TYPE_NUM = { A: 1, NS: 2, CNAME: 5, SOA: 6, PTR: 12, MX: 15, TXT: 16, AAAA: 28 };
  const num = typeof type === 'number' ? type : (TYPE_NUM[String(type).toUpperCase()] || 16);
  const answers = (d.Answer || []).filter((a) => a && a.type === num).map((a) => a.data);
  if (!answers.length) return { ok: false, reason: 'no-answer' };
  return { ok: true, answers };
}



const TTL_OK = 6 * 3600 * 1000;
const TTL_ASN = 24 * 3600 * 1000;
const TTL_NEG = 5 * 60 * 1000;

const originCache = createCache({ max: 2000, ttlMs: TTL_OK });
const asnCache = createCache({ max: 2000, ttlMs: TTL_ASN });
const ptrCache = createCache({ max: 2000, ttlMs: TTL_OK });

function resetCaches() { originCache.clear(); asnCache.clear(); ptrCache.clear(); }

async function resolveOrigin(ip, opts = {}) {
  const key = canonicalIp(ip);
  if (!key) return null;
  const hit = originCache.get(key);
  if (hit !== undefined) return hit;
  const q = originQName(key);
  if (!q) return null;
  const r = await dohQuery(q, 'TXT', opts);
  const parsed = r.ok ? parseOriginTXT(r.answers) : null;
  originCache.set(key, parsed, parsed ? TTL_OK : TTL_NEG);
  return parsed;
}

async function resolveOrg(asn, opts = {}) {
  const n = String(asn || '').replace(/^AS/i, '');
  if (!/^\d{1,10}$/.test(n)) return '';
  const hit = asnCache.get(n);
  if (hit !== undefined) return hit;
  const q = asnQName(n);
  if (!q) return '';
  const r = await dohQuery(q, 'TXT', opts);
  const parsed = r.ok ? parseAsNameTXT(r.answers) : null;
  const name = parsed ? parsed.name : '';
  asnCache.set(n, name, name ? TTL_ASN : TTL_NEG);
  return name;
}

async function resolvePtr(ip, opts = {}) {
  const key = canonicalIp(ip);
  if (!key) return null;
  const hit = ptrCache.get(key);
  if (hit !== undefined) return hit;
  const q = ptrQName(key);
  if (!q) return null;
  const r = await dohQuery(q, 'PTR', opts);
  let host = null;
  if (r.ok) {
    const a = String(r.answers[0] || '').replace(/"/g, '').trim().replace(/\.$/, '');
    host = /^[A-Za-z0-9._-]{1,253}$/.test(a) && a.includes('.') ? a.toLowerCase() : null;
  }
  ptrCache.set(key, host, host ? TTL_OK : TTL_NEG);
  return host;
}

// R2: registry country is labelled, never rendered as location. The flag is
// always the neutral globe, so no national flag can imply geography.
function geoPayload(origin, org) {
  const cc = (origin && origin.cc) || '';
  return {
    country: '',
    countryCode: cc ? cc + ' (registry)' : '',
    city: '',
    org: org || '',
    flag: String.fromCodePoint(0x1F310),
    registryCountry: cc,
    countryBasis: cc ? 'rir-registry' : '',
  };
}

// NetWatch - IP WHOIS, zero-cost edition: Cymru (ASN/prefix/country) + DoH PTR + RDAP.
// Legacy response shape preserved exactly (15 fields). City/region stay empty:
// the sources describe registration and routing, not physical geography.

const RDAP_HOSTS: Record<string, string> = {
  arin:    'https://rdap.arin.net/registry/ip/',
  ripencc: 'https://rdap.db.ripe.net/ip/',
  apnic:   'https://rdap.apnic.net/ip/',
  lacnic:  'https://rdap.lacnic.net/rdap/ip/',
  afrinic: 'https://rdap.afrinic.net/rdap/ip/',
};

function vcardEmail(vcard: any): string | null {
  try {
    const fields = Array.isArray(vcard) && Array.isArray(vcard[1]) ? vcard[1] : [];
    for (const f of fields) {
      if (Array.isArray(f) && f[0] === 'email' && typeof f[3] === 'string') return f[3];
    }
  } catch (_) { /* ignore */ }
  return null;
}

async function rdapLookup(ip: string, registry: string) {
  const base = RDAP_HOSTS[registry];
  if (!base) return { error: 'rdap: no registry' as string };
  try {
    const r = await fetch(base + encodeURIComponent(ip), {
      headers: { Accept: 'application/rdap+json' },
      redirect: 'manual',
      signal: AbortSignal.timeout(6000),
    });
    if (!r.ok) return { error: 'rdap: http ' + r.status };
    const text = (await r.text()).slice(0, 200000);
    let d: any;
    try { d = JSON.parse(text); } catch { return { error: 'rdap: bad json' }; }

    let abuse: string | null = null;
    let registrar: string | null = null;
    for (const e of (d.entities || [])) {
      const roles = e.roles || [];
      if (!abuse && roles.includes('abuse')) abuse = vcardEmail(e.vcardArray);
      if (!registrar && roles.includes('registrar')) registrar = e.handle || null;
    }
    return {
      name: d.name || d.handle || null,
      registrar,
      abuse,
      cidr: d.startAddress && d.endAddress ? d.startAddress + ' - ' + d.endAddress : null,
    };
  } catch (e: any) {
    const msg = String((e && e.message) || e);
    return { error: /timeout|abort/i.test(msg) ? 'rdap: timeout' : 'rdap: network' };
  }
}

Deno.serve(async (req: Request) => {
  // Phase 1: explicit CORS. GET stays bodyless and exempt from the JSON gate,
  // which is what the shipped Android client uses: GET /ipWhois?ip=...
  const cors = nwCors(req);
  if (req.method === 'OPTIONS') return nwPreflightFor(req);
  if (!nwMethodAllowed(req.method, NW_METHODS)) return nwMethodNotAllowed(req);
  if (!nwContentTypeAccepted(req.method, req.headers.get('content-type')))
    return nwUnsupportedMediaType(req);

  try {
    let raw = '';
    if (req.method === 'GET') {
      raw = new URL(req.url).searchParams.get('ip') || '';
    } else {
      const body = await req.json().catch(() => ({}));
      raw = (body as any)?.ip || '';
    }

    const ip = canonicalIp(raw);
    if (!ip || !isPublicIp(ip)) {
      return Response.json({ error: 'Invalid IP address' }, { status: 400, headers: cors });
    }

    const errors: string[] = [];

    const origin = await resolveOrigin(ip);
    let asn: string | null = null;
    let asnName: string | null = null;
    let countryCode = '';
    let prefix = '';
    if (origin) {
      countryCode = origin.cc || '';
      prefix = origin.prefix || '';
      if (origin.asns.length) {
        asn = 'AS' + origin.asns[0];
        const name = await resolveOrg(origin.asns[0]);
        asnName = name || null;
      }
    } else {
      errors.push('cymru: no origin record');
    }

    const hostname = await resolvePtr(ip);

    const rdap: any = await rdapLookup(ip, origin ? origin.registry : '');
    if (rdap && rdap.error) errors.push(rdap.error);

    const payload = {
      ip,
      hostname: hostname || null,
      org: asnName || null,
      asn,
      asn_name: asnName,
      country: countryCode ? countryCode + ' (registry)' : '',
      country_code: countryCode,
      city: '',
      registryCountry: countryCode,
      countryBasis: countryCode ? 'rir-registry' : '',
      cidr: rdap && rdap.cidr ? rdap.cidr : (prefix || null),
      rdap_name: (rdap && rdap.name) || null,
      rdap_registrar: (rdap && rdap.registrar) || null,
      abuse_contact: (rdap && rdap.abuse) || null,
      whois_server: null,
      timestamp: new Date().toISOString(),
      errors,
    };

    return Response.json(payload, {
      headers: { ...cors, 'Content-Type': 'application/json', 'Cache-Control': 'no-store' },
    });
  } catch (err: any) {
    return Response.json({ error: (err && err.message) || 'lookup failed' }, { status: 500, headers: cors });
  }
});
