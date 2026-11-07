# Missing Apps — Pipeline Trace

## 1. Pipeline comparison v2.10.1 → v2.10.3

Source diff: `loadAppList()` filters are **identical**. Bytecode comparison of the
shipped APKs (versionCode 79 vs 83) confirms the same filter constants and API calls;
the only differences are the fallback, per-package try/catch and the destroyed-activity
guard. No code path can drop a package in 2.10.3 that 2.10.1 kept, unless the framework
returns different data.

## 2. Stage trace

| Stage | Code | Effect on Amazon apps |
|---|---|---|
| Discovery | `getInstalledApplications(GET_META_DATA)` | returns every visible package |
| Fallback | only if discovery empty | **cannot exclude** (additive) |
| Gate A — launcher | `getLaunchIntentForPackage()==null` → skip | **possible** |
| Gate B — system | `FLAG_SYSTEM` && !`FLAG_UPDATED_SYSTEM_APP` → skip | **possible** |
| Gate C — prefix | `com.android.`, `com.sec.android.`, etc. | cannot match `com.amazon.*` |
| Dedup | none — `ArrayList`, no equals/hashCode | none |
| Population | `ArrayAdapter` with the full list | none |

No UID deduplication exists anywhere in the picker. `AppEntry` has no `equals`/
`hashCode`, the list is an `ArrayList`, and the adapter is a plain `ArrayAdapter`.

## 3. Diagnostics added (code only, no APK)

`MainActivity` now logs one line per enumeration at tag `NetWatchPick`:

```
pick: installed=<N> shown=<N> noLauncher=<N> systemApp=<N> prefix=<N> error=<N>
noLauncher: [pkg, ...up to 50]
systemApp: [pkg, ...up to 50]
```

Package names only; no hosts, traffic, accounts or user content. After one launch,
`adb logcat -s NetWatchPick:I` names the gate that drops each Amazon package.

## 4. Regression tests

`AppPickerGateTest` (5 cases, all passing): normal app shown · updated system app
shown · plain system app excluded · no-launcher app excluded · framework prefix
excluded. Full suite: **26 tests, 0 failures**.

## 5. Smallest fix (conditional — awaiting the log line)

- If `systemApp:` lists the Amazon packages → the OEM preload flag changed. One-line
  fix: treat launchable system apps as eligible, keeping the prefix blocklist.
- If `noLauncher:` lists them → their launcher is disabled/hibernated or leanback-only.
  One-line fix: resolve with `queryIntentActivities(..., MATCH_DISABLED_COMPONENTS)`
  and accept `CATEGORY_LAUNCHER` or `CATEGORY_LEANBACK_LAUNCHER`.
- If neither list contains them and `shown` still excludes them → the drop is upstream
  in PackageManager visibility, and I need `dumpsys package` for the two IDs.

No picker code has been changed beyond adding the logging.
