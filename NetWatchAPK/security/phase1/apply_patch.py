#!/usr/bin/env python3
"""Phase 1 patch generator — deterministic, idempotent, reviewable.

Builds patched/ from baseline/ + nwhttp.mjs. Fails loudly if an anchor is
missing, so a drifted baseline can never produce a silently wrong patch.
"""
import re, pathlib, sys

HERE = pathlib.Path(__file__).resolve().parent
BASE, PATCHED = HERE / "baseline", HERE / "patched"

MODULE = (HERE / "nwhttp.mjs").read_text(encoding="utf-8")
BLOCK = re.sub(r"^export ", "", MODULE, flags=re.M)

GLUE_HEAD = """
// ── Phase 1 glue (generated) ────────────────────────────────────────────────
const nwGetenv = (k) => { try { return Deno.env.get(k); } catch (_) { return undefined; } };
"""

GLUE_TAIL = """
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
"""

def insert_after(src, anchor, text, label):
    i = src.find(anchor)
    if i < 0:
        sys.exit(f"FATAL: anchor not found ({label}): {anchor[:60]!r}")
    j = i + len(anchor)
    return src[:j] + text + src[j:]

def sub_once(src, old, new, label):
    if src.count(old) != 1:
        sys.exit(f"FATAL: expected exactly 1 occurrence ({label}), found {src.count(old)}")
    return src.replace(old, new, 1)

def sub_regex(src, pattern, repl, label):
    out, n = re.subn(pattern, repl, src, count=1, flags=re.S)
    if n != 1:
        sys.exit(f"FATAL: regex anchor missed ({label})")
    return out

HEADER = (
    "\n// ══ NetWatch Phase 1 inline block (generated from security/phase1/nwhttp.mjs)\n"
    "// Do not edit here; edit the module and re-run apply_patch.py.\n"
)

def header_block(consts):
    return HEADER + BLOCK + GLUE_HEAD + consts + GLUE_TAIL

# ─────────────────────────────── domainIntel ────────────────────────────────
di = (BASE / "domainIntel.ts").read_text(encoding="utf-8")
orig_len = len(di)

di = insert_after(di, "// @ts-nocheck\n", header_block(
    "const NW_METHODS = 'POST, OPTIONS';\n"
    "// Ops knob, clamped: 12 s default sits below the 20 s client read timeout.\n"
    "const nwDeadlineMs = () => Math.min(20000, Math.max(1000, "
    "Number(nwGetenv('NW_DEADLINE_MS')) || 12000));\n"
    "const NW_CRTSH_MAX_BYTES = 400000;         // strict cap, enforced while reading\n"
    "const NW_CRTSH_MAX_ROWS = 2000;\n"
    "// crt.sh gets its own sub-budget: a hung CT query must never eat the whole\n"
    "// invocation deadline and starve the rest of the scan.\n"
    "const NW_CRTSH_MAX_MS = 6000;\n"), "domainIntel: block")

# one implementation of the capped reader and the guarded GET
di = sub_regex(di, r"async function readCapped\(res, maxBytes\) \{.*?\n\}\n",
               "async function readCapped(res, maxBytes) {\n"
               "  return nwReadCapped(res, maxBytes);\n}\n", "domainIntel: readCapped")
di = sub_regex(di, r"async function safeGet\(url, opts\) \{.*?\n  throw new Error\('too_many_redirects'\);\n\}\n",
               "async function safeGet(url, opts) {\n"
               "  return nwSafeGet(url, {\n"
               "    ...opts,\n"
               "    fetchImpl: opts.fetchImpl,\n"
               "    resolve: opts.resolve,\n"
               "    validateHostname,\n"
               "    checkResolved,\n"
               "    readCapped,\n"
               "    signal: opts.signal,\n"
               "  });\n}\n"
               "", "domainIntel: safeGet")

di = sub_once(di, """Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: { 'Access-Control-Allow-Origin': '*' } });
  }

  try {""",
"""Deno.serve(async (req) => {
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
  try {""", "domainIntel: handler head")

di = sub_once(di, "      deep: isDeep,\n", "      deep: isDeep,\n      truncated: false,\n", "domainIntel: results.truncated")

