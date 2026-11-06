# NetWatch v2.11 — P0 Stabilization Checklist (for approval)

Status: PROPOSED — not implemented. Awaiting scope confirmation.
Baseline: v2.10.1 (versionCode 79)
Excluded from P0 by instruction: D1 (TCP architecture), D2 (UDP architecture)

---

## 1. Exact P0 scope

### 1.1 Security — first

| ID | Defect | Change | Files | Est. |
|----|--------|--------|-------|------|
| P0-01 | Signing passwords hardcoded | Read keystore path/alias/passwords from `keystore.properties` (gitignored) or env vars; fail build with a clear message if absent | `app/build.gradle` | S |
| P0-02 | Keystores and secrets not ignored | `.gitignore`: `*.keystore`, `*.jks`, `keystore.properties`, `local.properties`, `.agents/.memory/` | `.gitignore` | XS |
| P0-03 | Verbose destination logging in release | Gate host/UID logging behind `BuildConfig.DEBUG`; redact host in release builds | `NetWatchVpnService`, `DeviceMonitorService`, `TrafficMonitorService` | S |
| P0-04 | Backup of sensitive history | Adopt backup rules (see Decision 2) excluding `files/traffic_history`, `cache/`, databases; include only `shared_prefs/` | `AndroidManifest.xml`, `res/xml/backup_rules.xml`, `res/xml/data_extraction_rules.xml` | S |
| P0-05 | Spoofable traffic broadcast receiver | Register with `RECEIVER_NOT_EXPORTED` on API 33+ (broadcasts carry `setPackage`, so intra-app delivery is preserved) | `MainActivity` | XS |

### 1.2 Monitoring lifecycle and reliability

| ID | Defect | Change | Files | Est. |
|----|--------|--------|-------|------|
| P0-06 | D3 — restart switches to device-wide silently | Persist `targetUid`, `targetPkg`, `targetLabel` in SharedPreferences on start. On null-intent restart, restore them. If missing/invalid → **fail closed**: `stopSelf()`, remove notification, broadcast `CONFIG_LOST`, UI shows red "monitoring stopped". Never infer device-wide mode | `TrafficMonitorService`, `MainActivity` | M |
| P0-07 | D4 — duplicate schedulers | Idempotent service start: if `scheduler != null`, cancel/shutdown before creating; guard `onStartCommand` | `DeviceMonitorService` | S |
| P0-08 | D5 — notification ID 43 collision | VPN 42, Traffic 43, Device 44 (channels already distinct) | `DeviceMonitorService` | XS |
| P0-09 | D6 — receiver leak | Unregister `deviceReceiver` in `onDestroy`; guard against double registration | `MainActivity` | XS |
| P0-10 | D7 — history write on UI thread | Move `HistoryManager.save()` to the existing executor; toast after completion | `MainActivity` | XS |
| P0-11 | D10 — `seenKeys` unbounded | TTL eviction (entries older than 60 s) + hard cap (5,000) with periodic sweep | `NetWatchVpnService` | S |
| P0-12 | D17 — unguarded foreground start | Wrap `startForeground` in try/catch; on `ForegroundServiceStartNotAllowedException` stop cleanly and report status | All three services | S |

### 1.3 Manifest hygiene

| ID | Change | Files | Est. |
|----|--------|-------|------|
| P0-13 | Remove `android:extractNativeLibs` (no native libraries exist) | `AndroidManifest.xml` | XS |
| P0-14 | Keep `usesCleartextTraffic="true"` — required for LAN HTTP banner grabbing and Linode HTTP speed tests; documented as intentional | `AndroidManifest.xml` | — |

---

## 2. Explicitly out of P0

| ID | Reason |
|----|--------|
| D1, D2 | Architectural rewrite, awaiting Decision 1 |
| D9 (DNS timeouts) | Lives inside the engine that D1/D2 will replace — avoid double work |
| D11 (probe diagnostics) | Phase 4 feature work |
| D12 (GeoIP cleartext + cache) | P1 backend change |
| D14 (public endpoints) | P1; needs rate limiting and a client-compatible rollout |
| D18 (MainActivity split) | Refactor, not a defect fix |
| Any UI change | Out of scope; dark-only UI preserved |
| Backup disable-vs-rules | Pending Decision 2 |

---

## 3. Regression tests

Current state: **no test source sets exist**. P0 adds the minimum.

### 3.1 Unit (JVM, JUnit 4.13.2)
1. CSV export escaping (quotes, commas, newlines, RFC 4180).
2. History session JSON serialization round-trip.
3. LAN helpers: IP validation, subnet range, port-list integrity (23 unique TCP ports).
4. Version/package string formatting.
5. `seenKeys` eviction logic (extracted pure function).

### 3.2 Instrumented (device/emulator)
1. Start Traffic Monitor twice → exactly one polling loop, one notification.
2. Start Traffic Monitor + Device Monitor simultaneously → two distinct notifications; stopping one leaves the other alive.
3. Kill process while monitoring → restart restores target app; missing config stops cleanly (fail-closed).
4. Rotate device with Device Monitor running → no duplicate events, no leaked receiver.
5. Receiver spoof test: external `am broadcast` cannot inject hosts.

### 3.3 Manual matrix (12 scenarios)
Per-app monitoring 10 min · device-wide 10 min · both tabs · rotation · language switch · export CSV · LAN scan + mDNS + port scan · kill from Recents · force-stop/relaunch · airplane mode toggle · VPN permission denied · foreground-start while backgrounded.

Acceptance: no crash, no duplicate rows, TX/RX baselines correct, services stop cleanly, battery drain comparable to v2.10.1.

---

## 4. Rollback plan

1. Tag source before changes: `pre-p0-v2.10.1`.
2. Work on branch `p0-stabilization`; build signed test APK `v2.10.2-p0` — **not published**.
3. P0 adds only new SharedPreferences keys (additive); no data migration. Downgrade to v2.10.1 is safe.
4. Rollback = rebuild from tag or `git revert` the P0 merge commit.
5. Keystore untouched, no rotation in P0.
6. Keep v2.10.1 APK/AAB and this checklist for comparison.

---

## 5. Complexity summary

XS: 5 items · S: 7 items · M: 1 item (P0-06 fail-closed restore)
Total estimate: **2 working days** plus one device regression pass.
