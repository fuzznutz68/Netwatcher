// Unit tests for the canonical Phase 1 module (security/phase1/nwhttp.mjs).
import test from 'node:test';
import assert from 'node:assert/strict';
import {
  nwAllowedOriginsFromEnv, nwOriginAllowed, nwCorsHeaders, nwPreflight,
  nwIsJsonContentType, nwRequestCarriesBody, nwContentTypeAccepted,
  nwMethodAllowed, nwDeadline, nwMergeSignals, nwReadCapped, nwSafeGet,
} from '../nwhttp.mjs';

const ALLOW = new Set(['https://tools.example']);

test('CORS: default is deny, never wildcard', () => {
  const h = nwCorsHeaders(null, new Set(), 'POST, OPTIONS');
  assert.equal(h['Access-Control-Allow-Origin'], undefined);
  assert.equal(h.Vary, 'Origin');
  assert.equal(h['Access-Control-Allow-Methods'], 'POST, OPTIONS');
  assert.equal(h['Access-Control-Allow-Headers'], 'Content-Type');
  // a wildcard must never appear, whatever the input
  for (const origin of [null, '', 'https://evil.example', 'null']) {
    const hh = nwCorsHeaders(origin, new Set(), 'POST');
    assert.ok(!Object.values(hh).includes('*'), 'wildcard leaked');
    assert.equal(hh['Access-Control-Allow-Origin'], undefined);
  }
});

test('CORS: allowlisted origin is echoed exactly, others are not', () => {
  assert.equal(nwCorsHeaders('https://tools.example', ALLOW, 'POST')['Access-Control-Allow-Origin'], 'https://tools.example');
  assert.equal(nwCorsHeaders('https://tools.example/', ALLOW, 'POST')['Access-Control-Allow-Origin'], 'https://tools.example');
  assert.equal(nwCorsHeaders('https://evil.example', ALLOW, 'POST')['Access-Control-Allow-Origin'], undefined);
  assert.equal(nwCorsHeaders('https://tools.example.evil.test', ALLOW, 'POST')['Access-Control-Allow-Origin'], undefined);
  assert.equal(nwCorsHeaders('https://TOOLS.example', ALLOW, 'POST')['Access-Control-Allow-Origin'], undefined, 'origin match is case sensitive');
});

test('CORS: allowlist parsing tolerates spaces, slashes and empty env', () => {
  const env = (v) => () => v;
  assert.equal(nwAllowedOriginsFromEnv(env('https://a.example/, https://b.example')).size, 2);
  assert.ok(nwAllowedOriginsFromEnv(env('https://a.example/')).has('https://a.example'));
  assert.equal(nwAllowedOriginsFromEnv(env('')).size, 0);
  assert.equal(nwAllowedOriginsFromEnv(env(undefined)).size, 0);
  assert.equal(nwAllowedOriginsFromEnv(() => { throw new Error('denied'); }).size, 0);
});

test('preflight: 204, explicit methods, no ACAO by default', () => {
  const p = nwPreflight('https://evil.example', new Set(), 'GET, POST, OPTIONS');
  assert.equal(p.status, 204);
  assert.equal(p.body, null);
  assert.equal(p.headers['Access-Control-Allow-Origin'], undefined);
  assert.equal(p.headers['Access-Control-Allow-Methods'], 'GET, POST, OPTIONS');
  assert.equal(nwPreflight('https://tools.example', ALLOW, 'POST').headers['Access-Control-Allow-Origin'], 'https://tools.example');
});

test('content type: application/json accepted, parameters and case tolerated', () => {
  for (const v of ['application/json', 'application/json; charset=utf-8', 'Application/JSON',
                   'application/json;charset=UTF-8', '  application/json  ']) {
    assert.equal(nwIsJsonContentType(v), true, v);
  }
  for (const v of [null, undefined, '', 'text/plain', 'application/jsonp',
                   'application/x-www-form-urlencoded', 'multipart/form-data; boundary=x']) {
    assert.equal(nwIsJsonContentType(v), false, String(v));
  }
});

test('content type gate exempts bodyless methods only', () => {
  assert.equal(nwRequestCarriesBody('GET'), false);
  assert.equal(nwRequestCarriesBody('HEAD'), false);
  assert.equal(nwRequestCarriesBody('OPTIONS'), false);
  assert.equal(nwRequestCarriesBody('POST'), true);
  assert.equal(nwContentTypeAccepted('GET', null), true, 'Android GET /ipWhois has no content type');
  assert.equal(nwContentTypeAccepted('POST', null), false);
  assert.equal(nwContentTypeAccepted('POST', 'application/json'), true);
  assert.equal(nwContentTypeAccepted('PUT', 'text/plain'), false);
});