di = sub_once(di, """      const d = await r.json();
      return (d.Answer || []) as any[];""",
"""      // The DoH body is capped like every other network read: a hostile or
      // broken resolver cannot make us buffer an unbounded JSON document.
      const jr = await nwReadJson(r, 262144);
      if (!jr.ok) throw new Error('dns-json: ' + jr.reason);
      const d: any = jr.value;
      return (d.Answer || []) as any[];""", "domainIntel: capped DoH JSON")

di = sub_once(di, "{ headers: { Accept: 'application/dns-json' }, signal: AbortSignal.timeout(7000) }",
              "{ headers: { Accept: 'application/dns-json' },\n"
              "          signal: nwMergeSignals([AbortSignal.timeout(7000), dl.signal]) }", "domainIntel: fetchDns signal")

di = sub_once(di, """      const r = await fetch(
        `https://crt.sh/?q=%25.${cleanDomain}&output=json`,
        { signal: AbortSignal.timeout(20000) }
      );
      if (r.ok) {
        const text = await r.text();
        if (text.trim().startsWith('[')) {
          const rows = JSON.parse(text);""",
"""      if (!nwGuard()) throw new Error('deadline');
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
          if (!Array.isArray(rows)) rows = [];""", "domainIntel: crt.sh cap")

di = sub_once(di, "          for (const row of rows) {",
              "          for (const row of rows.slice(0, NW_CRTSH_MAX_ROWS)) {", "domainIntel: crt.sh rows")

di = sub_regex(di, r"    await Promise\.allSettled\(\n      commonPrefixes\.map\(async \(prefix\) => \{.*?\n      \}\)\n    \);\n",
"""    if (nwGuard()) {
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
""", "domainIntel: prefix scan guard")

di = sub_once(di, "    for (let i = 0; i < Math.min(allSubs.length, 200); i += BATCH) {",
"""    for (let i = 0; i < Math.min(allSubs.length, 200); i += BATCH) {
      if (dl.expired()) { nwTruncated = true; results.errors.push('deadline: subdomain scan stopped'); break; }""",
              "domainIntel: sub loop deadline")

di = sub_once(di, "    try {\n      const UAs = { ",
              "    try {\n      if (!nwGuard()) throw new Error('deadline');\n      const UAs = { ", "domainIntel: page fetch guard")

# Make cancellation and failed page fetches observable instead of dropping them
# into Promise.allSettled's result array.
di = sub_once(di, "      for (const p of htmlPages) {\n",
              "      if (dl.expired()) {\n"
              "        nwTruncated = true;\n"
              "        results.errors.push('deadline: page fetch aborted');\n"
              "      }\n"
              "      for (const p of htmlPages) {\n"
              "        if (p.status === 'rejected') {\n"
              "          results.errors.push('page fetch: ' + ((p.reason && p.reason.message) || 'failed'));\n"
              "        }\n", "domainIntel: page fetch observability")

di = di.replace("        safeGet(`https://${cleanDomain}/`, { fetchImpl: fetch, resolve: nwResolve, timeoutMs: 9000, maxHops: 3 }),",
                "        safeGet(`https://${cleanDomain}/`, { fetchImpl: fetch, resolve: nwResolve, timeoutMs: 9000, maxHops: 3, signal: dl.signal }),")
di = di.replace("        safeGet(`https://www.${cleanDomain}/`, { fetchImpl: fetch, resolve: nwResolve, timeoutMs: 9000, maxHops: 3 }),",
                "        safeGet(`https://www.${cleanDomain}/`, { fetchImpl: fetch, resolve: nwResolve, timeoutMs: 9000, maxHops: 3, signal: dl.signal }),")

di = sub_once(di, """    return Response.json(results, {
      headers: { 'Access-Control-Allow-Origin': '*', 'Content-Type': 'application/json' }
    });""",
"""    results.truncated = results.truncated || nwTruncated;
    return Response.json(results, {
      headers: { ...nwCors(req), 'Content-Type': 'application/json', 'Cache-Control': 'no-store' }
    });""", "domainIntel: ok response")

