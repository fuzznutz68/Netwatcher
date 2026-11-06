# NetWatch — P0 Stabilization Report

**Branch:** `p0-stabilization`
**Baseline tag:** `pre-p0-v2.10.1`
**Build:** `2.10.2-p0` (versionCode 80) — **not published**
**Date:** 2026-11-06

---

## 1. Scope delivered

| ID | Change | Files |
|----|--------|-------|
| P0-01 | Signing credentials moved out of tracked source into untracked `keystore.properties`, loaded at build time | `app/build.gradle`, `keystore.properties` |
| P0-02 | `.gitignore` covers keystores, `keystore.properties`, `local.properties`, build output, `.agents/.memory/` | `.gitignore` |
| P0-03 | Destination-bearing logs gated behind `BuildConfig.DEBUG` | `NetWatchVpnService`, `DeviceMonitorService`, `TrafficMonitorService` |
| P0-04 | Backup allowlist: only `netwatch_prefs.xml` (language, alert toggle). Session identity in separate `netwatch_session` prefs, never backed up | `res/xml/backup_rules.xml`, `res/xml/data_extraction_rules.xml`, `AndroidManifest.xml` |
| P0-05 | Traffic broadcast receiver registered `RECEIVER_NOT_EXPORTED`; `CONFIG_LOST` added to filter | `MainActivity` |
| P0-06 | **D3 fail-closed**: target uid/package/label persisted and validated on restart; invalid config stops the service and reports it. No whole-device fallback | `TrafficMonitorService`, `MainActivity` |
| P0-07 | Device monitor scheduler creation idempotent | `DeviceMonitorService` |
| P0-08 | Notification IDs: 42 VPN / 43 Traffic / 44 Device | `DeviceMonitorService` |
| P0-09 | `deviceReceiver` unregistered in `onDestroy` | `MainActivity` |
| P0-10 | History writes on a single-thread executor, preserving session order | `MainActivity` |
| P0-11 | Bounded `SeenKeyCache` with TTL sweep and oldest-10% eviction on overflow | `SeenKeyCache.java`, `NetWatchVpnService` |
| P0-12 | Guarded `startForeground` with clean self-stop | both foreground services |
| P0-13 | `extractNativeLibs` removed after verifying no native libraries exist | `AndroidManifest.xml` |
| P0-14 | Network Security Config: cleartext denied by default, allowlisted speed-test hosts only | `res/xml/network_security_config.xml` |

### Explicitly unchanged
- D1/D2 VPN/TCP/UDP architecture — untouched pending PoC approval.
- D9 DNS resolution timeouts — deferred with the engine work.
- Strict per-UID monitoring and destination/port/protocol display — behavior preserved.
- Dark-only interface — untouched.
- Production signing key — untouched.

---

## 2. Test results

| Test | Result |
|------|--------|
| `./gradlew testReleaseUnitTest` | **13 tests, all passing** |
| `./gradlew assembleDebugAndroidTest` | Compiles (3 instrumented tests) |
| Instrumented test execution | **Not run** — no device attached |
| `./gradlew assembleRelease` | **PASS** (includes `lintVitalRelease`) |
| Manual regression matrix | **Not executed** — requires owner's tablet |
| APK signature verification | **PASS** — cert `44:09:B5:48:…:1A:F6` |

### Unit test coverage
- `CsvUtilTest` — RFC 4180 quoting, embedded quotes, null, newlines.
- `HistoryCodecTest` — JSON round-trip, order preservation, missing-field defaults.
- `SeenKeyCacheTest` — first-report, dedup window, post-window re-report, TTL prune,
  no duplicate within window after prune, bounded size under a 100-key burst.

A defect was found and fixed during test development: the initial size cap only
evicted entries older than the dedup window, so a burst of unique destinations
grew without bound. Eviction now removes oldest entries until under cap.

---

## 3. Deliverables

- `NetWatch-v2.10.2-p0.apk`
  - SHA-256: `f466f5f4d6e43e746519019cdab6a46c5c93956b99c59e08f42ff48c158e4579`
- `NetWatch-v2.10.2-p0.zip` (contains APK only)
  - SHA-256: `5544ee1e4c67150a37aceb17562409de1bf09da10357234868ec7d6fd776aa9a`

### Signing certificate — unchanged
```
DN: CN=NetWatch, OU=Mobile, O=NetWatch App, L=Unknown, ST=Unknown, C=US
SHA-256: 44:09:B5:48:43:BE:BC:8A:EF:69:51:99:FE:1E:6C:C6:D8:E0:55:8B:D5:A7:58:FC:05:49:1D:8A:BD:68:1A:F6
```

### Credential hygiene verification
- `git ls-files` contains **no** keystore, `.jks`, `keystore.properties`, or `local.properties`.
- Historical tracking of `netwatch-release.keystore`, `netwatch-debug.keystore` and
  `local.properties` was removed via `git rm --cached` (commit `a156e029`).
  Files remain on disk. **No history rewrite, no force-push.**
- The APK and ZIP contain no signing material.

---

## 4. Remaining risks

1. **D1/D2 unchanged.** TCP streams are still not relayed; monitoring may degrade
   other apps' connectivity. Awaiting PoC approval.
2. **D9 deferred.** DNS lookups in the VPN and device-monitor paths remain
   uncancellable and unbounded; they can saturate their small pools on bad DNS.
3. **Instrumented tests unexecuted.** Service lifecycle and fail-closed behavior
   are validated only by code inspection and unit tests until run on hardware.
4. **Cleartext allowlist is host-based.** If a speed-test provider redirects to a
   different cleartext host, that test will fail until the host is allowlisted.
5. **Backup rules are allowlist-only.** New preferences added later will not be
   backed up unless explicitly added — intentional, but requires discipline.
6. **Exposed historical signing key** (cert `4B:84:D3:…:B6`, password
   `netwatch2024`) remains public in Git history. Not used by any sampled
   distributed APK, and not this batch's key. Separate remediation proposal
   still required.
7. **D14 SSRF/abuse findings are unresolved** — see `D14_REMEDIATION.md`.