test('method allowlist', () => {
  assert.equal(nwMethodAllowed('POST', 'POST, OPTIONS'), true);
  assert.equal(nwMethodAllowed('post', 'POST, OPTIONS'), true);
  assert.equal(nwMethodAllowed('GET', 'POST, OPTIONS'), false);
  assert.equal(nwMethodAllowed('GET', 'GET, POST, OPTIONS'), true);
  assert.equal(nwMethodAllowed('DELETE', 'GET, POST, OPTIONS'), false);
});

test('readCapped: stops at the cap and cancels the reader', async () => {
  const chunks = [];
  let sent = 0, cancelled = false;
  const stream = new ReadableStream({
    pull(c) {
      if (sent >= 10_000) return c.close();
      sent += 1000; chunks.push(1000);
      c.enqueue(new Uint8Array(1000).fill(65));
    },
    cancel() { cancelled = true; },
  });
  const res = await nwReadCapped(new Response(stream), 2500);
  assert.equal(res.truncated, true);
  assert.equal(res.bytes, 2500);
  assert.equal(res.text.length, 2500);
  assert.equal(cancelled, true, 'reader must be cancelled, not drained');
  assert.ok(sent <= 4000, `over-read: ${sent} bytes pulled for a 2500 byte cap`);
});

test('readCapped: exact cap and under cap', async () => {
  const exact = await nwReadCapped(new Response('x'.repeat(100)), 100);
  assert.equal(exact.truncated, true);
  assert.equal(exact.text.length, 100);
  const small = await nwReadCapped(new Response('hello'), 100);
  assert.equal(small.truncated, false);
  assert.equal(small.text, 'hello');
  assert.equal(small.bytes, 5);
});

test('readCapped: a body without a stream is never buffered (fail-closed)', async () => {
  let read = false;
  const res = {
    headers: new Headers({ 'content-length': '10' }),
    body: { cancel: async () => {} },
    text: async () => { read = true; return 'x'.repeat(10_000_000); },
  };
  const out = await nwReadCapped(res, 500);
  assert.equal(read, false);
  assert.equal(out.unreadable, true);
  assert.equal(out.bytes, 0);
});

test('readCapped: a body without a stream is discarded unread, never buffered', async () => {
  let textCalls = 0;
  let cancelled = false;
  const hostile = {
    headers: new Headers({ 'content-length': '1024' }),   // server claims small
    body: { cancel: async () => { cancelled = true; } },  // but exposes no reader
    text: async () => { textCalls++; return 'x'.repeat(50_000_000); },
    arrayBuffer: async () => { textCalls++; return new ArrayBuffer(50_000_000); },
  };
  const res = await nwReadCapped(hostile, 400_000);
  assert.equal(textCalls, 0, 'a non-streaming body must never be read into memory');
  assert.equal(res.bytes, 0);
  assert.equal(res.text, '');
  assert.equal(res.truncated, true);
  assert.equal(res.unreadable, true, 'caller must be able to tell why the body is empty');
  assert.equal(cancelled, true, 'the body must be cancelled so the connection is released');
});

test('readCapped: a response with no body at all is handled without throwing', async () => {
  const res = await nwReadCapped({ body: null, headers: new Headers() }, 1000);
  assert.deepEqual(res, { text: '', truncated: false, bytes: 0 });
  assert.equal(await nwReadCapped(null, 1000).then((r) => r.bytes), 0);
});

test('readCapped: a 50 MB body is abandoned mid-stream, never downloaded', async () => {
  let produced = 0;
  let cancelled = false;
  const CHUNK = 64 * 1024;
  const stream = new ReadableStream({
    pull(c) {
      produced += CHUNK;
      c.enqueue(new Uint8Array(CHUNK).fill(120));
    },
    cancel() { cancelled = true; },
  });
  const started = Date.now();
  const res = await nwReadCapped(new Response(stream), 400_000);
  const elapsed = Date.now() - started;

  assert.equal(res.bytes, 400_000, 'delivered payload stops exactly at the cap');
  assert.equal(res.text.length, 400_000);
  assert.equal(res.truncated, true);
  assert.equal(cancelled, true, 'the body stream must be cancelled');
  assert.ok(produced < 50_000_000 / 10, `produced ${produced} bytes; the cap did not stop the download`);
  assert.ok(elapsed < 500, `took ${elapsed} ms; the response was buffered rather than streamed`);
});

test('deadline: expires, aborts, and close() disarms it', async () => {
  const dl = nwDeadline(30);
  assert.equal(dl.expired(), false);
  await new Promise((r) => setTimeout(r, 60));
  assert.equal(dl.expired(), true);
  assert.equal(dl.remaining(), 0);

  const quiet = nwDeadline(30);
  quiet.close();
  await new Promise((r) => setTimeout(r, 60));
  assert.equal(quiet.expired(), false, 'closed deadline must not fire');
});

