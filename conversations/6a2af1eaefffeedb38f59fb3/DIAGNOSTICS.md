# NetWatch P0 — Device Crash Diagnostics

**Status:** no production code changed, no APK produced. Production v2.10.1 untouched.
`p0-stabilization` not merged or published.

---

## 0. What the diff proves (not a guess)

Baseline `pre-p0-v2.10.1`, `TrafficMonitorService.onStartCommand()` line 127:

```java
createChannel();
Notification n = buildNotification();
startForeground(NOTIF_ID, n, ...);
```

P0 `a156e029` and every build since (including versionCode 82):

```java
startForegroundSafely();          // never calls createChannel()
```

`createChannel()` still exists at `TrafficMonitorService.java:631` but **has no callers**
anywhere in the project. Verified by `grep -rn "createChannel()"` — one hit, the
declaration itself.

The notification is built on channel `netwatch_monitor`:

```java
new Notification.Builder(this, "netwatch_monitor")
```

That channel is therefore never registered.

### Why this kills the app

On Android 8+, posting a service notification to a non-existent channel makes the
framework raise, asynchronously on the main thread via `ActivityThread$H`:

```
android.app.RemoteServiceException$BadNotificationForStartForeground:
java.lang.RuntimeException: invalid channel for service notification:
Notification(channel=netwatch_monitor ...)
```

It is **not** thrown from inside `startForeground()`, so the `try/catch (Exception)`
around `startForegroundSafely()` cannot intercept it. The uncaught main-thread
exception terminates the process. Timing matches the report exactly: the crash lands
immediately after selecting an app, because selection auto-starts monitoring.

### Why v2.10.1 was fine and why this is device-specific

Channels persist across app **updates** but not across **uninstall**. v2.10.1 created
the channel itself on every start. On an in-place upgrade the old channel would still
exist and mask the bug. The device is wiped and reinstalled for each build, so the
channel is absent on first run — the crash appears only there, which is consistent
with the reported behaviour and with v2.10.1 working.

### Reproducible test (runs without a device)

`app/src/test/java/com/netwatch/app/NotificationChannelTest.java` deletes the channel
to simulate a fresh install, starts `TrafficMonitorService` with a valid target, then
asserts the channel exists.

```
NotificationChannelTest > trafficServiceCreatesItsNotificationChannelBeforeForeground FAILED
java.lang.AssertionError: traffic service must create its notification channel before startForeground()
```

The test fails on current code. It passes once `createChannel()` is called before
`startForeground()`. This is the reproducible test the previous report lacked.

**Not yet matched to a device stack trace.** That is what the commands below are for.

---

## 1. ADB / logcat capture

### Prepare

```bash
adb devices -l
adb shell getprop ro.build.version.release
adb shell dumpsys package com.netwatch.net | grep -E "versionCode|versionName"
```

### Clear, reproduce, capture

```bash
adb logcat -c

# Now select an app in the Traffic tab. Let it crash.

adb logcat -d -b crash
adb logcat -d -v threadtime | grep -iE \
  "FATAL EXCEPTION|RemoteServiceException|SecurityException|BadNotification|invalid channel|ForegroundService|startForeground|ANR in|Force finishing|has died|netwatch" \
  > netwatch_crash.txt
```

Live capture instead (second terminal, start before reproducing):

```bash
adb logcat -v threadtime > netwatch_full.log
```

### System-side records (survives process death)

```bash
adb shell dumpsys dropbox --print data_app_crash
adb shell dumpsys dropbox --print system_app_crash
adb shell dumpsys dropbox --print data_app_anr
adb shell dumpsys dropbox --print SYSTEM_TOMBSTONE
adb shell dumpsys dropbox --print system_server_crash
```

### Service and permission state

