# domainIntel — bounded TTL cache design (design only, not implemented)

Status: **design for review**. No cache code exists in `patched/`; `gates.test.mjs`
asserts that `createCache(` never appears in the patched domainIntel source.

## Why

One unauthenticated `domainIntel` call costs roughly 400 DoH queries, two page
fetches and one crt.sh query, and took 9.0 s (example.com), 4.2 s (wikipedia.org)
and 20.8 s (github.com) in measurement. Repeat scans of the same domain are the
cheapest abuse to mount and the most expensive to serve.

## Key

```
key = `v1|${cleanDomain.toLowerCase()}|${deep ? 'deep' : 'basic'}`
```

- `cleanDomain` is the value **after** `validateHostname` and normalisation, so a
  malformed or blocked hostname can never create a cache entry.
- `v1` is bumped whenever the response schema changes, which retires every old
  entry at once on deploy.
- The key contains **no caller data**: no IP, no User-Agent, no headers, no
  cookies. Two different callers asking about the same domain legitimately share
  an entry because the answer is a property of the domain, not of the caller.

## Value

The response object as returned to clients, minus `timestamp`, plus `cachedAt`.
Stored as the serialised JSON string, not a live object, so a bug in one handler
cannot mutate a cached entry.

## TTL and admission

| Case | Cached? | TTL |
|---|---|---|
| Complete scan, `errors.length === 0` | yes | 10 min (basic) / 30 min (deep) |
| Complete scan with benign errors (e.g. `rdap: http 404`) | yes | 5 min |
| `truncated === true` (deadline hit) | **no** | — |
| Any `deadline:` error | **no** | — |
| 4xx/5xx, thrown exception, cancelled request | **no** | — |
| `deep === true` | yes | 30 min |

Rationale: a truncated payload is a partial view; caching it would freeze a bad
result for ten minutes. Failures are never cached so a transient outage cannot
turn into a ten-minute outage.

## Bounds

```
MAX_ENTRIES_BASIC = 150      // payload cap 32 KB each  → ≤ 4.8 MB
MAX_ENTRIES_DEEP  = 30       // payload cap 96 KB each  → ≤ 2.9 MB
MAX_TOTAL_BYTES   = 8 MB     // hard ceiling across both maps
```

- A payload larger than its per-entry cap is **not** cached (never truncate a
  payload to make it fit).
- Eviction: LRU by last access, then oldest-expiry sweep when a map exceeds 80 %
  of its entry budget, then byte-budget eviction from the LRU end.
- Expiry is lazy (checked on read) plus a cheap sweep of at most 8 entries per
  write, so no timer is needed and a finished request never keeps the runtime
  alive.

## Concurrency

- **Single-flight per key.** The first miss for a key registers an in-flight
  promise; concurrent requests for the same key await that promise instead of
  starting their own scan. This is the important property: ten simultaneous
  requests for one domain cost **one** scan, not ten.
- The in-flight map is bounded to 32 keys; a 33rd distinct key starts its own
  scan without coalescing rather than queueing (no unbounded growth, no added
  latency).
- Waiters inherit the deadline of their own invocation. A waiter whose deadline
  fires aborts its wait and returns a partial result, it does not cancel the
  shared scan for everyone else.
- A rejected shared scan is deleted from the in-flight map immediately and never
  written to the cache.

## Privacy and safety

- No caller identifiers are stored, so the cache cannot be used to profile
  callers and cannot be poisoned by them.
- Cache entries are derived only from validated domains and network responses;
  a redirect's target host is never used as a key.
- Per-isolate only: Base44 runs multiple instances, each with its own cache, so
  the hit rate depends on routing affinity. Expected benefit is "repeat scans
  from one client collapse", not a guaranteed global hit rate.
- Memory ceiling 8 MB per isolate, which is small enough to sit alongside the
  existing `geoIp` cache (2 000 entries) without pressure.

## Observability

One structured line per invocation at most: `cache=hit|miss|coalesced`, plus
counters for evictions and admissions refused for size. No per-key logging (that
would leak the queried domains into logs).

## Out of scope

No persistence, no cross-instance cache, no cache-derived rate limiting. Rate
limiting and scan tokens remain Phase 2 topics that require explicit approval.
