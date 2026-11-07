import test from 'node:test';
import assert from 'node:assert/strict';
import {
  validateHostname, normalizeDomain, isBlockedAddress, checkResolved,
  resolveAndPin, validateRedirect, createLimiter,
} from './netGuard.mjs';

const ip = (s) => isBlockedAddress(s);

test('blocks loopback, private, link-local, metadata, reserved', () => {
  for (const s of ['127.0.0.1','127.1.2.3','10.0.0.1','172.16.0.1','172.31.255.255',
                   '192.168.1.1','169.254.169.254','0.0.0.0','100.64.0.1','100.100.100.200',
                   '224.0.0.1','240.0.0.1','255.255.255.255','192.0.2.5','198.18.0.1'])
    assert.equal(ip(s), true, s + ' must be blocked');
});

test('blocks IPv6 loopback, ULA, link-local, multicast, mapped and translated', () => {
  for (const s of ['::1','::','fc00::1','fd12:3456::1','fe80::1','ff02::1',
                   '2001:db8::1','::ffff:127.0.0.1','::ffff:169.254.169.254',
                   '64:ff9b::a9fe:a9fe','2002:7f00:0001::1'])
    assert.equal(ip(s), true, s + ' must be blocked');
});

test('allows genuine public addresses', () => {
  for (const s of ['8.8.8.8','1.1.1.1','93.184.216.34','2606:4700:4700::1111'])
    assert.equal(ip(s), false, s + ' must be allowed');
});

test('rejects hostname bypass shapes', () => {
  const bad = ['127.0.0.1','localhost','169.254.169.254','[::1]','0x7f000001',
               '2130706433','0177.0.0.1','metadata.google.internal','instance-data',
               'example.com.','a@b.com','user:pass@example.com','example.com/path',
               'http://example.com','a..b','-bad.com','bad-.com','example.c0m',
               'x'.repeat(64) + '.com', 'intranet','printer.local'];
  for (const h of bad) assert.equal(validateHostname(h).ok, false, h + ' must be rejected');
});

test('accepts normal hostnames', () => {
  for (const h of ['example.com','sub.example.co.uk','xn--bcher-kva.example'])
    assert.equal(validateHostname(h).ok, true, h + ' must be accepted');
});

test('normalizeDomain strips path but refuses scheme', () => {
  assert.equal(normalizeDomain('https://example.com/x').ok, false);
  assert.equal(normalizeDomain('example.com/x').host, 'example.com');
});

test('rejects hosts resolving to private space (rebinding/alias bypass)', async () => {
  const evil = async () => ['127.0.0.1'];
  const r = await resolveAndPin('example.com', evil);
  assert.equal(r.ok, false);
  assert.match(r.error, /blocked address/);
});

test('rejects when any record is private (mixed answers)', async () => {
  const mixed = async (_h, type) => type === 'A' ? ['93.184.216.34'] : ['fe80::1'];
  assert.equal((await resolveAndPin('example.com', mixed)).ok, false);
});

test('allows and pins a public resolution', async () => {
  const good = async (_h, type) => type === 'A' ? ['93.184.216.34','93.184.216.35'] : [];
  const r = await resolveAndPin('example.com', good);
  assert.equal(r.ok, true);
  assert.equal(r.pinned, '93.184.216.34');
});

test('rejects empty DNS answers', async () => {
  assert.equal((await resolveAndPin('example.com', async () => [])).ok, false);
});

test('redirects to metadata or odd ports are rejected', () => {
  assert.equal(validateRedirect('http://169.254.169.254/latest/meta-data', 'example.com').ok, false);
  assert.equal(validateRedirect('http://metadata.google.internal/', 'example.com').ok, false);
  assert.equal(validateRedirect('http://example.com:8080/', 'example.com').ok, false);
  assert.equal(validateRedirect('file:///etc/passwd', 'example.com').ok, false);
  assert.equal(validateRedirect('http://user:pw@example.com/', 'example.com').ok, false);
  assert.equal(validateRedirect('https://other.example/', 'example.com').ok, true);
});

test('checkResolved rejects an empty or fully private set', () => {
  assert.equal(checkResolved([]).ok, false);
  assert.equal(checkResolved(['10.1.1.1']).ok, false);
  assert.equal(checkResolved(['8.8.8.8']).ok, true);
});

test('limiter caps concurrency and enforces a token bucket', async () => {
  const l = createLimiter({ maxConcurrent: 1, perMinute: 60, burst: 2 });
  let release;
  const held = l.run(() => new Promise((res) => { release = res; }));
  const rejected = await l.run(() => 'should not run');
  assert.equal(rejected.ok, false);
  assert.equal(rejected.status, 429);
  release(); await held;

  assert.equal(l.take('ip-a'), true);
  assert.equal(l.take('ip-a'), true);
  assert.equal(l.take('ip-a'), false, 'burst exhausted');
  assert.equal(l.take('ip-b'), true, 'separate client unaffected');
});