```bash
adb shell dumpsys activity services com.netwatch.net
adb shell dumpsys activity processes | grep -i -A3 netwatch
adb shell dumpsys package com.netwatch.net | grep -A30 "runtime permissions"
adb shell cmd appops get com.netwatch.net POST_NOTIFICATION
adb shell dumpsys notification --noredact | grep -i -B2 -A8 "netwatch_monitor"
adb shell dumpsys deviceidle | grep -i netwatch
```

### Full bugreport (contains all of the above)

```bash
adb bugreport netwatch-bugreport.zip
```

### What each result means

| Output | Meaning |
|---|---|
| `BadNotificationForStartForeground` + `invalid channel` | missing channel (section 0) |
| `ForegroundServiceDidNotStartInTimeException` | service never reached `startForeground()` |
| `ForegroundServiceStartNotAllowedException` | FGS started while app was in background |
| `SecurityException ... FOREGROUND_SERVICE_DATA_SYNC` | missing/denied FGS type permission |
| `Fatal signal 11` / `SIGABRT` | native crash, tombstone required |
| `ANR in com.netwatch.net` | main-thread block, not an exception |

---

## 2. Retrieving `crash_last.txt`

Written to the app's external files dir:

```
/sdcard/Android/data/com.netwatch.net/files/crash_last.txt
/sdcard/Android/data/com.netwatch.net/files/crash_<epoch>.txt
```

### Primary

```bash
adb shell ls -l /sdcard/Android/data/com.netwatch.net/files/
adb pull /sdcard/Android/data/com.netwatch.net/files/crash_last.txt
```

### Fallback A — direct shell read

```bash
adb shell cat /sdcard/Android/data/com.netwatch.net/files/crash_last.txt
```

### Fallback B — Android Studio Device Explorer

View → Tool Windows → Device Explorer → `sdcard/Android/data/com.netwatch.net/files/`
→ right-click → Save As. Uses the same transport as `adb pull`, works when the shell
path is blocked by scoped storage.

### Fallback C — `run-as` (expected to fail here)

```bash
adb shell run-as com.netwatch.net cat files/crash_last.txt
```

`run-as` only works for debuggable builds. The production build is not debuggable, so
a failure here is normal, not a problem.

### Fallback D — on-device

Android 11+ blocks `Android/data` for most file managers. Options that still work:
- **USB → PC**: open `Internal storage/Android/data/com.netwatch.net/files/`.
- A file manager holding `MANAGE_EXTERNAL_STORAGE` or a SAF-based "Android/data"
  unlock tool.
- **Screenshot the crash dialog** — the stack trace is often readable there.

### Fallback E — if the file is absent

The handler only runs for uncaught **Java** exceptions. If nothing was written, the
process was ended by something else (native fault, low-memory kill, `am force-stop`,
or an ANR kill). Use `dropbox`/`bugreport` for those.

---

## 3. Full review: app selection → monitoring start

### Call chain

```
Spinner.onItemSelected                    MainActivity ~318
  ├─ selectedApp = appList.get(pos)
  ├─ if (monitoring) stopMonitoring()
  ├─ seedTrustedDomains(pkg)
  ├─ startMonitoring()                    MainActivity:961
  │    ├─ guard selectedApp != null
  │    ├─ clearLog(); monitoring = true; UI updates
  │    ├─ VpnService.prepare(this)
  │    │    ├─ non-null → startActivityForResult(VPN_REQUEST_CODE)
  │    │    └─ null     → launchTrafficMonitoringInternal()
  │    └─ onActivityResult → launchTrafficMonitoringInternal()   MainActivity:985
  │         ├─ trafficVpnEngineActive = true
  │         ├─ ensureVpnEngineRunning()   MainActivity:4553
  │         │    └─ startForegroundService(NetWatchVpnService, "START")
  │         └─ startForegroundService(TrafficMonitorService + extras)
  └─ postDelayed(launchApp(pkg), 400)
```

### `TrafficMonitorService.onStartCommand()` — line 126

Order of operations:

