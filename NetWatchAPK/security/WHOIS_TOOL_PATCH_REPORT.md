# WHOIS patch - verification of the six review points

HEAD `86d1022c` on `feat/whois-network-tool`. Artifact
`security/patches/whois-tool.diff`, sha256
`9773ee013d65ada6c7dfb14d9f6af0e54ee5dc6a6353ee0931f00c9b95296328`, two files,
+346 / -31.

## The artifact you reviewed was stale - my error

The diff I handed you last round was a copy made before the corrections, so it
still showed `volatile boolean whoisInFlight` and `splitIpPort`. I regenerated
the file in the worktree but uploaded the old copy from the conversation folder
without re-copying it. Checksums of the two files disagreed
(`b269d440...` worktree vs `e3eb14ab...` uploaded), which is exactly your
observation. Fixed at the source: the delivered file is now copied after
generation and hash-verified against the worktree before upload. Both are now
`9773ee01...`.

Revision map:

| Commit | Content |
|---|---|
| `55cd3d13` | first implementation - what you received in error |
| `77a16d53` | IP-only input, service-format parser, AtomicBoolean, single dialog |
| `86d1022c` | HTTP outcome classes and transport-failure messages (this review) |

## 1. Service format vs bare IPv6

`splitIpPort` no longer exists. `splitServiceIpPort` is called from exactly one
place, `buildDeviceRow`. It refuses to split unless the colon count matches a
wire shape `NetWatchVpnService` can actually produce: `ipv6()` formats sixteen
bytes as eight uncompressed groups and `emit()` appends `":" + port`, so IPv4 is
one colon and IPv6 is eight. Anything else is returned whole.

    $ java Evidence        (methods extracted verbatim from the patched file)
    1.2.3.4:443                     -> ip=[1.2.3.4]                     port=[443]
    2606:4700:4700:0:0:0:0:1111:443 -> ip=[2606:4700:4700:0:0:0:0:1111] port=[443]
    [2606:4700:4700::1111]:443      -> ip=[2606:4700:4700::1111]        port=[443]
    2606:4700:4700::1111            -> ip=[2606:4700:4700::1111]        port=[]   <- intact
    2606:4700:4700:0:0:0:0:1111     -> ip=[2606:4700:4700:0:0:0:0:1111] port=[]   <- intact
    2001:db8::/32                   -> ip=[2001:db8::/32]               port=[]   <- intact
    1.2.3.4:abc                     -> ip=[1.2.3.4:abc]                 port=[]   <- intact

The full-form bare address has seven colons and is not split. A truncated
address cannot reach WHOIS because the split is accepted only when the port is
1-5 digits <= 65535 and the prefix is a valid literal.

## 2. Concurrency guard

`whoisInFlight` is `AtomicBoolean` (line 4916), claimed through
`acquireWhoisSlot`, which is `compareAndSet(false, true)`; released in `finally`.
No `volatile boolean` and no separate check-then-assign remains anywhere in the
source or in the delivered diff (grep count 0).

    first  claim = true
    second claim = false  (blocked while in flight)
    after release = true

`showWhoisDialog` additionally dismisses a visible predecessor, so results
replace rather than stack.

## 3. Validation runs before the request

`showIpWhois` order is: normalize -> empty check -> `isIpLiteral` -> claim slot ->
`Toast` -> `executor.execute`. The network call is unreachable for a non-literal.

    isIpLiteral(1.1.1.1)              = true
    isIpLiteral(2606:4700:4700::1111) = true
    isIpLiteral(google.com)           = false
    isIpLiteral(1.1.1.1:443)          = false
    isIpLiteral(192.168.1.1)          = true   (shape ok; backend answers 400)

Private/reserved ranges are deliberately left to the backend, which owns the
public-address policy and answers 400; duplicating that list on the client would
drift. No name resolution was added.

## 4. HTTP 400 vs 429 vs 5xx vs transport failure

