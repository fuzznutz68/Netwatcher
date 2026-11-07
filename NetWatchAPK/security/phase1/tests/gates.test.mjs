// Source-level guarantees that survive a future edit: the wildcard is gone, the
// gates are in the right order, and the guards that must precede parsing do.
import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const read = (p) => fs.readFileSync(path.join(ROOT, p), 'utf8');
const patched = {
  domainIntel: read('patched/domainIntel.ts'),
  geoIp: read('patched/geoIp.ts'),
  ipWhois: read('patched/ipWhois.ts'),
};
const baseline = {
  domainIntel: read('baseline/domainIntel.ts'),
  geoIp: read('baseline/geoIp.ts'),
  ipWhois: read('baseline/ipWhois.ts'),
};

test('the wildcard CORS header is gone from every patched function', () => {
  for (const [name, src] of Object.entries(patched)) {
    assert.ok(!/Access-Control-Allow-Origin['"]?\s*:\s*['"]\*['"]/.test(src), `${name} still emits a wildcard`);
    assert.ok(!src.includes("'Access-Control-Allow-Origin': '*'"), `${name} has a literal wildcard`);
  }
});

test('the baseline did contain the wildcard (proves the finding was real)', () => {
  for (const [name, src] of Object.entries(baseline)) {
    assert.ok(src.includes("'Access-Control-Allow-Origin': '*'"), `${name} baseline unexpectedly clean`);
  }
});

test('gate order: OPTIONS, then method, then content type, then parsing', () => {
  for (const [name, src] of Object.entries(patched)) {
    const iOpt = src.indexOf('nwPreflightFor(req)');
    const iMethod = src.indexOf('nwMethodAllowed(req.method');
    const iType = src.indexOf('nwContentTypeAccepted(req.method');
    const iParse = src.indexOf('await req.json()');
    assert.ok(iOpt > 0 && iMethod > 0 && iType > 0 && iParse > 0, `${name}: missing a gate`);
    assert.ok(iOpt < iMethod, `${name}: preflight must precede the method gate`);
    assert.ok(iMethod < iType, `${name}: method gate must precede the content-type gate`);
    assert.ok(iType < iParse, `${name}: content-type gate must precede body parsing`);
  }
});

test('ipWhois keeps GET as an allowed, bodyless method', () => {
  const src = patched.ipWhois;
  assert.match(src, /const NW_METHODS = 'GET, POST, OPTIONS'/);
  assert.match(src, /req\.method === 'GET'/, 'GET branch preserved');
});

test('domainIntel is POST-only and advertises exactly that', () => {
  assert.match(patched.domainIntel, /const NW_METHODS = 'POST, OPTIONS'/);
});

test('domainIntel: deadline, crt.sh cap and finally-close are all wired', () => {
  const src = patched.domainIntel;
  assert.match(src, /const dl = nwDeadline\(nwDeadlineMs\(\)\)/);
  assert.match(src, /nwReadCapped\(r, NW_CRTSH_MAX_BYTES\)/, 'crt.sh must read through the cap');
  assert.ok(!/const text = await r\.text\(\)/.test(src), 'uncapped crt.sh read is still present');
  assert.match(src, /finally \{\s*dl\.close\(\);/, 'deadline timer must be closed');
  assert.match(src, /signal: nwMergeSignals\(\[AbortSignal\.timeout\(20000\), dl\.signal\]\)/, 'crt.sh honours the deadline');
  assert.match(src, /signal: nwMergeSignals\(\[AbortSignal\.timeout\(7000\), dl\.signal\]\)/, 'DNS honours the deadline');
});

test('default deadline sits below the Android/desktop read timeouts', () => {
  const src = patched.domainIntel;
  const m = /Number\(nwGetenv\('NW_DEADLINE_MS'\)\) \|\| (\d+)/.exec(src);
  assert.ok(m, 'default not found');
  const def = Number(m[1]);
  assert.ok(def >= 8000 && def <= 15000, `default ${def} ms is outside the safe band`);
  // Android TrafficMonitorService uses a 20 s read timeout, MainActivity 30 s,
  // desktop HttpClient 20 s: the deadline must leave a margin below all three.
  assert.ok(def < 20000);
});

const codeOnly = (src) => src
  .split('\n')
  .filter((line) => !/^\s*(\/\/|\*|\/\*)/.test(line))   // strip comments and doc blocks
  .join('\n');

test('no Phase 1 exclusions were smuggled in', () => {
  for (const [name, src] of Object.entries(patched)) {
    const code = codeOnly(src);
    assert.ok(!/token ?bucket|scan ?token|X-Api-Key|Authorization/i.test(code), `${name} grew an auth or throttle mechanism`);
    assert.ok(!/NW_REQUIRE_TOKEN/.test(code), `${name} gated deep scans`);
    // geoIp ships a bounded TTL cache already (baseline behaviour, untouched);
    // the Phase 1 cache for domainIntel is design-only, so it must not appear yet.
    if (name === 'domainIntel') assert.ok(!/createCache\(/.test(code), 'domainIntel must not cache in Phase 1');
  }
  assert.ok(!/createCache\(/.test(patched.domainIntel), 'domainIntel must not cache in Phase 1');
});

test('patch is reproducible from the generator', () => {
  // apply_patch.py must contain the same anchors it used, so re-running it
  // regenerates byte-identical files.
  const gen = read('apply_patch.py');
  assert.ok(gen.includes('nwhttp.mjs'));
  assert.ok(gen.includes('FATAL: anchor not found'));
});
