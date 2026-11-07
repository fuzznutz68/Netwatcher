// End-to-end tests: the *transpiled patched handlers* run under Node with
// stubbed Deno + fetch. This is the shipped code path, not a reimplementation.
import test from 'node:test';
import assert from 'node:assert/strict';
import {
  installDenoStub, installFetch, loadHandler, json, dnsOk, dnsEmpty,
  aRecord, txtRecord, dnsRoute, anyDns, crtRoute, pageRoute, hang, countingStream,
} from './harness.mjs';

const ANCHOR = 'https://superagent-cfb25b3e.base44.app/functions';

function baseDomainRoutes({ pageHtml = '<html><script src="https://cdn.tracker.test/a.js"></script></html>', crt = () => json([]) } = {}) {
  return [
    dnsRoute('example.com', 'A', () => dnsOk([aRecord('93.184.216.34')])),
    dnsRoute('www.example.com', 'A', () => dnsOk([aRecord('93.184.216.34')])),
    anyDns(() => dnsEmpty()),
    crtRoute(crt),
    pageRoute('example.com', () => new Response(pageHtml, { status: 200 })),
    pageRoute('www.example.com', () => new Response('', { status: 200 })),
  ];
}

async function call(handler, path, { method = 'POST', headers = {}, body, origin } = {}) {
  const h = { ...headers };
  if (origin) h.origin = origin;
  return handler(new Request(ANCHOR + path, { method, headers: h, body }));
}

// ── normal requests ─────────────────────────────────────────────────────────
test('domainIntel: normal Android request succeeds and keeps its payload shape', async () => {
  delete process.env.NW_ALLOWED_ORIGINS;
  process.env.NW_DEADLINE_MS = '12000';
  installDenoStub();
  const fetchCalls = installFetch(baseDomainRoutes());
  const handler = await loadHandler('domainIntel');

  // exactly what MainActivity.postJson sends: no Origin, no Accept, bare JSON CT
  const res = await call(handler, '/domainIntel', {
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ domain: 'example.com' }),
  });
  const text = await res.text();
  assert.equal(res.status, 200, text);
  const d = JSON.parse(text);

  assert.equal(d.domain, 'example.com');
  assert.deepEqual(d.ipv4, ['93.184.216.34']);
  assert.equal(d.deep, false);
  assert.equal(d.truncated, false);
  assert.deepEqual(d.errors, [], 'a clean scan reports no errors');
  assert.ok(text.includes('cdn.tracker.test'), 'page host extraction still works');
  // required response headers
  assert.equal(res.headers.get('access-control-allow-origin'), null, 'no CORS grant by default');
  assert.equal(res.headers.get('cache-control'), 'no-store');
  assert.equal(res.headers.get('vary'), 'Origin');
  assert.ok(fetchCalls.length > 0);
});

test('domainIntel: deep=true still works (no gating added in Phase 1)', async () => {
  installDenoStub();
  installFetch(baseDomainRoutes());
  const handler = await loadHandler('domainIntel');
  const res = await call(handler, '/domainIntel', {
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ domain: 'example.com', deep: true }),
  });
  assert.equal(res.status, 200);
  assert.equal((await res.json()).deep, true);
});

// ── malformed requests ──────────────────────────────────────────────────────
test('domainIntel: rejects non-JSON content types with 415', async () => {
  installDenoStub(); installFetch(baseDomainRoutes());
  const handler = await loadHandler('domainIntel');
  for (const ct of ['text/plain', 'application/x-www-form-urlencoded', '', 'application/jsonp']) {
    const res = await call(handler, '/domainIntel', { headers: ct ? { 'content-type': ct } : {}, body: '{"domain":"example.com"}' });
    assert.equal(res.status, 415, `content-type ${JSON.stringify(ct)}`);
    assert.equal(res.headers.get('access-control-allow-origin'), null);
  }
});

