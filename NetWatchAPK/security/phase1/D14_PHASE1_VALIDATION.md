# D14 Phase 1 — final validation report

Branch `d14/phase1-cors-json-deadline`, cut from tag `v2.10.6` (`59a60517`).
**Nothing deployed. No staging copies created. Production functions untouched.**
D14 remains **PARTIALLY MITIGATED**.

## Why validation was not performed on staging

No isolated staging environment exists: Base44 provides one function runtime per app,
`deploy_backend_function` has no environment target, and no staging app exists in the
account. Creating suffixed copies inside the production app was explicitly refused by
the owner because those endpoints would share production infrastructure and be
publicly reachable without real isolation.

Validation was therefore performed on the **real Deno runtime (2.9.8)** locally: the
patched TypeScript files were imported natively, their `Deno.serve` handlers captured,
and driven with real `Request`/`Response` objects and real outbound network. This
exercises the same runtime and the same code that would ship; it does not exercise
Base44's egress path, its edge, or its per-invocation limits.

## Changes made since the review package

Four defects found and corrected, all inside Phase 1 scope:

| # | Defect | Consequence if shipped | Correction |
|---|---|---|---|
| 1 | `nwReadCapped` fell back to `res.text()` when a body had no stream reader | Whole body buffered → unbounded memory on any non-streaming response | Fail closed: body cancelled unread, returns `{bytes:0, truncated:true, unreadable:true}` |
| 2 | `domainIntel` and `geoIp` DoH reads used `await r.json()` | Entire DNS JSON buffered before the cap applied | Routed through `nwReadJson` (256 KB cap, truncation is a failure) |
| 3 | `ipWhois` RDAP read used `(await r.text()).slice(0, 200000)` | Whole RDAP body buffered, trimmed afterwards | Routed through `nwReadCapped` (200 KB, truncation is a failure) |
| 4 | crt.sh shared the whole invocation deadline (20 s timeout merged with it) | One hung CT query consumed the entire budget: scans returned `truncated:true` with **zero** subdomains | Dedicated 6 s sub-budget (`NW_CRTSH_MAX_MS`), below the deadline |

Defect 4 was reproduced live before the fix: `wikipedia.org` returned at 12 013 ms
with `subdomains: 0, truncated: true`. After the fix: 6.3 s, `truncated: false`,
`subdomains: 14`.

## 1. Test suite — 56/56

```
./tests/run.sh
  1/3 transpile patched handlers (tsc 5.4)
  2/3 generator reproducibility
  3/3 node --test
# tests 56   # pass 56   # fail 0
```

| Suite | Tests | Scope |
|---|---|---|
| `nwhttp.test.mjs` | 22 | CORS, content type, capped reader (incl. fail-closed fallback, 50 MB stream), deadline, signal merge, guarded GET with redirects |
| `e2e.test.mjs` | 14 | transpiled handlers under stubbed runtime: normal, malformed, methods, preflight, oversized DoH, oversized RDAP, timeout, partial+deadline |
| `gates.test.mjs` | 11 | no wildcard CORS, gate ordering, POST-only, no whole-body reads (`text()`, `arrayBuffer()`, `.json()`), crt.sh sub-budget ≤ 6 s, no smuggled Phase 2 features |
| `config.test.mjs` | 3 | allowlist and deadline read per request, independent of import order |
| `cancel.test.mjs` | 3 | cancellation reaches fetches, no post-response work, partial results |
| `drift.test.mjs` | 3 | inlined block equals `nwhttp.mjs`, generator reproducible |

## 2. Response-size caps on the real runtime

Measured with `Deno.memoryUsage()` and an instrumented upstream server.

| Scenario | Result | Verdict |
|---|---|---|
| Endless stream, cap 400 KB | 400 000 bytes delivered, `truncated: true`, upstream produced 1.77 MB then stopped, no growth after 400 ms, RSS +8 MB | BOUNDED |
| Body with no stream reader, `text()` spy, 200 MB claimed | `text()` never called, body cancelled, `bytes: 0`, `unreadable: true` | FAIL-CLOSED |
| DoH answer of 60 000 records (3.6 MB) | HTTP 200, scan completes, errors `A: dns-json: too-large` | CAPPED |
| RDAP body of 3 MB (cap 200 KB) | HTTP 200, `rdap: response too large`, payload never parsed or returned | CAPPED |
| crt.sh response above 400 KB (live) | `crt.sh: response truncated at 400000 bytes`, scan continues | CAPPED |

