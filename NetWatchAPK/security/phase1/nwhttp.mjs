// NetWatch — Phase 1 HTTP boundary hardening (pure logic, zero runtime dependencies).
//
// Canonical source for the inline block copied into each deployed function.
// Base44 deploys single files, so the functions cannot import this module; the
// patched function sources inline this file verbatim (minus `export`) and
// tests/nwhttp.test.mjs asserts the inlined text still matches byte for byte.
//
// Scope of Phase 1 (authorized):
//   - explicit, restrictive CORS (no wildcard, no origin reflection)
//   - JSON content-type enforcement for body-carrying requests
//   - strictly capped response reads (enforced while reading, reader cancelled)
//   - a total wall-clock deadline with cancellation of outstanding work
//   - a guarded GET whose redirects are re-validated per hop
//
// Out of scope for Phase 1 (explicitly excluded by the authorization):
//   deep=true gating, token buckets, scan tokens, authentication, caching.

// ── CORS ────────────────────────────────────────────────────────────────────
// There is no browser client. Native Android and Windows callers send no
// Origin header, and CORS never applies to them. The default allowlist is
// therefore empty: no Access-Control-Allow-Origin is emitted at all.
export function nwAllowedOriginsFromEnv(getenv) {
  try {
    const raw = typeof getenv === 'function' ? getenv('NW_ALLOWED_ORIGINS') : '';
    return new Set(
      String(raw || '')
        .split(',')
        .map((s) => s.trim().replace(/\/+$/, ''))
        .filter((s) => s.length > 0),
    );
  } catch (_) {
    return new Set();
  }
}

export function nwOriginAllowed(origin, allowedOrigins) {
  if (!origin || !allowedOrigins) return false;
  const o = String(origin).trim().replace(/\/+$/, '');
  if (!o) return false;
  return allowedOrigins.has(o);
}

// Explicit headers on every response. `Vary: Origin` keeps intermediaries from
// serving a cached response to the wrong origin once an allowlist is set.
export function nwCorsHeaders(origin, allowedOrigins, methods) {
  const h = {
    Vary: 'Origin',
    'Access-Control-Allow-Methods': methods,
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Max-Age': '600',
  };
  if (nwOriginAllowed(origin, allowedOrigins)) {
    h['Access-Control-Allow-Origin'] = String(origin).trim().replace(/\/+$/, '');
  }
  return h;
}

export function nwPreflight(origin, allowedOrigins, methods) {
  return {
    status: 204,
    headers: nwCorsHeaders(origin, allowedOrigins, methods),
    body: null,
  };
}

// ── Method and content-type gates ───────────────────────────────────────────
// Body-carrying requests must declare application/json. Parameters such as
// `; charset=utf-8` are accepted because .NET's StringContent sends them.
// GET/HEAD/OPTIONS carry no body and are exempt so the existing
// `GET /ipWhois?ip=...` path keeps working untouched.
export function nwIsJsonContentType(value) {
  if (value === null || value === undefined) return false;
  const base = String(value).split(';')[0].trim().toLowerCase();
  return base === 'application/json';
}

export function nwRequestCarriesBody(method) {
  const m = String(method || '').toUpperCase();
  return m !== 'GET' && m !== 'HEAD' && m !== 'OPTIONS';
}

export function nwContentTypeAccepted(method, contentType) {
  if (!nwRequestCarriesBody(method)) return true;
  return nwIsJsonContentType(contentType);
}

export function nwMethodAllowed(method, methods) {
  const m = String(method || '').toUpperCase();
  return String(methods || '')
    .split(',')
    .map((s) => s.trim().toUpperCase())
    .filter(Boolean)
    .includes(m);
}

// ── Deadline ────────────────────────────────────────────────────────────────
// One timer per invocation. Aborting the signal cancels every in-flight fetch
// that was given it (DNS, crt.sh, page fetch). `close()` must run in `finally`
// so a completed invocation never leaves a live timer behind.
export function nwDeadline(ms, now = () => Date.now()) {
  const started = now();
  const controller = new AbortController();
  const budget = Math.max(1, Number(ms) || 1);
  const timer = setTimeout(() => {
    try {
      controller.abort(new Error('deadline exceeded'));
    } catch (_) {
      controller.abort();
    }
  }, budget);
  // Never keep a Deno/Node process alive just for the deadline timer.
  if (timer && typeof timer.unref === 'function') timer.unref();
  return {
    signal: controller.signal,
    expired: () => controller.signal.aborted,
    remaining: () => Math.max(0, budget - (now() - started)),
    elapsed: () => now() - started,
    close: () => clearTimeout(timer),
  };
}