test('domainIntel: rejects disallowed methods with 405 and names the allowance', async () => {
  installDenoStub(); installFetch(baseDomainRoutes());
  const handler = await loadHandler('domainIntel');
  for (const method of ['PUT', 'DELETE', 'GET', 'PATCH']) {
    const res = await call(handler, '/domainIntel', { method, headers: { 'content-type': 'application/json' } });
    assert.equal(res.status, 405, method);
    assert.equal(res.headers.get('allow'), 'POST, OPTIONS');
  }
});

test('domainIntel: malformed JSON body yields a 400, not a 500', async () => {
  installDenoStub(); installFetch(baseDomainRoutes());
  const handler = await loadHandler('domainIntel');
  const res = await call(handler, '/domainIntel', {
    headers: { 'content-type': 'application/json' }, body: '{not json',
  });
  assert.equal(res.status, 400);
  assert.match((await res.json()).error, /Domain is required/);
});

test('domainIntel: private and metadata targets are still refused locally', async () => {
  installDenoStub(); installFetch(baseDomainRoutes());
  const handler = await loadHandler('domainIntel');
  for (const domain of ['127.0.0.1', 'http://169.254.169.254/', 'metadata.google.internal', 'localhost', 'example.com:8080']) {
    const res = await call(handler, '/domainIntel', {
      headers: { 'content-type': 'application/json' }, body: JSON.stringify({ domain }),
    });
    assert.equal(res.status, 400, domain);
  }
});

test('OPTIONS: preflight answers 204 with explicit methods and no wildcard', async () => {
  installDenoStub(); installFetch(baseDomainRoutes());
  const handler = await loadHandler('domainIntel');
  const res = await call(handler, '/domainIntel', { method: 'OPTIONS', origin: 'https://evil.example' });
  assert.equal(res.status, 204);
  assert.equal(res.headers.get('access-control-allow-origin'), null);
  assert.equal(res.headers.get('access-control-allow-methods'), 'POST, OPTIONS');
});

// ── oversized response ──────────────────────────────────────────────────────
test('crt.sh: oversized response is cut off at the cap while reading', async () => {
  installDenoStub();
  const { counter, response } = countingStream(2_000_000);
  installFetch(baseDomainRoutes({ crt: () => response }));
  const handler = await loadHandler('domainIntel');

  const res = await call(handler, '/domainIntel', {
    headers: { 'content-type': 'application/json' }, body: JSON.stringify({ domain: 'example.com' }),
  });
  const d = await res.json();
  assert.equal(res.status, 200, 'truncation must not fail the request');
  assert.equal(d.truncated, true);
  assert.ok(d.errors.some((e) => e.includes('crt.sh: response truncated')), JSON.stringify(d.errors));
  assert.equal(counter.cancelled, true, 'stream must be cancelled, not drained');
  // Delivered bytes must stop exactly at the cap. The stream itself may run a
  // few chunks ahead of the consumer (ReadableStream pull-ahead), so the tight
  // assertion is on what our code accepted plus a bounded overshoot, never on
  // the whole 2 MB body having been downloaded.
  assert.equal(counter.pulled < 2_000_000 / 2, true,
    `downloaded ${counter.pulled} of 2000000 bytes before cancelling`);
  assert.ok(counter.pulled <= 400_000 + 16 * 65_536,
    `pull-ahead exceeded one buffer window: ${counter.pulled}`);
  assert.ok(d.ipv4.length > 0, 'the rest of the scan still completes');
});

