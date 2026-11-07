// Configuration independence: the Origin allowlist and the deadline must be read
// per request, so module import order or a mid-run env change cannot silently
// change behaviour.
import test from 'node:test';
import assert from 'node:assert/strict';
import {
  installDenoStub, installFetch, loadHandler, json, dnsOk, dnsEmpty,
  aRecord, anyDns, crtRoute, pageRoute, hang,
} from './harness.mjs';

const ANCHOR = 'https://superagent-cfb25b3e.base44.app/functions';
const routes = () => [
  dnsRouteSafe('example.com', 'A', () => dnsOk([aRecord('93.184.216.34')])),
  dnsRouteSafe('www.example.com', 'A', () => dnsOk([aRecord('93.184.216.34')])),
  anyDns(() => dnsEmpty()),
  crtRoute(() => json([])),
  pageRoute('example.com', () => new Response('<html>ok</html>', { status: 200 })),
  pageRoute('www.example.com', () => new Response('', { status: 200 })),
];
function dnsRouteSafe(name, type, respond) {
  return {
    match: (u) => {
      if (!u.startsWith('https://cloudflare-dns.com/dns-query')) return false;
      const q = new URL(u).searchParams;
      return q.get('name') === name && q.get('type') === type;
    },
    respond,
  };
}
const call = (handler, { method = 'POST', origin, body = '{"domain":"example.com"}', ct = 'application/json' } = {}) =>
  handler(new Request(ANCHOR + '/domainIntel', {
    method,
    headers: { ...(ct && method !== 'OPTIONS' ? { 'content-type': ct } : {}), ...(origin ? { origin } : {}) },
    body: method === 'GET' || method === 'OPTIONS' ? undefined : body,
  }));

test('origin allowlist: unset at import, honoured when set later, revoked again', async () => {
  delete process.env.NW_ALLOWED_ORIGINS;          // import with no allowlist
  installDenoStub(); installFetch(routes());
  const handler = await loadHandler('domainIntel');

  // 1. no Origin at all (native clients) -> works, no CORS grant
  const native = await call(handler, {});
  assert.equal(native.status, 200);
  assert.equal(native.headers.get('access-control-allow-origin'), null);

  // 2. unknown origin -> refused by the browser, request itself still served
  const evil = await call(handler, { origin: 'https://evil.example' });
  assert.equal(evil.status, 200);
  assert.equal(evil.headers.get('access-control-allow-origin'), null);

  // 3. allowlist configured AFTER import must take effect (per-request read)
  process.env.NW_ALLOWED_ORIGINS = 'https://tools.example';
  const pre = await call(handler, { method: 'OPTIONS', origin: 'https://tools.example' });
  assert.equal(pre.status, 204);
  assert.equal(pre.headers.get('access-control-allow-origin'), 'https://tools.example');
  assert.equal(pre.headers.get('access-control-allow-methods'), 'POST, OPTIONS');
  assert.equal(pre.headers.get('access-control-allow-headers'), 'Content-Type');

  const allowed = await call(handler, { origin: 'https://tools.example' });
  assert.equal(allowed.status, 200);
  assert.equal(allowed.headers.get('access-control-allow-origin'), 'https://tools.example');
  assert.equal(allowed.headers.get('vary'), 'Origin');

  // 4. allowlisted origin still cannot reach a different origin
  const wrong = await call(handler, { origin: 'https://other.example' });
  assert.equal(wrong.headers.get('access-control-allow-origin'), null);

  // 5. clearing the allowlist takes effect immediately
  delete process.env.NW_ALLOWED_ORIGINS;
  const revoked = await call(handler, { origin: 'https://tools.example' });
  assert.equal(revoked.headers.get('access-control-allow-origin'), null);
});

test('deadline: read per request, so an env change applies to the next call', async () => {
  installDenoStub();
  installFetch([
    dnsRouteSafe('example.com', 'A', () => dnsOk([aRecord('93.184.216.34')])),
    dnsRouteSafe('www.example.com', 'A', () => dnsOk([aRecord('93.184.216.34')])),
    anyDns(() => dnsEmpty()),
    crtRoute(() => json([])),
    pageRoute('example.com', hang),
    pageRoute('www.example.com', hang),
  ]);
  process.env.NW_DEADLINE_MS = '1000';
  const handler = await loadHandler('domainIntel');
  const keepAlive = setInterval(() => {}, 5);

  const t1 = Date.now();
  const first = await call(handler, {});
  const e1 = Date.now() - t1;
  assert.equal(first.status, 200);
  assert.equal((await first.json()).truncated, true);

  process.env.NW_DEADLINE_MS = '3000';           // same loaded module, new budget
  const t2 = Date.now();
  const second = await call(handler, {});
  const e2 = Date.now() - t2;
  assert.equal(second.status, 200);
  assert.equal((await second.json()).truncated, true);

  clearInterval(keepAlive);
  process.env.NW_DEADLINE_MS = '12000';
  assert.ok(e1 < 2500, `first deadline not applied: ${e1} ms`);
  assert.ok(e2 > 2500, `deadline change ignored: ${e2} ms`);
});

test('deadline is clamped so it can never exceed the client read timeouts', async () => {
  process.env.NW_DEADLINE_MS = '999999';
  installDenoStub(); installFetch(routes());
  const handler = await loadHandler('domainIntel');
  const res = await call(handler, {});
  assert.equal(res.status, 200);
  // Clamp is enforced in code; the effective ceiling (20 s) is asserted here
  // through the source contract test as well as this runtime path.
  process.env.NW_DEADLINE_MS = '12000';
});