test('mergeSignals: single passthrough and combined abort', async () => {
  assert.equal(nwMergeSignals([]), undefined);
  const one = new AbortController();
  assert.equal(nwMergeSignals([one.signal]), one.signal);

  const a = new AbortController(), b = new AbortController();
  const merged = nwMergeSignals([a.signal, b.signal]);
  assert.equal(merged.aborted, false);
  b.abort(new Error('deadline'));
  await new Promise((r) => setTimeout(r, 0));
  assert.equal(merged.aborted, true);

  const dead = new AbortController(); dead.abort();
  assert.equal(nwMergeSignals([dead.signal, new AbortController().signal]).aborted, true);
});

// ── guarded GET ─────────────────────────────────────────────────────────────
const okValidators = {
  validateHostname: (h) => (h === 'blocked.example'
    ? { ok: false, error: 'metadata hostname blocked' }
    : { ok: true, host: h }),
  checkResolved: (ips) => (ips.some((ip) => ip === '10.0.0.1')
    ? { ok: false, error: 'resolved to blocked address 10.0.0.1' }
    : { ok: true, ips }),
  resolve: async () => ['93.184.216.34'],
};
const html = (body = '<html>ok</html>', status = 200, headers = {}) =>
  new Response(body, { status, headers: { 'content-type': 'text/html', ...headers } });

test('safeGet: 200 returns body and one hop', async () => {
  const r = await nwSafeGet('https://site.example/', { ...okValidators, fetchImpl: async () => html() });
  assert.equal(r.status, 200);
  assert.equal(r.body, '<html>ok</html>');
  assert.deepEqual(r.hops, ['https://site.example/']);
  assert.equal(r.truncated, false);
});

test('safeGet: follows a validated redirect once', async () => {
  const r = await nwSafeGet('https://site.example/', {
    ...okValidators,
    fetchImpl: async (u) => (u === 'https://site.example/'
      ? html('', 302, { location: 'https://other.example/landing' })
      : html('landed')),
  });
  assert.equal(r.body, 'landed');
  assert.equal(r.hops.length, 2);
  assert.equal(r.url, 'https://other.example/landing');
});

test('safeGet: rejects protocol downgrade, credentials, ports, blocked hosts and missing location', async () => {
  const cases = [
    ['http://site.example/', /https required/],
    ['https://user:pass@site.example/', /credentials rejected/],
    ['https://site.example:8443/', /port rejected/],
    ['https://blocked.example/', /blocked_host/],
    ['https://site.example/', /redirect_without_location/],
  ];
  for (const [url, expected] of cases) {
    const fetchImpl = async () => html('', 302, {});   // 302 with no Location
    if (url.includes('user:pass') || url.includes(':8443') || url.includes('blocked.example')) {
      await assert.rejects(() => nwSafeGet(url, { ...okValidators, fetchImpl }), expected, url);
    } else {
      await assert.rejects(() => nwSafeGet(url, { ...okValidators, fetchImpl }), expected, url);
    }
  }
});

test('safeGet: rejects a redirect destination that resolves to a private address', async () => {
  await assert.rejects(
    () => nwSafeGet('https://site.example/', {
      ...okValidators,
      resolve: async (h) => (h === 'internal.example' ? ['10.0.0.1'] : ['93.184.216.34']),
      fetchImpl: async () => html('', 301, { location: 'https://internal.example/' }),
    }),
    /blocked_resolution/,
  );
});

test('safeGet: hop limit is enforced', async () => {
  let n = 0;
  await assert.rejects(
    () => nwSafeGet('https://site.example/', {
      ...okValidators,
      fetchImpl: async () => { n += 1; return html('', 302, { location: `https://h${n}.example/` }); },
    }),
    /too_many_redirects/,
  );
  assert.equal(n, 4, 'initial request plus maxHops redirects');
});

test('safeGet: oversized body is truncated, not buffered whole', async () => {
  const stream = new ReadableStream({
    start(c) { c.enqueue(new Uint8Array(500_000).fill(66)); c.close(); },
  });
  const r = await nwSafeGet('https://site.example/', {
    ...okValidators,
    maxBytes: 1000,
    fetchImpl: async () => new Response(stream),
  });
  assert.equal(r.truncated, true);
  assert.equal(r.body.length, 1000);
});

test('safeGet: aborting the deadline rejects the in-flight request', async () => {
  // nwDeadline unrefs its timer (so a finished invocation never holds the
  // runtime open); keep the test process alive while we await the abort.
  const keepAlive = setInterval(() => {}, 5);
  const dl = nwDeadline(25);
  const fetchImpl = (u, init) => new Promise((_, reject) => {
    init.signal.addEventListener('abort', () => reject(init.signal.reason || new Error('aborted')), { once: true });
  });
  await assert.rejects(() => nwSafeGet('https://site.example/', { ...okValidators, fetchImpl, signal: dl.signal }), /deadline/);
  dl.close();
  clearInterval(keepAlive);
});
