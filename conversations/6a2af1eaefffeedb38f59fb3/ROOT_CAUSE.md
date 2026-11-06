# P0 Regression — Root Cause and Fix

## Confirmed root cause of the app closing

**`TrafficMonitorService.onStartCommand()` returned before calling `startForeground()`.**

This was introduced by P0-06 (the fail-closed change). The path:

1. P0 is installed over v2.10.1. The old build's monitoring service can still be
   registered with Android as a started, sticky, foreground service.
2. The update kills the process. When NetWatch is next launched, the system
   restarts that service with a **null intent**.
3. P0 handles the null intent by calling `restoreTarget()`, which reads the
   `netwatch_session` preferences. Those did not exist in v2.10.1, so the target
   is empty.
4. The fail-closed branch fires: `stopSelf()` and return — **without**
   `startForeground()`.
5. Android 12+ treats this as
   `RemoteServiceException: Context.startForegroundService() did not then call
   Service.startForeground()` and kills the whole process.

That is the exact reported behaviour: opening the Traffic tab (which is where the
service is restored) closes the entire application, repeatedly.

**Fix:** `startForeground()` now runs first, so the API contract is always met.
Validation and the fail-closed shutdown happen afterwards, and the notification is
removed before `stopSelf()`.

## Confirmed cause of the incomplete app list

The enumeration code is byte-identical to `pre-p0-v2.10.1`, and `QUERY_ALL_PACKAGES`
is present in the P0 APK, so filtering and package visibility are not the cause.
The failure is structural:

- `loadAppList()` ran the whole loop unguarded on a pool thread. A single package
  whose label/resources throw aborts the loop, and the uncaught exception on a pool
  thread **kills the process**.
- The adapter was only applied after the loop, so process death left the picker
  without the completed list. Killing the app also interrupts enumeration, which is
  why entries appear to be missing rather than uniformly filtered.

**Fix:**
- Per-package `try/catch`; a bad package is skipped, not fatal.
- Label fallback to the package name.
- Fallback enumeration via `queryIntentActivities(MAIN/LAUNCHER)` if
  `getInstalledApplications` returns nothing.
- The adapter is always applied, and never to a destroyed Activity.
- The intentional filters are unchanged: system apps stay excluded, the framework
  prefix blocklist stays, and no permission was added or broadened.

## Secondary

`CONFIG_LOST` receiver could dereference null views if the Activity was finishing.
It now returns early. This is hardening, not the primary cause.

## Verification performed

| Check | Result |
|---|---|
| `loadAppList` vs baseline | byte-identical (ruled out as a filter regression) |
| Permissions in P0 APK | `QUERY_ALL_PACKAGES` present, all others identical to baseline |
| Merged manifests, baseline vs P0 | only the intended P0 deltas (backup rules, NSC, cleartext, native libs) |
| Services in separate process | no |
| Traffic tab startup harness (Robolectric) | activity starts cleanly |
| Enumeration harness | 3 fake packages + the app itself all appear in the picker |
| Unit tests | **19 passing** |

## Files changed

```
app/build.gradle                                      versionCode 82, test deps
app/src/main/java/com/netwatch/app/TrafficMonitorService.java   FGS ordering
app/src/main/java/com/netwatch/app/MonitorTarget.java           new, testable validation
app/src/main/java/com/netwatch/app/CrashLogger.java             new, diagnostic
app/src/main/java/com/netwatch/app/MainActivity.java            enumeration, guard
app/src/test/java/com/netwatch/app/MonitorTargetTest.java
app/src/test/java/com/netwatch/app/TrafficTabStartupTest.java
app/src/test/java/com/netwatch/app/AppEnumerationTest.java
```

## Build

- Package `com.netwatch.net`, `versionCode 82`, `versionName 2.10.2-p0-fix`
- Certificate `44:09:B5:48:…:68:1A:F6` (unchanged)
- Committed as `ccc211c4` on `p0-stabilization`

## Residual uncertainty

The service-restart path is confirmed by code and by Android's documented contract,
but the device crash trace was not captured (no device in this environment). The
build keeps `CrashLogger`, so if the app still closes, `crash_last.txt` will contain
the actual stack trace.
