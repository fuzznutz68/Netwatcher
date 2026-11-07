# Compatibility assessment — Android and Windows clients vs Phase 1

Verified from source, not assumed. Every claim below cites the line that sends
the request, and every case is replayed as a test in `tests/e2e.test.mjs` and
`tests/config.test.mjs`.

## What the clients actually send

### Android (v2.10.6, Build 88)

| Call site | Method | Headers | Body | Read timeout |
|---|---|---|---|---|
| `MainActivity.postJson` → `domainIntel` (`MainActivity.java:4036-4050`, used at `:1523`, `:1794`) | POST | `Content-Type: application/json` only | JSON, UTF-8 | 30 000 ms |
| `TrafficMonitorService.postJson` → `domainIntel`, `geoIp` (`TrafficMonitorService.java:599-613`, used `:312`, `:500`) | POST | `Content-Type: application/json` only | JSON, UTF-8 | 20 000 ms |
| WHOIS dialog → `ipWhois` (`MainActivity.java:5142-5146`) | **GET** | none at all | none | 8 000 ms |

Notes that matter:

- `HttpURLConnection` sends **no `Origin`** header. CORS never applied to these
  callers, which is why removing the wildcard is invisible to them.
- No `Accept` header, no custom headers, no cookies.
- `ipWhois` is a **bodyless GET with a query string**. A blanket
  "JSON content type required" rule would have broken the WHOIS dialog. The gate
  therefore exempts `GET`/`HEAD`/`OPTIONS`; this is the single most important
  compatibility constraint in the patch.
- Retry behaviour: `postJson` returns `null` on any exception, and the callers
  already treat an empty body as "no data". A `415`/`405` would look like "no
  data" to the Traffic Monitor, which is why those statuses must never appear for
  a legitimate client.

### Windows desktop (WPF, .NET 8)

| Call site | Method | Headers | Body | Timeout |
|---|---|---|---|---|
| `MainWindow.xaml.cs:528-529` → `domainIntel` | POST | `Content-Type: application/json; charset=utf-8` (from `StringContent(payload, Encoding.UTF8, "application/json")`) | JSON | 20 s (`HttpClient.Timeout`, `:31-34`) |

- `IP_WHOIS_URL` is declared at `:22` but **never used**; desktop has no WHOIS
  path today, so `ipWhois` changes cannot affect it.
- The `; charset=utf-8` parameter is why the gate parses the media type instead
  of comparing the raw header. A naive `=== 'application/json'` check would have
  locked out every desktop user.

### Nothing else calls these functions

No web frontend exists in the repo, and the live CORS audit found no
browser-origin traffic evidence. Default CORS is therefore *deny*, which changes
nothing for shipped clients while removing drive-by browser use.

## What Phase 1 changes, per client

| Change | Android | Windows desktop |
|---|---|---|
| `Access-Control-Allow-Origin: *` removed | no effect (no Origin sent) | no effect |
| `OPTIONS` → 204 with explicit methods, no wildcard | no effect (never sends OPTIONS) | no effect |
| POST body must be `application/json` (params allowed) | passes, sends exactly that | passes, sends `; charset=utf-8` |
| `domainIntel` becomes POST-only (`GET`/`PUT`/… → 405) | passes (POST only) | passes (POST only) |
| `ipWhois` keeps `GET` with no content type | passes (WHIS dialog path untouched) | n/a (unused) |
| `geoIp` POST-only, JSON-only | passes | n/a (unused) |
| 12 s wall-clock deadline on `domainIntel` (env-tunable, clamped 1–20 s) | **behaviour change**: a scan that used to run past the 20 s socket timeout now returns partial data at 12 s | same, below its 20 s timeout |
| `truncated` field added to the response | ignored (`org.json` `opt*` accessors) | ignored (`TryGetProperty` accessors) |
| crt.sh capped at 400 KB while reading | no effect on shape; fewer subdomains on gigantic zones | same |

Additive JSON fields are safe for both clients: Android reads with
`optJSONArray`/`optString` (`MainActivity.java:1807-1811`, `:2053`, `:2122`) and
desktop uses `TryGetProperty`, so unknown keys are ignored rather than fatal.

## Residual compatibility risk

The only way to break a caller now is a caller that (a) POSTs without a JSON
content type, or (b) uses a method other than POST/GET. Neither shipped client
does, and no third-party consumer is known. If one appears, it fails closed with
`415`/`405` and a clear message rather than being silently served.

## Verification plan for the deployment window (not yet authorised)

1. `curl` matrix against the *staging* deploy: POST with the exact Android
   header set, POST with the desktop header set, `GET /ipWhois?ip=8.8.8.8`,
   `OPTIONS` with a hostile origin, POST with `text/plain` (expect 415), `PUT`
   (expect 405), malformed JSON (expect 400), `127.0.0.1` (expect 400).
2. Android tablet smoke test: Domain Intel scan, Traffic Monitor trace with geo
   lookups, WHOIS dialog for one IPv4 and one IPv6 address.
3. Desktop: one Domain Intel scan.
4. Rollback: redeploy `baseline/<name>.ts`; behaviour returns to wildcard CORS and
   no deadline. Single function at a time, in the order `ipWhois` → `geoIp` →
   `domainIntel` so a regression is isolated immediately.
