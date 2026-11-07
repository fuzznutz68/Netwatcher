# D14 Phase 1 — CORS, JSON, crt.sh cap, wall-clock deadline

Branch `d14/phase1-cors-json-deadline`, cut from tag `v2.10.6` (`59a60517`).
Nothing deployed. No release published. Build 88 and the published APK are
untouched. Live functions still serve the baseline behaviour: their source hash is
identical to `baseline/` and a live probe still returns
`access-control-allow-origin: *`.

## Test results

```
./tests/run.sh
  1/3 transpile patched handlers (tsc 5.4)
  2/3 generator reproducibility
  3/3 node --test

# tests 50   # pass 50   # fail 0
```

| Suite | Tests | What it covers |
|---|---|---|
| `nwhttp.test.mjs` | 20 | CORS shape, content-type parsing, capped reader, deadline, signal merge, guarded GET incl. redirects |
| `e2e.test.mjs` | 12 | the **transpiled patched handlers** executed under stubbed Deno/fetch: normal, malformed, methods, preflight, oversized, timeout, deadline+partial |
| `config.test.mjs` | 3 | allowlist and deadline independence from import order and from env changes mid-run |
| `cancel.test.mjs` | 3 | cancellation reaches in-flight fetches, no post-response work, controlled partial results |
| `gates.test.mjs` | 9 | source guarantees: no wildcard anywhere, gate ordering, POST-only, deadline wiring, no smuggled Phase 2 features |
| `drift.test.mjs` | 3 | the inlined block still equals `nwhttp.mjs`, module stays dependency-free, generator is reproducible |

The end-to-end suite loads `build/*.mjs` produced by `tsc` from `patched/*.ts`,
so it exercises the code that would be deployed, not a reimplementation.

## Failure triage — all 11 resolved, none by weakening an assertion

| # | Failure | Root cause | Fix |
|---|---|---|---|
| A | 7 × `domainIntel` e2e: `Cannot access 'nwGetenv' before initialization` | **Real code defect.** The generated header emitted `const NW_DEADLINE_MS = … nwGetenv(…)` *before* the inlined block defined `nwGetenv` — a temporal-dead-zone `ReferenceError` at module load. In production this would have been a 100 % broken function. | Generator reordered: module block → `nwGetenv` → per-file consts → glue. Verified by import-order tests. |
| B | `crt.sh: pulled 524288 bytes past a 400000 cap` | **Measurement error in the test.** `ReadableStream.pull` runs ahead of the consumer, so the *producer* overshoots while the *consumer* stops exactly at the cap. The production guarantee (delivered bytes capped, stream cancelled) was correct. | Assert the real invariants: delivered `bytes === 400000`, `cancelled === true`, overshoot bounded to a buffer window, plus a new 50 MB body test proving the download stops. |
| C | `deadline: … still pending but the event loop has already resolved` | **Harness.** `nwDeadline` unrefs its timer (correct for production: a finished request must not hold the runtime open); nothing kept the test process alive. | Test-local keepalive interval, with a comment explaining the interaction. |
| D | 2 × gates: stale anchors (`nwDeadline(NW_DEADLINE_MS)`) | Test expected a shape the generator had changed to the lazy `nwDeadlineMs()`. | Assertions updated to the new contract. |
| E | gates: "geoIp added caching" | **False positive.** `geoIp` ships a bounded TTL cache in the *baseline*; the assertion was meant to prove Phase 1 added no cache. | Scoped the assertion to `domainIntel`, where the cache is design-only. |

Two further observations from this round, both corrected in the tests rather than
in the code:

- A page fetch for `www.<domain>` never happens if `www` has no DNS record: the
  existing `checkResolved` rejects an empty resolution set. Tests now stub an `A`
  record for `www` and the clean-path test asserts `errors: []`.
- The exclusion scan matched the module's own doc comment ("token buckets, scan
  tokens"), so it now runs against comment-stripped code.