Grep-level confirmation: zero `await r.json()`, `await r.text()` or `.arrayBuffer()`
calls remain in any shipped path; a test fails if one is reintroduced.

## 3. Real-Deno integration matrix

Captured against the corrected build, real network, no stubs.

| Case | Status | Time | Result |
|---|---|---|---|
| `domainIntel` POST, Android headers, `example.com` | 200 | 878 ms | ipv4 2, ipv6 2, subdomains 1, `truncated:false`, `errors: []` |
| `domainIntel` POST, Windows headers (`; charset=utf-8`), `wikipedia.org` | 200 | 5 135 ms | ipv4 1, subdomains 15, complete |
| `domainIntel` redirect-following domain (`google.com`) | 200 | 1 179 ms | `pageHosts: 8`, `crt.sh` truncated at the 400 KB cap |
| Non-JSON content type | 415 | 2 ms | rejected, no CORS grant |
| `PUT` | 405 | 2 ms | `Allow: POST, OPTIONS` |
| Preflight, hostile origin, no allowlist | 204 | 2 ms | no `Access-Control-Allow-Origin` |
| Native request, no `Origin` | 200 | 878 ms | served, no CORS header (both clients) |
| Preflight, allowlisted origin set after import | 204 | 2 ms | ACAO echoes origin, `Allow-Headers: Content-Type`, `Vary: Origin` |
| POST from allowlisted origin | 200 | 640 ms | ACAO echoes origin |
| Malformed JSON body | 400 | 3 ms | `Domain is required` |
| `127.0.0.1`, `http://169.254.169.254/`, `localhost` | 400 | 2 ms | `Invalid or disallowed domain` |
| `geoIp` IPv4 + IPv6 | 200 | 26 ms | `US (registry)`, `countryBasis: rir-registry`, `flag: 🌐`, empty city |
| `geoIp` non-JSON | 415 | 2 ms | rejected |
| `ipWhois` IPv4, bodyless GET | 200 | 42 ms | `AS15169`, `US (registry)`, `cidr 8.8.8.0/24` |
| `ipWhois` IPv6, bodyless GET | 200 | 173 ms | `AS13335`, `US (registry)` |
| `ipWhois` junk input | 400 | 2 ms | rejected |
| `ipWhois` `DELETE` | 405 | 2 ms | `Allow: GET, POST, OPTIONS` |

## 4. Deadlines, cancellation and partial results

| Deadline | Domain | Actual | Overshoot | Result |
|---|---|---|---|---|
| 1 500 ms | `wikipedia.org` | 1 514 ms | +14 ms | 200, `truncated:true`, ipv4/ipv6 kept, all schema keys present |
| 3 000 ms | `wikipedia.org` | 3 002 ms | +2 ms | 200, `truncated:true`, schema intact |
| 2 000 ms | `github.com` | 2 002 ms | +2 ms | 200, `truncated:true`, ipv4 kept |
| 12 000 ms (default) | `wikipedia.org` | 6.3 s | — | complete, 14 subdomains |
| 12 000 ms (default) | `example.com` | 0.9 s | — | complete, `errors: []` |

Cancellation verified on the real runtime: past the deadline, the signal handed to
in-flight subrequests reports `aborted === true`, the transfer stops (instrumented
upstream produced no further bytes), no fetch is issued after the response is built,
and the deadline timer is closed in `finally`. A truncated response is always HTTP 200
with the full schema and `truncated: true`, never a 5xx and never a socket error.

## 5. Client contract verification (no client modified)