Previously only 400 was special-cased and everything else surfaced as
`WHOIS failed: HTTP n`. Now `whoisHttpClass` maps the status and
`whoisHttpMessage` supplies the wording; `WHOIS_OK` returns `null` so a success
can never be labelled a failure.

    HTTP 200 -> class 0  (success, no message)
    HTTP 400 -> class 1  Not a public IP address...                        (dialog)
    HTTP 429 -> class 2  WHOIS: provider rate limit reached...             (toast)
    HTTP 500 -> class 3  WHOIS: provider unavailable (HTTP 500)...         (toast)
    HTTP 503 -> class 3  WHOIS: provider unavailable (HTTP 503)...         (toast)
    HTTP 504 -> class 3  WHOIS: provider unavailable (HTTP 504)...         (toast)
    HTTP 404 -> class 4  WHOIS: request failed (HTTP 404)...               (toast)

Transport failures are separate catches: `SocketTimeoutException` -> timed out;
`UnknownHostException` / `ConnectException` -> cannot reach the service;
`JSONException` -> unexpected response. Only 400 shows the dialog, because only
400 means "your address", the rest mean "not now".

## 5. Russian strings

Both files are valid UTF-8 with zero U+FFFD and no double-encoded sequences. The
new strings read back from disk:

    Введите IP-адрес.
    WHOIS работает только с IP-адресами.
    WHOIS уже выполняется
    WHOIS: превышено время ожидания
    WHOIS: превышен лимит запросов.
    WHOIS: сервис недоступен (HTTP 503).
    WHOIS: ошибка запроса (HTTP 404).
    WHOIS: нет соединения с сервисом
    WHOIS: неожиданный ответ сервиса
    RDAP недоступен для этого адреса

## 6. Domain Intel help text

The remaining claim reads "Geo-IP location of the server" / "Geo-IP локация
сервера". It is accurate: `buildReport` performs its own `ipinfo.io` lookup per
IPv4 A record and prints flag, country, city and org. That tab does not use the
Cymru-backed `geoIp` function, so no registry-only data is presented as a
physical location. Caveat worth knowing: the geo line is produced for IPv4
records only; IPv6 addresses are listed without a location, which the help text
does not claim either way.

The genuinely false line - "WHOIS registration info" in that same dialog - was
removed earlier; it now says "TLS certificate info". Verified that
`TrafficMonitorService` renders the new backend as `🌐 US (registry) · Org` with
a neutral globe and no city, so it does not present registry country as a
location.

## Tests

JVM harness, methods extracted verbatim from the patched source, `org.json`
20240303, JDK 17:

```
passed 92, failed 0
```

Covers 17 service-format cases, 20 literal-validation cases, 4 normalization
cases, 4 gate cases, 16 HTTP-class/message cases, 11 response-mapping cases.
Static: layout well-formed, six autosizing buttons, `javac` parse-only pass clean.

## Checklist for the tablet build (needs separate approval)

| Area | Check |
|---|---|
| Network Tools | six buttons readable at normal and enlarged font scale |
| WHOIS | `google.com` -> IP-only dialog, nothing sent |
| WHOIS | `1.1.1.1` -> AS13335, APNIC-LABS, AU (registry) |
| WHOIS | `2606:4700:4700::1111` -> full address queried, AS13335, US (registry) |
| WHOIS | `8.8.8.8` -> cidr plus "(RDAP unavailable for this address)" |
| WHOIS | airplane mode -> "cannot reach the service", not "not a public IP" |
| WHOIS | two lookups -> second dialog replaces the first |
| Device Monitor | long-press intact, IPv4 and IPv6 rows resolve fully |
| Traffic Trace | rows and app list identical to baseline |

## State

Baseline `de993d08` untouched, main tree sources identical to it, `domainIntel`
and `ipWhois` backends unchanged, no APK built or distributed. D14 remains
PARTIALLY MITIGATED.