// ── timeouts and deadline ───────────────────────────────────────────────────
test('deadline: a hanging subrequest is cancelled and partial results returned', async () => {
  process.env.NW_DEADLINE_MS = '1000';
  installDenoStub();
  installFetch([
    dnsRoute('example.com', 'A', () => dnsOk([aRecord('93.184.216.34')])),
    anyDns(() => dnsEmpty()),
    crtRoute(() => json([])),
    pageRoute('example.com', hang),
    pageRoute('www.example.com', hang),
  ]);
  const handler = await loadHandler('domainIntel');

  // The deadline timer is unref'd (it must never hold the runtime open), so the
  // test process needs its own keepalive while a fetch hangs on purpose.
  const keepAlive = setInterval(() => {}, 5);
  const started = Date.now();
  const res = await call(handler, '/domainIntel', {
    headers: { 'content-type': 'application/json' }, body: JSON.stringify({ domain: 'example.com' }),
  });
  const elapsed = Date.now() - started;
  const d = await res.json();

  assert.equal(res.status, 200);
  assert.equal(d.truncated, true);
  assert.ok(d.errors.some((e) => e.startsWith('deadline:')), JSON.stringify(d.errors));
  assert.ok(elapsed < 3000, `deadline not enforced: ${elapsed} ms`);
  clearInterval(keepAlive);
  process.env.NW_DEADLINE_MS = '12000';
});

test('timeout: a rejecting page fetch is recorded, request still succeeds', async () => {
  installDenoStub();
  installFetch([
    dnsRoute('example.com', 'A', () => dnsOk([aRecord('93.184.216.34')])),
    anyDns(() => dnsEmpty()),
    crtRoute(() => json([])),
    pageRoute('example.com', () => { throw new Error('The operation was aborted'); }),
    pageRoute('www.example.com', () => { throw new Error('The operation was aborted'); }),
  ]);
  const handler = await loadHandler('domainIntel');
  const res = await call(handler, '/domainIntel', {
    headers: { 'content-type': 'application/json' }, body: JSON.stringify({ domain: 'example.com' }),
  });
  assert.equal(res.status, 200);
  const d = await res.json();
  assert.ok(d.errors.some((e) => e.includes('page fetch:')), JSON.stringify(d.errors));
  assert.deepEqual(d.ipv4, ['93.184.216.34'], 'DNS results survive a page fetch failure');
});

// ── capped reads inside the subrequests ─────────────────────────────────────
test('domainIntel: an oversized DoH body is rejected, the scan still completes', async () => {
  installDenoStub();
  const huge = () => json(Array.from({ length: 40_000 }, (_, i) => ({ data: `1.2.3.${i % 255}` })));
  installFetch([
    { match: (u) => u.startsWith('https://cloudflare-dns.com/dns-query') && u.includes('name=example.com'), respond: huge },
    anyDns(() => dnsEmpty()),
    crtRoute(() => json([])),
    pageRoute('example.com', () => new Response('', { status: 200 })),
    pageRoute('www.example.com', () => new Response('', { status: 200 })),
  ]);
  const handler = await loadHandler('domainIntel');
  const res = await call(handler, '/domainIntel', {
    headers: { 'content-type': 'application/json' }, body: JSON.stringify({ domain: 'example.com' }),
  });
  assert.equal(res.status, 200, 'a hostile resolver must not fail the request');
  const d = await res.json();
  assert.ok(d.errors.some((e) => e.includes('dns-json: too-large')), JSON.stringify(d.errors.slice(0, 4)));
});

test('ipWhois: an oversized RDAP body is refused by the cap, lookup degrades cleanly', async () => {
  installDenoStub();
  installFetch([
    dnsRoute('8.8.8.8.origin.asn.cymru.com', 'TXT', () => dnsOk([txtRecord('15169 | 8.8.8.0/24 | US | arin | 1992-12-01')])),
    dnsRoute('15169.asn.cymru.com', 'TXT', () => dnsOk([txtRecord('15169 | US | arin | 2000-03-30 | GOOGLE - Google LLC, US')])),
    anyDns(() => dnsEmpty()),
    { match: (u) => u.startsWith('https://rdap.arin.net/'),
      respond: () => json({ name: 'GOGL', pad: 'x'.repeat(400_000), entities: [] }) },
  ]);
  const handler = await loadHandler('ipWhois');
  const res = await call(handler, '/ipWhois?ip=8.8.8.8', { method: 'GET' });
  assert.equal(res.status, 200);
  const d = await res.json();
  assert.equal(d.ip, '8.8.8.8');
  assert.ok(!/GOGL/.test(JSON.stringify(d)), 'oversized RDAP must not be parsed');
  assert.match(JSON.stringify(d.errors || d), /rdap: response too large/);
});