| Client | Evidence | Verdict |
|---|---|---|
| Android `postJson()` | `setRequestMethod("POST")`, `Content-Type: application/json`, 15 s connect / 30 s read (`MainActivity.java:4036-4050`) | Accepted; 30 s read leaves the deadline 18 s of margin |
| Android `ipWhois` | `GET` on `?ip=` + `URLEncoder.encode(ip)`, 8 s read (`MainActivity.java:5140-5146`) | Accepted; measured 42 ms (v4) / 173 ms (v6) |
| Windows `Http.PostAsync` | `StringContent(payload, Encoding.UTF8, "application/json")` → `application/json; charset=utf-8`; `Timeout = 20 s` (`MainWindow.xaml.cs:33,528`) | Accepted by the charset-tolerant gate |
| Both clients, CORS | Java `HttpURLConnection` and .NET `HttpClient` send no `Origin` | Requests without `Origin` are served and receive no CORS header, exactly as before |

No file outside `NetWatchAPK/security/phase1/` appears in the branch diff
(`git diff --name-only v2.10.6..HEAD`), so neither client, the APK, nor any v2.10.6
artifact changed.

## 6. Compatibility with the production functions

Same inputs, production versus patched, key sets compared directly:

- `domainIntel`: identical 15 keys, plus one additive field `truncated`.
  `optBoolean("truncated", false)` semantics mean no client behaviour changes.
- `ipWhois`: identical 17 keys, byte-for-byte the same names, including the
  pre-existing `asn_name`/`rdap_name` mismatch the client ignores.
- `geoIp`: identical `results[ip]` shape (`country`, `countryCode`, `city`, `org`,
  `flag`, `registryCountry`, `countryBasis`).

Behavioural differences, all intentional:

1. Browser-origin requests are refused unless `NW_ALLOWED_ORIGINS` lists them; native
   clients are unaffected because they send no `Origin`.
2. `POST` bodies must be JSON (`415` otherwise); `ipWhois` keeps its bodyless `GET`.
3. Non-allowlisted methods return `405` with an `Allow` header.
4. `domainIntel` may return `truncated: true` and fewer results for very heavy domains
   (see 7 below).
5. `geoIp` was not referenced by any current client source (`MainActivity.java` points
   only at `domainIntel` and `ipWhois`), so its patch carries no client risk.

## 7. The one user-visible trade-off

Production took 20.8 s on `github.com`, which completes on Android (30 s read) but
already fails on Windows (20 s `HttpClient` timeout). With the 12 s deadline both
clients receive a partial-but-usable report instead of one full report and one timeout.
If depth matters more than the Windows path, set `NW_DEADLINE_MS=20000`; it is clamped
to 1 000–20 000 ms and stays under Android's 30 s read.

## 8. Remaining security risks (D14 stays PARTIALLY MITIGATED)

1. **No authentication** on any of the three functions.
2. **No rate limiting**; `domainIntel` remains expensive per call.
3. **CORS and JSON enforcement do not stop `curl`**; they stop browser-driven abuse
   only.
4. **DNS rebinding is unmitigated**: requests are issued by hostname, so the runtime
   re-resolves at connect time. Pinning is designed but unproven on this runtime
   (`PINNING_INVESTIGATION.md`).
5. **No audit logging**: abuse stays invisible in function logs.
6. **CNAME/pageHosts defect** (pre-existing, unfixed by design): see
   `CNAME_PAGEHOSTS_DEFECT.md`.
7. **Validation was not run on Base44's own egress or edge**, so per-invocation
   limits, cold-start behaviour and egress IP reputation remain unmeasured.
8. **Everything is per isolate**: no cache exists, and the deadline is per invocation.

## 9. Recommendation

**GO — conditional**, for deploying the three functions to production on separate
explicit authorization, in this order:

1. `ipWhois` — zero behaviour change, highest-value hardening (RDAP cap).
2. `geoIp` — zero behaviour change, unused by current clients.
3. `domainIntel` — carries the deadline and the `truncated` field; verify on the tablet.

Conditions:

- Verify each function immediately after its deploy with the checklist in
  `PHASE1_REPORT.md` §7, then confirm on the Android tablet before the next.
- Decide `NW_ALLOWED_ORIGINS` deliberately: if no browser client is intended, leave it
  unset and every browser origin is refused. Setting it re-opens a controlled surface.
- Keep the 12 s default unless Windows depth is dropped from scope.
- Rollback is a redeploy of `baseline/<name>.ts`, one function deep.

**NO-GO** for anyone reading this as full D14 remediation: authentication, rate
limiting, egress ACLs and rebinding remain open.

Nothing has been deployed, merged, rebuilt or released. Branch is local.
