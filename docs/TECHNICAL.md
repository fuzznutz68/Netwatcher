# Technical reference

Describes the source shipped as **v2.10.6 (Build 88)** — tag
[`v2.10.6`](https://github.com/fuzznutz68/Netwatcher/tree/v2.10.6), commit
`59a60517862f2db8d33e79aa05f917aa8fe6d26f`. Project root: `NetWatchAPK/`.

## Build configuration

| | |
| --- | --- |
| Application id | `com.netwatch.net` |
| versionCode / versionName | `88` / `2.10.6` |
| minSdk / targetSdk / compileSdk | 30 / 36 / 36 |
| Language | Java, single-activity app |
| Build | Gradle 8.13 wrapper, Android Gradle Plugin with R8 minification for release |
| Signing | `netwatch-release.keystore` via untracked `keystore.properties` |

Since v2.10.6 the tag and the internal `versionName` agree. Earlier releases (through
v2.10.5) kept a frozen internal name because the APK was the exact artifact that passed
tablet testing; a re-publish must never rename a tested build.

Build a release APK:

```bash
cd NetWatchAPK
./gradlew :app:assembleRelease
# app/build/outputs/apk/release/app-release.apk
```

Signing material is never committed. `keystore.properties` and the keystore itself are
excluded from source archives; see [SECURITY.md](SECURITY.md).

## Architecture

Single `MainActivity` hosting a tab strip; three background services; a set of backend
functions for intelligence that cannot be computed on-device.

```
MainActivity
├── Traffic tab   → TrafficMonitorService (per-app stats) + shared VPN capture
├── Device tab    → DeviceMonitorService + shared VPN capture
├── Domain Intel  → backend /domainIntel (+ deep scan)
├── Domain Check  → direct reachability probes
├── Tools         → Ping / Trace / Port / DNS / LAN / WHOIS
└── Speed, My Info
```

`NetWatchVpnService` is one shared capture engine. Both monitoring tabs set flags
(`trafficVpnEngineActive`, device-monitor running) and the service is reference counted, so
stopping one tab does not tear down the tunnel while the other still needs it.

## Capture pipeline

1. `NetWatchVpnService` reads connection metadata from the loopback VPN interface; it does
   not forward payloads.
2. The owner UID of each connection is resolved with
   `ConnectivityManager.getConnectionOwnerUid`.
3. Filtering runs before anything is broadcast to the UI:
   - drop loopback, link-local, RFC1918/private, multicast and broadcast destinations;
   - drop well-known public DNS resolver addresses regardless of port (catches DoH on 443);
   - drop connections whose owner UID cannot be confirmed.
4. Traffic Monitor additionally keeps only connections whose UID equals the selected app.
5. Rows are broadcast to the activity; Traffic Monitor keeps a session log that is saved to
   history on STOP, and TX/RX are measured against a baseline captured at START.

## Device Monitor row rendering

The receiver derives the displayed address from the `ipPort` extra with
`splitServiceIpPort(...)`, the same helper the row renderer uses. That helper treats a
trailing `:port` as a separate field while keeping a bare full-form IPv6 address intact.

Build 87 replaced an IPv4-only `ipPort.split(":")[0]` in the receiver. Consequences of the
old line: `2a03:2880:f382:90:face:b00c:0:8e:443` displayed as `2a03`, which then looked like
a resolved hostname and produced a "Copy Hostname" entry plus a truncated WHOIS title.
Verified in the shipped bytecode: `MainActivity$4.onReceive` calls the helper and takes
element `[0]`; no `String.split(":")` remains in that method.

## WHOIS

- Input validation: literal IPv4/IPv6 only, public addresses only. Domains and
  private/loopback/link-local/reserved ranges are rejected locally before any request.
- IPv6 parsing distinguishes a bare address from a service-formatted `addr:port` string by
  treating the last colon as the port separator only when it is followed by digits and the
  remainder still parses as a literal.
- Concurrency: an `AtomicBoolean` slot acquired with `compareAndSet` guarantees one request
  in flight; a second attempt is refused, not queued.
- Backend: `ipWhois`, which returns registry data from RIR sources (RDAP where available)
  plus Team Cymru ASN lookup over DNS-over-HTTPS.
- Response handling distinguishes HTTP 400, 429, 5xx, timeout, unreachable host, malformed
  body and JSON with `null` values. Field reads go through an `optText` helper that treats
  JSON `null` as empty, with legacy key fallbacks (`asnName`, `netName`, `abuse`).

## CSV export

Both tabs build CSV in memory, write it under `getExternalFilesDir(null)/NetWatch/` and share
it through `FileProvider`. `res/xml/file_provider_paths.xml` declares:

- `cache-path` → Domain Intel report export;
- `external-files-path …/NetWatch/` → Device Monitor and Traffic Monitor logs (Build 86 fix;
  before it the provider rejected paths outside `cache/`).

Traffic Monitor session CSV uses `timestamp,host_or_ip` with RFC 4180 quoting.

## Lifecycle

`onTaskRemoved` in all three services stops the foreground notification and calls
`stopSelf()`, so removing NetWatch from Recents ends capture without needing Usage Access.
Notifications use channels created before `startForeground()` — a fresh install in Build 85
crashed when that ordering regressed, which is why channel creation stays at service start.

## Version labels in the UI

Anything that displays a version reads it at runtime through `installedVersionName()`
(`PackageManager.getPackageInfo(...).versionName`), which returns `""` on failure so callers
can degrade to a bare label. The Tools footer used a hardcoded `v2.10.1` until build 88;
never reintroduce a literal version string in UI code.

## Localisation

English and Russian strings live in code with a `refreshUiStrings()` pass that re-applies
every label after view initialisation. It is called after all views exist to avoid null
dereferences on launch; new UI must follow the same ordering.

## Tests

Two JVM suites run against production helpers extracted verbatim from the source:

| Suite | Assertions | Covers |
| --- | --- | --- |
| Harness2 | 131 | WHOIS input validation, IPv4/IPv6 host:port splitting, field mapping, HTTP status mapping |
| DmRows | 60 | Device Monitor receiver → row → menu → WHOIS argument and title pipeline |

Total 191 assertions, 0 failures on the Build 87 tree. Suites live outside the app module so
they can exercise private statics without widening production visibility.

## Versioning and releases

- Tag name is the marketing version (`v2.10.5`); the APK keeps its tested internal identity.
- Release assets always include the APK, `BUILD_INFO.txt`, `SHA256SUMS.txt` and, from
  v2.10.5, a source archive with a per-file manifest.
- `main` holds documentation; release source lives on its tag. Earlier release tags
  (`v2.9.2-release`, `v2.9.3-release`, `v2.10.1-release`) predate that convention and point
  at the repository's June 2026 tree, so use the tag for v2.10.5 when you need matching
  source.
