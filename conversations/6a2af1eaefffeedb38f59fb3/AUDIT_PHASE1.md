# NetWatch v2.11 — Phase 1 Technical Audit

**Baseline:** v2.10.1 (versionCode 79)
**Scope:** static review of `MainActivity` (4,763 lines), `TrafficMonitorService`, `DeviceMonitorService`,
`NetWatchVpnService`, `HistoryManager`, `AppEntry`, `TrafficEntry`, `AndroidManifest.xml`,
`app/build.gradle`, and backend functions `domainIntel`, `geoIp`, `ipWhois`, `trafficProbe`.
**No code was modified.** Findings marked *(runtime confirmation needed)* were not reproducible without a device.

---

## 1. Architecture snapshot

Single-activity Android app. All seven feature tabs live in one `MainActivity`; three
foreground services do the background work.

```
Traffic tab  ──> TrafficMonitorService (TrafficStats poll 1/s)
                     ▲ LocalBroadcast "DEVICE_TRAFFIC"
Device tab   ──> NetWatchVpnService (VpnService, packet capture, UID attribution)
                     │
                     └─> ConnectivityManager.getConnectionOwnerUid()
Tools tab    ──> local sockets / ping binary / mDNS / SSDP (no service)
Domain tab   ──> domainIntel backend (public, unauthenticated)
Checker tab  ──> inline DNS + HTTP HEAD probes
Services → LocalBroadcastManager → Activity receiver → UI
```

Dependencies (v2.9.3+): appcompat 1.8.0, activity 1.13.0, material 1.14.0, recyclerview 1.4.0,
constraintlayout 2.2.2, localbroadcastmanager 1.1.0. No third-party HTTP client, no DI, no tests.

---

## 2. Confirmed defects

### Critical / High

**D1 — VPN engine cannot carry a TCP stream** `NetWatchVpnService.forwardTcp()` (line 254)
A new socket is opened per packet, the raw TCP payload is written with no handshake, no
sequence tracking, no response relay, then closed. The original packet is also written back
into the tun (`out.write(pkt, 0, len)`). A TCP stream cannot survive this. Consequence: while
monitoring runs, other apps' TCP traffic is either dropped or bypasses the tunnel; the host
log still populates because detection is passive. *(runtime confirmation needed: start
monitoring, load a page in another app.)*
Impact: functional, potentially severe. Complexity to fix: **L (3–5 days)** — needs a real
per-connection relay with state, or a redesign of the capture strategy.

**D2 — UDP path spawns a socket and thread per packet** `forwardUdp()` (line 274)
`DatagramChannel` per UDP datagram, 2 s blocking receive, a single response relayed, socket
closed. With `newCachedThreadPool()` (line 68) this is unbounded thread and FD creation.
QUIC, DHCP, and multi-packet DNS break; battery and CPU spike on any active device.
Impact: high. Complexity: **M (2–3 days)**.

**D3 — Service restart silently switches to whole-device mode**
`TrafficMonitorService` returns `START_STICKY` (line 148) but stores `targetUid`/`targetPkg`
only from the intent. On system restart the intent is null → `targetUid = -1` → the service
reports **all device traffic** under a per-app session, with no UI indication.
Impact: privacy, correctness. Complexity: **S (0.5 day)** — persist target in
SharedPreferences and restore.

**D4 — Duplicate monitor jobs** `DeviceMonitorService.onStartCommand()` (lines 63–66)
New `scheduler`/`dnsExecutor` created on every start without shutting the previous ones down.
A second start doubles the poll rate and duplicate broadcasts.
Impact: performance. Complexity: **XS** (guard with a null check).

### Medium

**D5 — Notification ID collision.** Both `TrafficMonitorService` (line 56) and
`DeviceMonitorService` (line 33) use `NOTIF_ID = 43`. The VPN service uses 42. Running both
monitors makes one notification overwrite the other.

**D6 — Receiver leak** `MainActivity` (line 4530). `deviceReceiver` is registered when Device
Monitor starts and unregistered only in `stopDeviceMonitor()`. `onDestroy()` (line ~3813)
unregisters only `trafficReceiver`. Activity recreation with monitoring active leaks the
receiver and duplicates rows.

**D7 — Blocking disk I/O on the UI thread.** `stopMonitoring()` calls
`HistoryManager.save(this, s)` (line 976) directly; JSON serialisation plus file write of every
logged host runs on the main thread.

**D8 — Spoofable broadcast.** `trafficReceiver` registered `RECEIVER_EXPORTED` (line 361).
Broadcasts use `setPackage()`, so `RECEIVER_NOT_EXPORTED` would work; as written any app can
inject fabricated traffic events into the UI.

**D9 — No timeout on name resolution.** `InetAddress.getByName()` in
`NetWatchVpnService` (line 388), `DeviceMonitorService.resolveAndEmit()` and
`TrafficMonitorService.onNewActiveIp()` (line 216) has no bound. A slow resolver saturates the
4-thread pools and queues back up.

**D10 — Unbounded map growth.** `NetWatchVpnService.seenKeys` (line 46) is written at lines 174
and 242 and never pruned. Long sessions accumulate one entry per unique destination forever.

**D11 — Domain Checker collapses every failure into "blocked"** `probeHost()` (line 4054).
Returns `[reachable, latency]` only. DNS failure, sinkhole, TCP refusal, TLS failure and HTTP
blocking are indistinguishable. `InetAddress.isReachable()` also commonly fails on Android
(no raw ICMP), producing false negatives.

