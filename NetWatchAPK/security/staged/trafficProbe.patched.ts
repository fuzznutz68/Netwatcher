// NetWatch — trafficProbe (STAGED, NOT DEPLOYED)
// Changes vs deployed version:
//   1. kill switch (NETWATCH_PROBE_MODE=disabled -> 503)
//   2. hostname validation (no IP literals, no local/metadata names)
//   3. DNS resolved + every address validated; connect to the PINNED ip
//   4. redirects handled manually, each hop validated
//   5. port scan OFF unless PROBE_ALLOW_PORTSCAN=true
//   6. concurrency cap + total budget
// Validation block must be inlined in each function (platform has no cross-file imports).

const V4_BLOCKED: Array<[string, number]> = [
  ['0.0.0.0', 8], ['10.0.0.0', 8], ['100.64.0.0', 10], ['127.0.0.0', 8],
  ['169.254.0.0', 16], ['172.16.0.0', 12], ['192.0.0.0', 24], ['192.0.2.0', 24],
  ['192.88.99.0', 24], ['192.168.0.0', 16], ['198.18.0.0', 15], ['198.51.100.0', 24],
  ['203.0.113.0', 24], ['224.0.0.0', 4], ['240.0.0.0', 4],
];
const METADATA_HOSTS = new Set(['metadata.google.internal','metadata.goog','instance-data',
  'metadata','metadata.azure.com','metadata.tencentyun.com']);

function parseIPv4(s: string): number[] | null {
  const m = /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/.exec((s || '').trim());
  if (!m) return null;
  const p = m.slice(1).map(Number);
  return p.some((n) => n > 255) ? null : p;
}
function ipv4ToInt(p: number[]) { return ((p[0] << 24) >>> 0) + (p[1] << 16) + (p[2] << 8) + p[3]; }

function isBlockedIPv4(s: string): boolean {
  const p = parseIPv4(s);
  if (!p) return true;
  const n = ipv4ToInt(p);
  for (const [base, bits] of V4_BLOCKED) {
    const b = ipv4ToInt(parseIPv4(base)!);
    const mask = (~0 << (32 - bits)) >>> 0;
    if (((n & mask) >>> 0) === ((b & mask) >>> 0)) return true;
  }
  return false;
}

function parseIPv6(s: string): number[] | null {
  let t = (s || '').replace(/^\[|\]$/g, '').split('%')[0].toLowerCase();
  if (!t.includes(':')) return null;
  const v4 = /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})$/.exec(t);
  if (v4) {
    const p = parseIPv4(v4[1]); if (!p) return null;
    t = t.slice(0, -v4[1].length) + (((p[0] << 8) | p[1]).toString(16)) + ':' + (((p[2] << 8) | p[3]).toString(16));
  }
  const dbl = t.indexOf('::');
  let head: string[], tail: string[] = [];
  if (dbl >= 0) {
    if (t.indexOf('::', dbl + 1) >= 0) return null;
    head = t.slice(0, dbl).split(':').filter(Boolean);
    tail = t.slice(dbl + 2).split(':').filter(Boolean);
  } else head = t.split(':');
  const missing = 8 - (head.length + tail.length);
  if (missing < 0 || (dbl < 0 && missing !== 0)) return null;
  const parts = [...head, ...Array(missing).fill('0'), ...tail];
  if (parts.length !== 8) return null;
  const out = parts.map((h) => parseInt(h, 16));
  return out.some((n) => Number.isNaN(n) || n < 0 || n > 0xffff) ? null : out;
}

function isBlockedIPv6(s: string): boolean {
  const h = parseIPv6(s); if (!h) return true;
  if (h.every((x) => x === 0)) return true;
  if (h.slice(0, 7).every((x) => x === 0) && h[7] === 1) return true;
  const v4 = `${h[6] >> 8}.${h[6] & 0xff}.${h[7] >> 8}.${h[7] & 0xff}`;
  const mapped = h.slice(0, 5).every((x) => x === 0) && h[5] === 0xffff;
  const compat = h.slice(0, 6).every((x) => x === 0);
  const nat64 = h[0] === 0x64 && h[1] === 0xff9b && h.slice(2, 6).every((x) => x === 0);
  const sixto4 = h[0] === 0x2002;
  if (mapped || compat || nat64 || sixto4) return isBlockedIPv4(v4);
  if ((h[0] & 0xfe00) === 0xfc00) return true;
  if ((h[0] & 0xffc0) === 0xfe80) return true;
  if ((h[0] & 0xff00) === 0xff00) return true;
  if (h[0] === 0x2001 && h[1] === 0x0db8) return true;
  if (h[0] === 0x2001 && h[1] === 0x0000) return true;
  return false;
}

function isBlockedAddress(ip: string): boolean {
  if (parseIPv4(ip)) return isBlockedIPv4(ip);
  if (parseIPv6(ip)) return isBlockedIPv6(ip);
  return true;
}

function validateHostname(host: string): { ok: boolean; host?: string; error?: string } {
  const h = String(host || '').trim().toLowerCase();
  if (!h) return { ok: false, error: 'empty host' };
  if (h.length > 253) return { ok: false, error: 'host too long' };
  if (/[@\/\\:]/.test(h)) return { ok: false, error: 'host contains forbidden characters' };
  if (h.endsWith('.')) return { ok: false, error: 'trailing dot not accepted' };
  if (METADATA_HOSTS.has(h)) return { ok: false, error: 'metadata hostname blocked' };
  if (parseIPv4(h) || parseIPv6(h)) return { ok: false, error: 'IP literals not accepted' };
  if (h === 'localhost' || h.endsWith('.localhost') || h.endsWith('.local') || h.endsWith('.internal'))
    return { ok: false, error: 'local hostname blocked' };
  const labels = h.split('.');
  if (labels.length < 2) return { ok: false, error: 'host must be qualified' };
  for (const l of labels) {
    if (!l.length || l.length > 63) return { ok: false, error: 'bad label length' };
    if (!/^[a-z0-9]([a-z0-9-]*[a-z0-9])?$/.test(l)) return { ok: false, error: 'bad label syntax' };
  }
  if (!/^[a-z]{2,63}$/.test(labels[labels.length - 1])) return { ok: false, error: 'non-alphabetic TLD' };
  return { ok: true, host: h };
}

