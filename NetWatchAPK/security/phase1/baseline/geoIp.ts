// @ts-nocheck
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

// NetWatch - Geo-IP lookup, zero-cost Cymru/DoH edition.
// Contract unchanged: POST { "ips": [...] } -> { "results": { "<exact input>": { country, countryCode, city, org, flag } } }
// country/city are knowingly empty: Cymru reports registry data (ASN, prefix, country
// code), not physical geolocation. Nothing is inferred.
function unknownGeo() {
  return {
    country: '', countryCode: '', city: '', org: '',
    flag: String.fromCodePoint(0x1F310),
    registryCountry: '', countryBasis: '',
  };
}

async function pool(items: string[], limit: number, fn: (x: string) => Promise<void>) {
  let next = 0;
  const workers = Array.from({ length: Math.min(limit, items.length) }, async () => {
    while (true) {
      const i = next++;
      if (i >= items.length) return;
      try { await fn(items[i]); } catch (_) { /* per-item isolation */ }
    }
  });
  await Promise.all(workers);
}

Deno.serve(async (req: Request) => {
  const cors = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
  };
  if (req.method === 'OPTIONS') return new Response(null, { headers: cors });

  try {
    const body = await req.json().catch(() => ({}));
    const ips = (body as any)?.ips;
    if (!ips || !Array.isArray(ips) || ips.length === 0) {
      return Response.json({ error: 'ips array is required' }, { status: 400, headers: cors });
    }

    const unique: string[] = [...new Set(ips.filter((x: any) => typeof x === 'string'))].slice(0, 50);
    const results: Record<string, any> = {};
    const pending: string[] = [];

    for (const raw of unique) {
      if (!isPublicIp(raw.trim())) results[raw] = unknownGeo();
      else pending.push(raw);
    }

    await pool(pending, 4, async (raw: string) => {
      const ip = canonicalIp(raw.trim());
      if (!ip) { results[raw] = unknownGeo(); return; }
      const origin = await resolveOrigin(ip);
      if (!origin) { results[raw] = unknownGeo(); return; }
      const org = origin.asns.length ? await resolveOrg(origin.asns[0]) : '';
      results[raw] = geoPayload(origin, org);
    });

    for (const raw of unique) if (!results[raw]) results[raw] = unknownGeo();

    return Response.json({ results }, {
      headers: { ...cors, 'Content-Type': 'application/json', 'Cache-Control': 'no-store' },
    });
  } catch (err: any) {
    return Response.json({ error: (err && err.message) || 'lookup failed' }, { status: 500, headers: cors });
  }
});
