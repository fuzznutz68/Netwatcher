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

export function parseIPv4(s) {
  if (typeof s !== 'string') return null;
  const m = /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/.exec(s.trim());
  if (!m) return null;
  const p = m.slice(1).map(Number);
  if (p.some((n) => n > 255)) return null;
  return p;
}

export function ipv4ToInt(p) {
  return ((p[0] << 24) >>> 0) + (p[1] << 16) + (p[2] << 8) + p[3];
}

export function isBlockedIPv4(str) {
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
export function parseIPv6(s) {
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

export function isBlockedIPv6(str) {
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

export function isBlockedAddress(ip) {
  if (parseIPv4(ip)) return isBlockedIPv4(ip);
  if (parseIPv6(ip)) return isBlockedIPv6(ip);
  return true;                                                 // not an IP at all
}

/** Strict hostname: RFC1123 labels, no IP literal, no scheme, no port, no userinfo. */
export function validateHostname(host) {
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

export function normalizeDomain(raw) {
  if (typeof raw !== 'string') return { ok: false, error: 'domain is required' };
  let s = raw.trim();
  if (/^[a-z][a-z0-9+.-]*:\/\//i.test(s)) return { ok: false, error: 'scheme not accepted; send a bare hostname' };
  s = s.replace(/\/.*$/, '');
  return validateHostname(s);
}

/** Every resolved address must pass; one bad record rejects the host. */
export function checkResolved(records) {
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
export async function resolveAndPin(host, resolver) {
  const v = validateHostname(host);
  if (!v.ok) return v;
  let a = [], aaaa = [];
  try { a = await resolver(v.host, 'A'); } catch { /* may be AAAA-only */ }
  try { aaaa = await resolver(v.host, 'AAAA'); } catch { /* may be A-only */ }
  const all = [...(a || []), ...(aaaa || [])];
  const chk = checkResolved(all);
  if (!chk.ok) return chk;
  return { ok: true, host: v.host, ips: chk.ips, pinned: chk.ips[0] };
}

/** Redirect target validation. Rejects scheme changes, ports and blocked hosts. */
export function validateRedirect(location, currentHost, allowedPorts = [80, 443]) {
  let u;
  try { u = new URL(location, `https://${currentHost}`); }
  catch { return { ok: false, error: 'unparseable redirect' }; }
  if (u.protocol !== 'https:' && u.protocol !== 'http:')
    return { ok: false, error: 'redirect scheme rejected' };
  if (u.username || u.password) return { ok: false, error: 'redirect with credentials rejected' };
  const port = u.port ? Number(u.port) : (u.protocol === 'https:' ? 443 : 80);
  if (!allowedPorts.includes(port)) return { ok: false, error: 'redirect port rejected' };
  const v = validateHostname(u.hostname);
  if (!v.ok) return v;
  return { ok: true, host: v.host, port, url: u.toString() };
}

/** Best-effort in-isolate limiter. Not a substitute for gateway rate limiting. */
export function createLimiter({ maxConcurrent = 4, perMinute = 30, burst = 10 } = {}) {
  let active = 0;
  const buckets = new Map();
  return {
    async run(fn) {
      if (active >= maxConcurrent) return { ok: false, status: 429, error: 'server busy' };
      active++;
      try { return await fn(); } finally { active--; }
    },
    take(clientKey, now = Date.now()) {
      const b = buckets.get(clientKey) || { tokens: burst, ts: now };
      const refill = ((now - b.ts) / 60000) * perMinute;
      b.tokens = Math.min(burst, b.tokens + refill);
      b.ts = now;
      if (b.tokens < 1) { buckets.set(clientKey, b); return false; }
      b.tokens -= 1;
      if (buckets.size > 10000) buckets.clear();     // bounded memory
      buckets.set(clientKey, b);
      return true;
    },
    get active() { return active; },
  };
}