**D12 — Cleartext third-party geo lookups.** `geoIp.ts` posts every destination IP to
`http://ip-api.com/batch` over plain HTTP, no server-side cache, no 429 handling. Privacy
exposure (user's destinations to a third party) and a free-tier rate-limit failure mode.

**D13 — Release signing secrets in plaintext.** `app/build.gradle` lines 19–22 hold
`storePassword`/`keyPassword` in clear text, the keystore sits in the project directory, and
there is no `.gitignore`. Publishing the source as-is would leak the signing key.

**D14 — Backend functions are public and unauthenticated.** All four declare
"no auth required", no rate limiting, and `domainIntel` performs ~150 DNS brute-force queries
plus crt.sh and up to 200 subdomain lookups per call. Anyone can drive cost and traffic.

### Low

**D15 — Manifest hygiene.** `allowBackup="true"` (line 17) exposes monitoring history to cloud
backup; `usesCleartextTraffic="true"` (line 23) is global; `extractNativeLibs="true"` is moot
with no native libs.

**D16 — Verbose logging in release.** `DeviceMonitorService.emit()` logs host + port and
`NetWatchVpnService.emit()` logs `EMIT proto host:port uid=`. Destinations end up in logcat.

**D17 — Unguarded `startForeground`.** Neither service catches
`ForegroundServiceStartNotAllowedException` (Android 12+ background start restriction).

**D18 — Structural debt.** `MainActivity` is 4,763 lines with duplicated imports
(`HttpURLConnection` imported twice, lines 29 and 54). No `src/test` or `src/androidTest`
source sets exist, so Phase 7's "run existing tests" has nothing to run.

### Inefficiencies (no functional defect)

- **E1** Traffic Monitor broadcasts stats every second regardless of whether the UI is visible;
  `updateStats()` rewrites four TextViews and recomputes colours each time.
- **E2** Domain Intel has no client-side cache and no cancellation. Repeated taps launch
  concurrent backend scans on an unbounded `newCachedThreadPool`; each costs 20 s+ and hundreds
  of DNS queries.
- **E3** `seedDomainsFromBackend()` runs a full Domain Intel scan on every monitoring start,
  then forward-resolves every returned subdomain on a 6-thread pool.
- **E4** `DeviceMonitorService` still polls `/proc/net/{tcp,tcp6,udp,udp6}` every second even
  though the file is restricted to the app's own sockets on Android 10+, so the poll usually
  yields nothing.
- **E5** `SimpleDateFormat` allocated per emitted connection.
- **E6** `Foundation`: `TrafficMonitorService.broadcastNewHosts()` emits TX/RX totals but
  hardcodes rates to 0.

---

## 3. Overlap with the proposed v2.11 phases

| Proposed | Already present | Gap |
|---|---|---|
| Phase 2 DNS A/AAAA/MX/NS/TXT/CNAME | A/AAAA/CNAME/TXT in Tools DNS; A/AAAA/CNAME in backend | MX/NS absent in backend; no timing data; no resolver choice |
| Phase 2 TLS expiry | Certificate-transparency names only | No certificate date/validity anywhere |
| Phase 2 WHOIS/RDAP | `ipWhois` function exists | No caching, no rate-limit handling, errors surfaced raw |
| Phase 3 UID attribution | `getConnectionOwnerUid`, strict drop policy | Already good; must not be "improved" into guessing |
| Phase 3 IP/port/proto/timestamp | Present (HH:mm:ss only) | No date, no filters, no JSON export |
| Phase 3 DNS↔connection correlation | Heuristic: reverse DNS + companion-domain seeding | No true DNS-query→connection association |
| Phase 4 block diagnostics | Domain Checker binary result | Entire diagnostic split is missing (D11) |
| Phase 5 duplicate jobs | None | D4 |
| Phase 5 configurable intervals | Hardcoded 1000 ms | No preference storage |
| Phase 5 bounded concurrency | Cached/unbounded pools | D2, E2 |
| Phase 5 redacted logging | None | D16 |
| Phase 6 dashboard / search / sort | None | — |
| Phase 6 theme | Terminal dark only (light theme removed in v2.4.2) | Intentional; do not reintroduce without approval |
| Phase 7 tests | None exist | Greenfield |

---

## 4. Prioritised roadmap

**P0 — Stabilisation (no user-visible change), ~2 days**
D13 secrets out of VCS · D3 persist target · D4 scheduler guard · D5 notification IDs ·
D6 receiver unregister · D7 off-thread history save · D8 receiver not exported ·
D10 prune `seenKeys` · D17 startForeground guard.

**P1 — Network correctness, ~5–8 days**
D1/D2 VPN forwarding redesign (decision required: full relay vs. DNS-only capture) ·
D9 bounded DNS resolution · E1 visibility-aware UI updates · E2 scan cancellation + cache.

**P2 — Diagnostic accuracy, ~3–4 days**
D11 five-way failure classification; D12 HTTPS + caching for geo; D16 log redaction;
D14 auth/rate limiting on backend.

**P3 — Feature work (Phases 2, 3, 6) and Phase 7 tests** — only after P0/P1 sign-off.

## 5. Complexity summary

| Item | Estimate |
|---|---|
| P0 batch | 2 dev-days |
| D1 TCP relay | 3–5 dev-days (L) |
| D2 UDP path | 2–3 dev-days (M) |
| D11 checker diagnostics | 2–3 dev-days (M) |
| D12 geo HTTPS + cache | 0.5 day (S) |
| D14 backend auth/limits | 1–2 days (M) |
| Test harness + CI | 3–4 days (L) |

## 6. Open questions requiring a decision

1. **D1**: should the VPN act as a true forwarder (heavy, high risk) or should monitoring be
   limited to capture-with-consent while the system handles traffic? This determines whether
   P1 is 2 days or 2 weeks.
2. Should `allowBackup` stay true (history backed up) or be disabled for privacy?
3. Is the source project ever intended to be published? This decides how aggressively D13 must
   be treated (rotate key vs. move to `keystore.properties`).