## 1. The 12 s deadline versus the observed 10.9 s

Measured live against the current deployment (read-only, three calls):

| Domain | Duration | Result |
|---|---|---|
| `wikipedia.org` | 4.17 s | complete |
| `example.com` | 8.97 s | complete (10.87 s in the earlier audit) |
| `github.com` | **20.81 s** | complete, 15 page hosts — and already **past** the 20 s client read timeout |

So the 12 s budget sits between the median and the tail: 3 of 4 sampled domains
finish inside it, and the slowest one was previously failing at the client
anyway. `github.com` at 20.8 s exceeds the Windows `HttpClient` timeout (20 s)
and the Android service read timeout (20 s) *today*, which means the current
production behaviour for such domains is a socket timeout and `postJson`
returning `null` — the app shows nothing.

**User-visible behaviour after Phase 1, verified by test:** HTTP **200** with the
complete normal schema, everything discovered before the deadline (`ipv4`,
`cname`, `cdn`, partial `subdomains`, already-fetched page data), plus
`truncated: true` and an `errors[]` entry such as `deadline: subdomain scan
stopped`. It is never a 5xx and never a client-side socket error. Android ignores
`truncated` (it reads with `opt*` accessors), so today the user simply sees fewer
results; a UI hint would be a client change and is out of scope here.

Judgement: keep `NW_DEADLINE_MS` at 12 000. It is below all three client timeouts
(20 s/20 s/30 s) with margin, it converts a hard failure into a partial success,
and it is an env knob clamped to 1–20 s if the owner wants more headroom before
deployment. Raising it to 15 s would trade 3 s of scan depth for a thinner margin
against the 20 s socket timeout.

## 2. Cancellation propagation

Verified in `tests/cancel.test.mjs` against the transpiled handler:

- Every outbound request receives an abort signal (`nwMergeSignals([per-op
  timeout, invocation deadline])`).
- When the deadline fires, the signals handed to the hanging page fetches report
  `aborted === true` with reason `deadline exceeded`, so the runtime tears the
  socket down instead of letting it finish in the background.
- No fetch is issued after the response: the fetch-call count is sampled, the
  test waits 200 ms, and the count must be unchanged.
- The deadline timer is closed in `finally`, so a completed invocation leaves no
  live timer behind (asserted by the `close()` unit test).

Residual limitation: cancellation covers requests **we** issue. It cannot recall
work already executing inside a subrequest provider (for example a crt.sh query
the remote side is still processing); that is a server-side cost we can only
bound by timeouts, which is exactly what this patch does.

## 3. crt.sh cap enforced during streaming

- The reader consumes chunks and stops at the cap, then calls
  `reader.cancel()`; the previous `await r.text()` (unbounded) is gone and a
  source-gate test fails if it comes back.
- `tests/nwhttp.test.mjs` proves it with a 50 MB body: exactly 400 000 bytes are
  delivered, the stream is cancelled, the producer never gets far past the cap,
  and the call returns in a few milliseconds instead of downloading 50 MB.
- Oversized CT data costs the scan its certificate-transparency section (the JSON
  parse of a truncated array yields nothing) and records
  `crt.sh: response truncated at 400000 bytes` in `errors[]`; the rest of the scan
  completes. Row parsing is additionally capped at 2 000 entries.

## 4. Import order and configuration independence

Configuration is read **per request**, not at import:

- `nwOrigins()` and `nwDeadlineMs()` are functions called inside the handler.
- `tests/config.test.mjs` imports the module with no allowlist, then sets
  `NW_ALLOWED_ORIGINS`, and the very next preflight/POST reflects it; clearing the
  variable revokes it immediately. The deadline test loads with 1 000 ms, measures
  ~1 s, then switches to 3 000 ms on the same module instance and measures >2.5 s.
- Requests **without** `Origin` (both shipped clients) always work and never
  receive an `Access-Control-Allow-Origin` header.
