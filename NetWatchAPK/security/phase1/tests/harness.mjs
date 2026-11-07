// Test harness: runs the *transpiled* patched handlers under Node with stubbed
// Deno + fetch, so the code exercised is the code that would be deployed.
import fs from 'node:fs';
import path from 'node:path';
import os from 'node:os';
import { pathToFileURL, fileURLToPath } from 'node:url';

export const BUILD = path.join(path.dirname(fileURLToPath(import.meta.url)), '..', 'build');

export function installDenoStub() {
  globalThis.__nwHandler = null;
  globalThis.Deno = {
    env: { get: (k) => process.env[k] },
    serve: (fn) => { globalThis.__nwHandler = fn; },
  };
  return { get handler() { return globalThis.__nwHandler; } };
}

export function installFetch(routes) {
  const calls = [];
  globalThis.fetch = async (url, init = {}) => {
    const u = String(url);
    calls.push({ url: u, init });
    for (const r of routes) {
      if (r.match(u, init)) return await r.respond(u, init);
    }
    throw new Error('unstubbed fetch: ' + u);
  };
  return calls;
}

export const json = (obj, status = 200) =>
  new Response(JSON.stringify(obj), { status, headers: { 'content-type': 'application/json' } });

export const dnsOk = (answers = []) => json({ Status: 0, Answer: answers });
export const dnsEmpty = () => json({ Status: 0, Answer: [] });
export const aRecord = (ip) => ({ type: 1, data: ip });
export const txtRecord = (t) => ({ type: 16, data: t });

export const dnsRoute = (name, type, respond) => ({
  match: (u) => {
    if (!u.startsWith('https://cloudflare-dns.com/dns-query')) return false;
    const q = new URL(u).searchParams;
    return q.get('name') === name && q.get('type') === type;
  },
  respond,
});

export const anyDns = (respond) => ({
  match: (u) => u.startsWith('https://cloudflare-dns.com/dns-query'),
  respond,
});

export const crtRoute = (respond) => ({
  match: (u) => u.startsWith('https://crt.sh/'),
  respond,
});

export const pageRoute = (host, respond) => ({
  match: (u) => u === `https://${host}/`,
  respond,
});

// A hanging response that honours the abort signal, for deadline tests.
export const hang = (u, init) =>
  new Promise((_, reject) => {
    const s = init && init.signal;
    if (!s) return;
    if (s.aborted) return reject(s.reason || new Error('aborted'));
    s.addEventListener('abort', () => reject(s.reason || new Error('aborted')), { once: true });
  });

// A body stream of `total` bytes that records how much was actually pulled,
// so "cap enforced while reading" can be proven rather than assumed.
export function countingStream(total, chunkSize = 64 * 1024) {
  const counter = { pulled: 0, cancelled: false };
  let sent = 0;
  const stream = new ReadableStream({
    pull(controller) {
      if (sent >= total) return controller.close();
      const size = Math.min(chunkSize, total - sent);
      const chunk = new Uint8Array(size).fill(0x20); // spaces
      sent += size;
      counter.pulled += size;
      controller.enqueue(chunk);
    },
    cancel() { counter.cancelled = true; },
  });
  return { counter, response: new Response(stream, { status: 200 }) };
}

// Fresh module instance per test: the handlers register at import time and the
// deadline/origin config is read at module scope.
let seq = 0;
export async function loadHandler(name) {
  const src = path.join(BUILD, `${name}.mjs`);
  const copy = path.join(os.tmpdir(), `nw-${name}-${process.pid}-${seq++}.mjs`);
  fs.copyFileSync(src, copy);
  await import(pathToFileURL(copy).href);
  const fn = globalThis.__nwHandler;
  if (typeof fn !== 'function') throw new Error(`handler not registered by ${name}`);
  return fn;
}