1. `ACTION_STOP` → `clearPersistedTarget(); stopSelf()`.
2. Extras present → adopt target, `persistTarget()`.
3. No extras (system restart) → `restoreTarget()`.
4. `startForegroundSafely()` — **notification channel never created** (section 0).
5. `MonitorTarget.isValid()` fail-closed check.
6. Reset caches, `running = true`, register VPN host receiver, seed domains, poll.

### Notification path

- `buildNotification()` uses channel `netwatch_monitor`.
- `createChannel()` exists, is correct, and is **never invoked**.
- Device/VPN services each create their own channels correctly
  (`netwatch_dev`, `netwatch_vpn`), so they mask the defect and still work.

### Permissions

Declared: `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_DATA_SYNC`,
`FOREGROUND_SERVICE_SPECIAL_USE`, `POST_NOTIFICATIONS`, `QUERY_ALL_PACKAGES`.

- `dataSync` type matches the Traffic service's `foregroundServiceType="dataSync"`.
- `specialUse` type + subtype property match the VPN service.
- `POST_NOTIFICATIONS` is a runtime permission on 13+. If denied, the notification is
  suppressed but `startForeground()` still succeeds. **It does not cause this crash**,
  but worth checking with `cmd appops get`.
- No `SecurityException` path is evident in the service declarations.

### Secondary risk noted, not acted on

`onItemSelected` auto-starts monitoring and then opens the target app after 400 ms.
If the two `startForegroundService()` calls race the Activity going to background,
Android 12+ can refuse the second start with `ForegroundServiceStartNotAllowedException`.
This is a real risk in the sequence and would produce a different exception string.
It is **not** being changed without the trace.

---

## 4. What the crash logger can and cannot capture

`CrashLogger.install()` is the first statement in `MainActivity.onCreate()`, and sets
a `Thread.setDefaultUncaughtExceptionHandler` that writes the trace, then delegates to
the previous handler.

### Captured

- Any uncaught Java/Kotlin exception on **any thread in the app process**, including
  the main thread.
- Framework-delivered exceptions that surface through `ActivityThread$H` —
  specifically `RemoteServiceException$BadNotificationForStartForeground` and
  `ForegroundServiceDidNotStartInTimeException`. These arrive as uncaught main-thread
  exceptions inside our process, so the handler does run.
- Anything thrown after `onCreate()` begins.

### Not captured

- **Native crashes** (`SIGSEGV`, `SIGABRT`) — no Java handler runs. Use tombstones /
  `dumpsys dropbox --print SYSTEM_TOMBSTONE`.
- **System-initiated kills**: low-memory kill, `am force-stop`, user "Force stop",
  ANR force-kill, or a system_server timeout that kills the process without delivering
  a Java exception.
- **Crashes before `onCreate()`** — e.g. class-loading/verification failure during
  `Application` or process attach.
- **OOM / `OutOfMemoryError` in a native buffer** where the process is killed directly.
- If the process is terminated mid-write, the file may be empty or truncated; the
  timestamped second copy reduces that risk but does not eliminate it.

So: a missing `crash_last.txt` does **not** mean "no crash" — it means the termination
was not a Java uncaught exception. That is exactly why the logcat/dropbox commands are
required alongside it.

---

## 5. What is still needed

1. The output of section 1 (especially `-b crash` and `data_app_crash`).
2. `crash_last.txt`, if present.
3. For the app-list symptom: the full launcher list from the device so it can be
   compared with what the picker shows:

```bash
adb shell cmd package query-activities --brief \
  -a android.intent.action.MAIN -c android.intent.category.LAUNCHER \
  | sort > device_launcher_apps.txt
```

Enumeration code and `QUERY_ALL_PACKAGES` are byte-identical to v2.10.1, so that
symptom is not explained by any P0 diff and needs this comparison before I touch it.

Once the trace matches the invalid-channel exception, the fix is a single restored
call (`createChannel()` before `startForeground()`), and I will build only then.