di = sub_once(di, """  } catch (err: any) {
    return Response.json({ error: err.message }, { status: 500 });
  }
});""",
"""  } catch (err) {
    return Response.json({ error: err.message },
      { status: 500, headers: { ...nwCors(req), 'Cache-Control': 'no-store' } });
  } finally {
    dl.close();
  }
});""", "domainIntel: catch + finally")

(PATCHED / "domainIntel.ts").write_text(di, encoding="utf-8")
print(f"domainIntel.ts  {orig_len} → {len(di)} bytes")

# ───────────────────────────────── geoIp ────────────────────────────────────
g = (BASE / "geoIp.ts").read_text(encoding="utf-8"); orig_len = len(g)
g = insert_after(g, "// @ts-nocheck\n", header_block("const NW_METHODS = 'POST, OPTIONS';\n"), "geoIp: block")
g = sub_once(g, """Deno.serve(async (req: Request) => {
  const cors = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
  };
  if (req.method === 'OPTIONS') return new Response(null, { headers: cors });""",
"""Deno.serve(async (req: Request) => {
  // Phase 1: explicit CORS, JSON-only bodies (Android sends application/json).
  const cors = nwCors(req);
  if (req.method === 'OPTIONS') return nwPreflightFor(req);
  if (!nwMethodAllowed(req.method, NW_METHODS)) return nwMethodNotAllowed(req);
  if (!nwContentTypeAccepted(req.method, req.headers.get('content-type')))
    return nwUnsupportedMediaType(req);""", "geoIp: handler head")
g = sub_once(g, """  let d;
  try { d = await r.json(); } catch { return { ok: false, reason: 'bad-json' }; }""",
"""  // DoH bodies go through the capped reader; a truncated body is a failure.
  const jr = await nwReadJson(r, 262144);
  if (!jr.ok) return { ok: false, reason: jr.reason };
  const d: any = jr.value;""", "geoIp: capped DoH JSON")
(PATCHED / "geoIp.ts").write_text(g, encoding="utf-8")
print(f"geoIp.ts        {orig_len} → {len(g)} bytes")

# ──────────────────────────────── ipWhois ───────────────────────────────────
w = (BASE / "ipWhois.ts").read_text(encoding="utf-8"); orig_len = len(w)
w = insert_after(w, "// @ts-nocheck\n", header_block("const NW_METHODS = 'GET, POST, OPTIONS';\n"), "ipWhois: block")
w = sub_once(w, """Deno.serve(async (req: Request) => {
  const cors = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
  };
  if (req.method === 'OPTIONS') return new Response(null, { headers: cors });""",
"""Deno.serve(async (req: Request) => {
  // Phase 1: explicit CORS. GET stays bodyless and exempt from the JSON gate,
  // which is what the shipped Android client uses: GET /ipWhois?ip=...
  const cors = nwCors(req);
  if (req.method === 'OPTIONS') return nwPreflightFor(req);
  if (!nwMethodAllowed(req.method, NW_METHODS)) return nwMethodNotAllowed(req);
  if (!nwContentTypeAccepted(req.method, req.headers.get('content-type')))
    return nwUnsupportedMediaType(req);""", "ipWhois: handler head")
w = sub_once(w, """  let d;
  try { d = await r.json(); } catch { return { ok: false, reason: 'bad-json' }; }""",
"""  // DoH bodies go through the capped reader; a truncated body is a failure.
  const jr = await nwReadJson(r, 262144);
  if (!jr.ok) return { ok: false, reason: jr.reason };
  const d: any = jr.value;""", "ipWhois: capped DoH JSON")

w = sub_once(w, "    const text = (await r.text()).slice(0, 200000);",
"""    // RDAP was previously read in full and sliced afterwards, which buffered the
    // whole body first. It is now capped while streaming.
    const rdapBody = await nwReadCapped(r, 200000);
    if (rdapBody.unreadable || rdapBody.truncated)
      return { error: 'rdap: response too large' };
    const text = rdapBody.text;""", "ipWhois: capped RDAP read")
(PATCHED / "ipWhois.ts").write_text(w, encoding="utf-8")
print(f"ipWhois.ts      {orig_len} → {len(w)} bytes")
print("patch generated OK")
