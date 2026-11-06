# Device Test Checklist — NetWatch v2.10.2-p0

Target: Android tablet (Android 14). Build `versionCode 80`, `2.10.2-p0`.
Legend: **[D]** device only · **[A]** requires ADB · **[P]** requires a permission prompt

---

## 1. Installation and data preservation

1. **Do not uninstall** the current production build — this tests the real upgrade path.
2. Confirm installed version is 2.10.1 before starting.
3. Install `NetWatch-v2.10.2-p0.apk` over it.
4. App opens without crash; version shown in About is `2.10.2-p0`.
5. **[D]** Language setting (EN/RU) preserved.
6. **[D]** "Alert on unknown hosts" toggle preserved (should still be OFF by default).
7. **[D]** Connection History entries from before the update still listed.

**Pass:** upgrade succeeds with no data loss and no uninstall step.

## 2. Per-app monitoring and UID filtering

1. Traffic tab → select an app (e.g., a browser) → START.
2. **[P]** Grant VPN consent if prompted.
3. Use the app for 1–2 minutes (load sites, scroll).
4. Confirm only destinations belonging to that app appear — no other apps' hosts.
5. Confirm TX/RX totals start near zero at START (session baseline, not since boot).
6. Confirm destination IP, port, protocol and domain/timestamp columns populate.
7. Stop monitoring; confirm totals freeze.
8. Switch to a different app and start again; confirm previous app's hosts are cleared.

**Pass:** no cross-app leakage under any circumstance (strict UID behaviour preserved).

## 3. Restart and fail-closed behaviour

1. Start per-app monitoring, then background the app.
2. **[A]** Kill the process without clearing data:
   `adb shell am kill com.netwatch.net`
3. Re-open NetWatch.
4. **Expected:** monitoring either restored to the *same* app, or explicitly
   stopped with a configuration-lost message.
5. **Fail condition:** monitoring starts showing all device traffic. That must not happen.
6. **[A]** Clear app data to force an unrecoverable state:
   `adb shell pm clear com.netwatch.net`
7. Relaunch and trigger a service restart (if testable). Confirm it stops rather
   than defaulting to device-wide.

**Pass:** never whole-device monitoring after a failed restore.

## 4. LAN scanner

1. TOOLS → LAN → RUN.
2. Devices discovered; `.local` names present (mDNS).
3. Tap an IP → dialog shows Scan common ports / Open in PORT / Copy IP.
4. Run a port scan on a known-open host (e.g., gateway 80/443).
5. Confirm OPEN lines and "N of 23 ports open" summary.
6. Confirm gateway no longer labelled with an HTTP status code (e.g., "302 Moved Temporarily").
7. Scan twice; confirm no crash and reasonable elapsed time.

**Pass:** discovery, naming, tap actions and port scan all work.

## 5. Network connectivity (TCP / UDP / QUIC)

1. With per-app monitoring **running**, load an HTTPS page in the monitored app.
2. Play a video (QUIC/UDP path) and make a voice/video call if available.
3. Switch to another app and verify its networking still works.
4. Note any stalls, timeouts or failures.

**Expected:** D1/D2 are unresolved, so connectivity degradation is a **known
limitation** — record observations rather than treating as a regression.
This test characterises the current engine for the PoC comparison.

## 6. Speed tests and Network Security Config

1. SPEED tab → run a test against each region you normally use.
2. Confirm tests complete (cleartext allowlist covers these hosts).
3. **[D]** Confirm Domain Intel, Domain Checker and My Info still work (HTTPS).
4. **[A]** Verify no unexpected cleartext:
   `adb logcat | grep -i cleartext`
5. If a specific region fails, note it — likely a redirect to a non-allowlisted host.

**Pass:** all allowlisted speed tests succeed; HTTPS features unaffected.

## 7. Notifications and service lifecycle

1. Start Traffic Monitor and Device Monitor together.
2. Confirm **three** distinct notifications where applicable (VPN 42, Traffic 43, Device 44).
3. Stop Device Monitor — Traffic notification and VPN tunnel must remain.
4. Stop Traffic Monitor — remaining services stop cleanly with no orphan notification.
5. Swipe NetWatch from Recents.
6. **[D]** All notifications disappear; no monitoring continues.
7. **[A]** Confirm no service remains:
   `adb shell dumpsys activity services com.netwatch.net`
8. **[A]** Check for restart loops:
   `adb logcat | grep -i "startForeground\|ForegroundService"`

**Pass:** no duplicate or stacked notifications; clean shutdown.

## 8. History and export

1. Monitor an app, generate several connections, stop monitoring.
2. Open Connection History — session listed with correct app, time and counts.
3. Export CSV; open it and confirm RFC 4180 quoting is valid.
4. Delete one session; confirm it disappears.
5. Verify history is **not** in the backup set (see §9).

**Pass:** ordering preserved, export valid, deletion works.

## 9. Backup exclusions **[A]**

1. Run a backup:
   `adb shell bmgr backupnow com.netwatch.net`
2. Inspect the produced dataset (or use `adb shell dumpsys backup`) and confirm
   only `netwatch_prefs.xml` is included.
3. Confirm `netwatch_session` prefs and `files/traffic_history` are absent.

**Pass:** only language/alert preferences are backed up.

## 10. Log redaction **[A]**

1. Start monitoring, generate traffic.
2. `adb logcat -d | grep -i netwatch`
3. Confirm **no** hostnames, destination IPs or monitored package names appear in
   a release build. Only generic errors are permitted.

**Pass:** no monitoring destinations in release logs.

---

## ADB / developer-option requirements

| Test | Requires |
|------|----------|
| Process kill + restore (§3) | ADB (`am kill`) |
| Cleared-data fail-closed (§3) | ADB (`pm clear`) |
| Service inspection (§7) | ADB (`dumpsys`) |
| Backup contents (§9) | ADB (`bmgr`) |
| Log redaction (§10) | ADB (`logcat`) |
| Cleartext check (§6) | ADB (`logcat`) |

Device-only items: upgrade install, preferences preservation, VPN/notification
permission prompts, actual connectivity behaviour, LAN discovery, UI appearance.
