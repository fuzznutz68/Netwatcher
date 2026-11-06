# NetWatch v2.10.2-P0 Regression — Investigation Status

## Bottom line

The crash has **not been reproduced from source** and **no stack trace is available yet**.
No emulator or physical device is attached to the build environment, so the actual
exception is still unknown. A root cause is therefore **not declared**.

The diagnostic build `2.10.2-p0-diag` (versionCode 81) captures the trace on-device.

## What was verified from the build artefacts and diff

| Check | Result |
|---|---|
| `loadAppList()` code vs baseline `pre-p0-v2.10.1` | **byte-identical** |
| `QUERY_ALL_PACKAGES` in built APK | **present** |
| Application filter logic changed | **no** |
| Signing certificate | unchanged `44:09:B5:…:1A:F6` |
| Version upgrade | 79 → 80 (P0), 80 → 81 (diag) |
| Services in separate process | no (single process) |

Because enumeration and filtering are unchanged and the permission is present,
a filtering or package-visibility regression is **ruled out as the primary cause**.
The remaining plausible explanation is that the process dies during enumeration or
during tab interaction, so the list is never fully applied.

## Confirmed defects found in the P0 batch

### CD-1 — A single failing package aborts the entire app list (High)

`MainActivity.loadAppList()` runs on a pool thread with no per-package error handling.
`PackageManager.getApplicationLabel()` can throw for packages with broken or partial
resources. An uncaught throw on an executor thread terminates the **process**, not just
the task. Symptoms would be exactly: repeated crashes and an app list that is missing
entries (the list is only applied after the loop completes).

Fix applied: per-package try/catch, label fallback to the package name, and the loop
continues. One bad package can no longer kill the app.

### CD-2 — `startForegroundService()` contract violated on the fail-closed path (High)

P0 returned from `onStartCommand()` **before** calling `startForeground()` when a target
failed validation. Android 12+ kills the app with `RemoteServiceException`
("Context.startForegroundService() did not then call Service.startForeground()").
This is a guaranteed crash whenever the fail-closed branch is reached.

Fix applied: `startForeground()` now runs first; validation and shutdown happen after.

### CD-3 — CONFIG_LOST receiver touched UI without guards (Medium)

If the broadcast arrived while the Activity was finishing or before views were ready,
the receiver dereferenced null views.

Fix applied: early return when finishing or views are unavailable.

## Diagnostic build

- `versionCode 81`, `versionName 2.10.2-p0-diag`
- Same signing certificate
- `CrashLogger` installs an uncaught-exception handler that writes the full trace to:
  - `Android/data/com.netwatch.net/files/crash_last.txt`
  - `Android/data/com.netwatch.net/files/crash_<timestamp>.txt`
  - logcat tag `NetWatchCrash`
- Unit tests: **17 passing**

This build is a diagnostic, not a confirmed fix. It may stop the crash if CD-1 or CD-2
was the trigger; that cannot be proven until a trace is captured.

## Capturing the crash

### Without ADB (preferred on the tablet)

1. Install the diag build.
2. Reproduce the Traffic tab crash.
3. Reopen the app once (the trace file is written before the process dies).
4. Retrieve the file with a file manager that can access `Android/data` (or connect USB
   and open `Internal storage/Android/data/com.netwatch.net/files/`).
5. Send `crash_last.txt`.

### With ADB

```bash
adb devices
adb logcat -c
# reproduce the crash now
adb logcat -d -b crash
adb logcat -d | grep -A 60 "FATAL EXCEPTION"
adb shell dumpsys dropbox --print data_app_crash | tail -200
adb pull /sdcard/Android/data/com.netwatch.net/files/crash_last.txt
```

### Distinguishing failure class

| Evidence | Class |
|---|---|
| `FATAL EXCEPTION` + `java.lang.*` | Java |
| `Fatal signal 11 (SIGSEGV)` / tombstone | native |
| `chromium` / `WebView` frames | WebView/JS |
| `ANR in com.netwatch.net` | main-thread block |

### Comparing the app list against the system

```bash
# every launcher app the system knows
adb shell cmd package query-activities --brief \
  -a android.intent.action.MAIN -c android.intent.category.LAUNCHER

# installed packages for the NetWatch uid / visibility
adb shell dumpsys package com.netwatch.net | grep -i -A3 QUERY_ALL_PACKAGES
```

Compare that list with what the Traffic spinner shows. If the spinner is empty rather
than partially filled, the process is dying during enumeration (CD-1).

## Not done (awaiting trace)

- No root-cause claim.
- No VPN/architecture change.
- No merge, publish, or key change.
- Manual regression matrix still to run on the tablet.