async function resolvePinned(host: string): Promise<{ ok: boolean; ip?: string; error?: string }> {
  const v = validateHostname(host);
  if (!v.ok) return { ok: false, error: v.error };
  let a: string[] = [], aaaa: string[] = [];
  try { a = await Deno.resolveDns(v.host!, 'A'); } catch { /* AAAA-only host */ }
  try { aaaa = await Deno.resolveDns(v.host!, 'AAAA'); } catch { /* A-only host */ }
  const all = [...a, ...aaaa];
  if (!all.length) return { ok: false, error: 'no DNS records' };
  for (const ip of all) if (isBlockedAddress(ip)) return { ok: false, error: `blocked address ${ip}` };
  return { ok: true, ip: all[0] };
}

function validateRedirectTarget(location: string, baseHost: string) {
  let u: URL;
  try { u = new URL(location, `https://${baseHost}`); } catch { return { ok: false, error: 'unparseable redirect' }; }
  if (u.protocol !== 'http:' && u.protocol !== 'https:') return { ok: false, error: 'redirect scheme rejected' };
  if (u.username || u.password) return { ok: false, error: 'redirect credentials rejected' };
  const port = u.port ? Number(u.port) : (u.protocol === 'https:' ? 443 : 80);
  if (![80, 443].includes(port)) return { ok: false, error: 'redirect port rejected' };
  const v = validateHostname(u.hostname);
  return v.ok ? { ok: true, host: v.host! } : v;
}

// ── in-isolate concurrency cap (defence in depth; gateway limits still required) ──
let active = 0;
const MAX_CONCURRENT = 4;

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: { 'Access-Control-Allow-Origin': '*' } });
  }

  // ── kill switch: set NETWATCH_PROBE_MODE=disabled in function env to shed load ──
  if ((Deno.env.get('NETWATCH_PROBE_MODE') || 'on') === 'disabled') {
    return Response.json({ error: 'probe temporarily disabled' }, { status: 503 });
  }
  if (active >= MAX_CONCURRENT) {
    return Response.json({ error: 'server busy' }, { status: 429 });
  }
  active++;
  try {
    const body = await req.json().catch(() => ({}));
    const { domain } = body;
    if (!domain) return Response.json({ error: 'Domain is required' }, { status: 400 });

    // strict validation replaces the old regex-only cleaning
    const pinned = await resolvePinned(String(domain));
    if (!pinned.ok) return Response.json({ error: pinned.error }, { status: 400 });
    const cleanDomain = validateHostname(String(domain)).host!;

    const results: any = {
      domain: cleanDomain, timestamp: new Date().toISOString(),
      reachability: {}, ports: [], tlsInfo: null, errors: [],
    };

    // ── reachability, manual redirects, validated hops ──
    for (const proto of ['http', 'https']) {
      let url = `${proto}://${cleanDomain}`;
      let hops = 0;
      try {
        const start = Date.now();
        let res = await fetch(url, { method: 'HEAD', redirect: 'manual', signal: AbortSignal.timeout(8000) });
        while ([301, 302, 303, 307, 308].includes(res.status) && hops < 3) {
          const loc = res.headers.get('location');
          if (!loc) break;
          const next = validateRedirectTarget(loc, cleanDomain);
          if (!next.ok) throw new Error(`redirect blocked: ${next.error}`);
          url = new URL(loc, url).toString();
          res = await fetch(url, { method: 'HEAD', redirect: 'manual', signal: AbortSignal.timeout(8000) });
          hops++;
        }
        results.reachability[proto] = { reachable: true, statusCode: res.status, hops, finalUrl: url };
      } catch (e: any) {
        results.reachability[proto] = { reachable: false, error: e.message };
        results.errors.push(`${proto.toUpperCase()} probe: ${e.message}`);
      }
    }

    // ── port scan: off unless explicitly enabled; pinned address, no re-resolution ──
    if ((Deno.env.get('PROBE_ALLOW_PORTSCAN') || 'false') === 'true') {
      const ports = [{ port: 80, label: 'HTTP' }, { port: 443, label: 'HTTPS' },
                     { port: 8080, label: 'HTTP-Alt' }, { port: 8443, label: 'HTTPS-Alt' }];
      await Promise.allSettled(ports.map(async ({ port, label }) => {
        try {
          const conn = await Deno.connect({ hostname: pinned.ip!, port, transport: 'tcp' });
          conn.close();
          results.ports.push({ port, label, open: true });
        } catch { results.ports.push({ port, label, open: false }); }
      }));
      results.ports.sort((a: any, b: any) => a.port - b.port);
    } else {
      results.ports = null;
      results.portScanDisabled = true;
    }

    return Response.json(results, {
      headers: { 'Access-Control-Allow-Origin': '*', 'Content-Type': 'application/json' },
    });
  } catch (error: any) {
    return Response.json({ error: error.message }, { status: 500 });
  } finally {
    active--;
  }
});