// ── geoIp ───────────────────────────────────────────────────────────────────
test('geoIp: Android POST works, non-JSON and wrong methods are refused', async () => {
  installDenoStub();
  installFetch([
    dnsRoute('8.8.8.8.origin.asn.cymru.com', 'TXT', () => dnsOk([txtRecord('15169 | 8.8.8.0/24 | US | arin | 1992-12-01')])),
    dnsRoute('15169.asn.cymru.com', 'TXT', () => dnsOk([txtRecord('15169 | US | arin | 2000-03-30 | GOOGLE - Google LLC, US')])),
    anyDns(() => dnsEmpty()),
  ]);
  const handler = await loadHandler('geoIp');

  const ok = await call(handler, '/geoIp', {
    headers: { 'content-type': 'application/json' }, body: JSON.stringify({ ips: ['8.8.8.8'] }),
  });
  const d = await ok.json();
  assert.equal(ok.status, 200);
  assert.equal(d.results['8.8.8.8'].countryCode, 'US (registry)');
  assert.equal(ok.headers.get('access-control-allow-origin'), null);

  const bad = await call(handler, '/geoIp', { headers: { 'content-type': 'text/plain' }, body: '{"ips":["8.8.8.8"]}' });
  assert.equal(bad.status, 415);

  const put = await call(handler, '/geoIp', { method: 'PUT', headers: { 'content-type': 'application/json' } });
  assert.equal(put.status, 405);

  const pre = await call(handler, '/geoIp', { method: 'OPTIONS', origin: 'https://evil.example' });
  assert.equal(pre.status, 204);
  assert.equal(pre.headers.get('access-control-allow-origin'), null);
});

// ── ipWhois ─────────────────────────────────────────────────────────────────
test('ipWhois: shipped Android GET still works; POST needs JSON; junk rejected', async () => {
  installDenoStub();
  installFetch([
    dnsRoute('8.8.8.8.origin.asn.cymru.com', 'TXT', () => dnsOk([txtRecord('15169 | 8.8.8.0/24 | US | arin | 1992-12-01')])),
    dnsRoute('15169.asn.cymru.com', 'TXT', () => dnsOk([txtRecord('15169 | US | arin | 2000-03-30 | GOOGLE - Google LLC, US')])),
    anyDns(() => dnsEmpty()),
    { match: (u) => u.startsWith('https://rdap.arin.net/'), respond: () => json({ name: 'GOGL', entities: [] }) },
  ]);
  const handler = await loadHandler('ipWhois');

  // exact shipped client shape: GET with a query string, no content type, no origin
  const got = await call(handler, '/ipWhois?ip=8.8.8.8', { method: 'GET' });
  const d = await got.json();
  assert.equal(got.status, 200);
  assert.equal(d.ip, '8.8.8.8');
  assert.equal(d.country, 'US (registry)');
  assert.equal(got.headers.get('access-control-allow-origin'), null);

  const post = await call(handler, '/ipWhois', { headers: { 'content-type': 'application/json' }, body: '{"ip":"8.8.8.8"}' });
  assert.equal(post.status, 200);

  const plain = await call(handler, '/ipWhois', { headers: { 'content-type': 'text/plain' }, body: '{"ip":"8.8.8.8"}' });
  assert.equal(plain.status, 415, 'POST with a body still has to be JSON');

  const del = await call(handler, '/ipWhois?ip=8.8.8.8', { method: 'DELETE' });
  assert.equal(del.status, 405);

  const bad = await call(handler, '/ipWhois?ip=not-an-ip', { method: 'GET' });
  assert.equal(bad.status, 400);
});
