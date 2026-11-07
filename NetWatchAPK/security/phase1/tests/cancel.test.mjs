// Cancellation and user-visible deadline behaviour.
import test from 'node:test';
import assert from 'node:assert/strict';
import {
  installDenoStub, installFetch, loadHandler, json, dnsOk, dnsEmpty,
  aRecord, anyDns, crtRoute, pageRoute, hang,
} from './harness.mjs';

const ANCHOR = 'https://superagent-cfb25b3e.base44.app/functions';
const A_HOSTS = new Set(['example.com', 'www.example.com']);
const dns = {
  match: (u) => u.startsWith('https://cloudflare-dns.com/dns-query')
    && A_HOSTS.has(new URL(u).searchParams.get('name')),
  respond: () => dnsOk([aRecord('93.184.216.34')]),
};
const post = (handler) => handler(new Request(ANCHOR + '/domainIntel', {
  method: 'POST',
  headers: { 'content-type': 'application/json' },
  body: '{"domain":"example.com"}',
}));

test('cancellation reaches the in-flight fetches and nothing keeps running after the response', async () => {
  process.env.NW_DEADLINE_MS = '800';
  installDenoStub();
  const calls = installFetch([
    dns,
    anyDns(() => dnsEmpty()),
    crtRoute(() => json([])),
    pageRoute('example.com', hang),
    pageRoute('www.example.com', hang),
  ]);
  const handler = await loadHandler('domainIntel');
  const keepAlive = setInterval(() => {}, 5);

  const res = await post(handler);
  const body = await res.json();
  clearInterval(keepAlive);

  // the response itself: a normal 200 with partial data, not an error
  assert.equal(res.status, 200);
  assert.equal(body.error, undefined, 'deadline must not surface as an error to the client');
  assert.equal(body.truncated, true);
  assert.deepEqual(body.ipv4, ['93.184.216.34'], 'work completed before the deadline is kept');
  assert.ok(body.errors.some((e) => e.startsWith('deadline:')), JSON.stringify(body.errors));

  // cancellation actually reached the hanging requests
  const pageCalls = calls.filter((c) => c.url === 'https://example.com/' || c.url === 'https://www.example.com/');
  assert.equal(pageCalls.length, 2, 'both page fetches were attempted');
  for (const c of pageCalls) {
    assert.ok(c.init.signal, 'page fetch must be given an abort signal');
    assert.equal(c.init.signal.aborted, true, 'page fetch signal must be aborted by the deadline');
    assert.match(String(c.init.signal.reason && c.init.signal.reason.message), /deadline/i);
  }

  // no background work continues after the handler returned
  const afterResponse = calls.length;
  await new Promise((r) => setTimeout(r, 200));
  assert.equal(calls.length, afterResponse, 'a fetch was still being issued after the response');
  process.env.NW_DEADLINE_MS = '12000';
});

test('a scan that finishes inside the deadline is reported as complete, not truncated', async () => {
  process.env.NW_DEADLINE_MS = '12000';
  installDenoStub();
  installFetch([
    dns,
    anyDns(() => dnsEmpty()),
    crtRoute(() => json([])),
    pageRoute('example.com', async () => {
      await new Promise((r) => setTimeout(r, 150));   // slow, but well inside budget
      return new Response('<html><script src="https://cdn.tracker.test/a.js"></script></html>', { status: 200 });
    }),
    pageRoute('www.example.com', () => new Response('', { status: 200 })),
  ]);
  const handler = await loadHandler('domainIntel');

  const started = Date.now();
  const res = await post(handler);
  const body = await res.json();
  assert.equal(res.status, 200);
  assert.equal(body.truncated, false);
  assert.equal(body.errors.some((e) => e.includes('deadline')), false);
  assert.ok(Date.now() - started < 5000);
});

test('deadline wins over a slow subrequest: partial JSON, HTTP 200, no 5xx', async () => {
  process.env.NW_DEADLINE_MS = '1000';
  installDenoStub();
  installFetch([
    dns,
    anyDns(() => dnsEmpty()),
    crtRoute(hang),                                  // the very first phase hangs
    pageRoute('example.com', () => new Response('', { status: 200 })),
    pageRoute('www.example.com', () => new Response('', { status: 200 })),
  ]);
  const handler = await loadHandler('domainIntel');
  const keepAlive = setInterval(() => {}, 5);

  const res = await post(handler);
  const text = await res.text();
  clearInterval(keepAlive);
  process.env.NW_DEADLINE_MS = '12000';

  assert.equal(res.status, 200, 'a hung crt.sh must degrade the scan, not fail the request');
  const body = JSON.parse(text);
  assert.equal(body.truncated, true);
  assert.equal(body.domain, 'example.com');
  assert.equal(res.headers.get('content-type'), 'application/json');
});