// Combine the per-operation timeout with the invocation deadline.
export function nwMergeSignals(signals) {
  const list = (signals || []).filter(Boolean);
  if (list.length === 0) return undefined;
  if (list.length === 1) return list[0];
  if (typeof AbortSignal !== 'undefined' && typeof AbortSignal.any === 'function') {
    return AbortSignal.any(list);
  }
  const controller = new AbortController();
  for (const s of list) {
    if (s.aborted) {
      controller.abort(s.reason);
      return controller.signal;
    }
    s.addEventListener('abort', () => controller.abort(s.reason), { once: true });
  }
  return controller.signal;
}

// ── Capped read ─────────────────────────────────────────────────────────────
// Enforced while reading: once the cap is reached the stream is cancelled, so an
// oversized or hostile response can never be buffered past `maxBytes`.
export async function nwReadCapped(res, maxBytes) {
  const cap = Math.max(0, Number(maxBytes) || 0);
  if (!res || !res.body || typeof res.body.getReader !== 'function') {
    const t = await (res ? res.text() : Promise.resolve(''));
    const s = String(t);
    return { text: s.slice(0, cap), truncated: s.length > cap, bytes: Math.min(s.length, cap) };
  }
  const reader = res.body.getReader();
  const chunks = [];
  let total = 0;
  let truncated = false;
  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    const room = cap - total;
    if (value.length > room) {
      if (room > 0) chunks.push(value.slice(0, room));
      total += Math.max(0, room);
      truncated = true;
      try { await reader.cancel(); } catch (_) {}
      break;
    }
    chunks.push(value);
    total += value.length;
    if (total >= cap) {
      truncated = true;
      try { await reader.cancel(); } catch (_) {}
      break;
    }
  }
  const buf = new Uint8Array(chunks.reduce((n, c) => n + c.length, 0));
  let off = 0;
  for (const c of chunks) { buf.set(c, off); off += c.length; }
  return { text: new TextDecoder().decode(buf), truncated, bytes: total };
}

// ── Guarded GET ─────────────────────────────────────────────────────────────
// Same contract as the function-local safeGet it replaces, plus an invocation
// deadline signal. Validation is injected so this module stays dependency-free.
//
// LIMITATION (unchanged by Phase 1): the request is issued by hostname, so the
// runtime resolves the name again at connect time. See PINNING_INVESTIGATION.md.
export async function nwSafeGet(url, opts) {
  const fetchImpl = opts.fetchImpl;
  const resolve = opts.resolve;
  const validateHostname = opts.validateHostname;
  const checkResolved = opts.checkResolved;
  const readCapped = opts.readCapped || nwReadCapped;
  const maxHops = opts.maxHops === undefined ? 3 : opts.maxHops;
  const timeoutMs = opts.timeoutMs === undefined ? 9000 : opts.timeoutMs;
  const maxBytes = opts.maxBytes === undefined ? 1500000 : opts.maxBytes;
  const deadline = opts.signal;

  const hops = [];
  let current = url;

  for (let hop = 0; hop <= maxHops; hop++) {
    if (deadline && deadline.aborted) throw new Error('deadline exceeded');
    let u;
    try { u = new URL(current); } catch (_) { throw new Error('blocked_url: unparseable'); }
    if (u.protocol !== 'https:') throw new Error('blocked_url: https required');
    if (u.username || u.password) throw new Error('blocked_url: credentials rejected');
    if (u.port && u.port !== '443') throw new Error('blocked_url: port rejected');
    hops.push(current);

    const hostCheck = validateHostname(u.hostname);
    if (!hostCheck.ok) throw new Error('blocked_host: ' + hostCheck.error);

    const ips = await resolve(u.hostname);
    const ipCheck = checkResolved(ips);
    if (!ipCheck.ok) throw new Error('blocked_resolution: ' + ipCheck.error);

    const res = await fetchImpl(current, {
      method: 'GET',
      redirect: 'manual',
      signal: nwMergeSignals([AbortSignal.timeout(timeoutMs), deadline]),
      headers: {
        'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 ' +
          '(KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36',
        Accept: 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      },
    });

    if (res.status >= 300 && res.status < 400) {
      const loc = res.headers && res.headers.get ? res.headers.get('location') : null;
      if (!loc) throw new Error('redirect_without_location');
      current = new URL(loc, current).toString();
      continue;
    }

    const { text, truncated } = await readCapped(res, maxBytes);
    return { status: res.status, body: text, url: current, hops, truncated };
  }

  throw new Error('too_many_redirects');
}