- A legitimate browser preflight from an allowlisted origin gets `204` with
  `Access-Control-Allow-Origin: <that origin>`, `Access-Control-Allow-Methods`,
  `Access-Control-Allow-Headers: Content-Type`, `Access-Control-Max-Age`, and
  `Vary: Origin`; a non-allowlisted origin gets the same `204` without the grant,
  which is what makes the browser refuse.

## 5. What changed

| File | +/− lines | Nature |
|---|---|---|
| `domainIntel.ts` | +311 / −94 | module block inline, CORS + JSON + POST-only gates, deadline wired into DNS/crt.sh/page fetches, crt.sh capped while reading, `readCapped`/`safeGet` delegated to the single shipped implementation, cancellation observability, `truncated` field, `finally { dl.close(); }` |
| `geoIp.ts` | +245 / −6 | module block inline, CORS + JSON + POST-only gates (payload and lookup logic untouched) |
| `ipWhois.ts` | +246 / −6 | module block inline, CORS + JSON + method gates; `GET` remains bodyless and exempt |
| `nwhttp.mjs` | new | canonical implementation of the four controls |
| `apply_patch.py` | new | deterministic, anchor-checked generator; fails loudly on drift |
| `tests/*` | new | 50 tests across 6 suites |
| `baseline/*` | new | byte-identical snapshots of today's deployed functions, for diff and rollback |
| `phase1.diff` | new | 1 108-line unified diff, 15 hunks |

See the diff itself in `phase1.diff`.

## 6. Remaining security limitations (unchanged by Phase 1)

Stated plainly, because the patch must not be oversold:

1. **No authentication.** All three functions remain publicly callable. Phase 1
   does not change that, and it was explicitly out of scope.
2. **No rate limiting.** Token buckets and scan tokens are excluded by the
   authorization. `domainIntel` remains expensive per call.
3. **CORS and JSON enforcement do not prevent direct API calls.** They stop a
   browser page from driving these endpoints and they raise the effort for sloppy
   automation. Anyone with `curl` is unaffected. This is a browser-abuse control,
   not an access control.
4. **Validation is still advisory (DNS rebinding).** The request is issued by
   hostname, so the runtime re-resolves at connect time. Pinning is technically
   possible but blocked on an unproven runtime socket capability; see
   `PINNING_INVESTIGATION.md`.
5. **Cost per deep scan is unchanged.** The ~130-label prefix scan still runs on
   every call; gating it behind `deep=true` was excluded from this phase.
6. **No audit log.** Nothing is emitted per request, so abuse is still invisible
   in `get_backend_function_logs`. Logging is a Phase 2 item.
7. **Everything is per isolate.** Any future cache is per instance, and the
   deadline is per invocation.

## 7. Deployment and rollback (for when it is authorized)

Order: `ipWhois` → `geoIp` → `domainIntel`, one at a time, each verified before
the next, because `domainIntel` carries the behavioural change.

Verify after each deploy:

1. `GET /ipWhois?ip=8.8.8.8` → 200, unchanged payload shape.
2. `POST /geoIp` with the exact Android header set → 200.
3. `POST /geoIp` with `text/plain` → 415; `PUT` → 405; `OPTIONS` with a hostile
   origin → 204 without `Access-Control-Allow-Origin`.
4. `POST /domainIntel {"domain":"example.com"}` with the Android header set → 200,
   `truncated: false`; the desktop header set (`; charset=utf-8`) → 200.
5. Android tablet: Domain Intel scan, Traffic Monitor trace, WHOIS dialog for one
   IPv4 and one IPv6 address.

Rollback is a redeploy of `baseline/<name>.ts`, which returns wildcard CORS and no
deadline. Because each function is independent, a rollback is one function deep.

## 8. Not done, awaiting instructions

- No cache code (design in `CACHE_DESIGN.md`), no pinning code (investigation in
  `PINNING_INVESTIGATION.md`), no client changes, no logging.
- No deploy, no release, no tag, no push. The branch is local: nothing has left
  this workspace.
