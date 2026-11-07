# Installation

## Requirements

- Android 11 (API 30) or newer. Tested on Android 14 tablet hardware, targetSdk 36.
- About 20 MB of free space; no root.
- No Google account or Play Services requirement.

## Install from the release

1. Open the [v2.10.6 release](https://github.com/fuzznutz68/Netwatcher/releases/tag/v2.10.6).
2. Download `NetWatch-v2.10.6.apk`.
3. Optionally verify the file before installing:

   ```bash
   sha256sum NetWatch-v2.10.6.apk
   # 26f2bf5c34be3f5de63e2f55bcf794bc3b3543f7ec2d42a503b7b75588427445
   ```

   On a device, any file manager showing checksums, or `apksigner verify --print-certs`
   from Android build tools, gives the same answer. The certificate digest must be
   `4409b54843bebc8aef695199fe1e6cc6d8e0558bd5a758fc05491d8abd681af6`.
4. Open the APK. Because it is sideloaded, Android asks you to allow installs from that
   app (browser or file manager). Allow it once, then confirm the install.
5. If Play Protect warns about an unknown developer, choose "Install anyway". The APK is
   signed with NetWatch's own release certificate, which Play Protect does not recognise
   for an app distributed outside the Play Store.

## Upgrading

Builds 85 through 88 share package `com.netwatch.net` and the same signing certificate,
so installing Build 88 over an earlier build keeps your settings, history and saved
sessions. Just open the new APK and confirm.

You do **not** need to uninstall first. If Android refuses with "App not installed", the
cause is almost always a different signing key (for example a build signed with a debug
key), in which case uninstall the old copy once and install again — app data from the old
install is lost in that case.

## Version naming

Since v2.10.6 the release tag and the internal build identity agree:

- The **release/tag** is `v2.10.6`.
- The **internal** `versionName` is `2.10.6` and `versionCode` is `88`.

`Settings → Apps → NetWatch` shows `2.10.6`. Releases v2.10.5 and earlier used a frozen
internal name (`2.10.4-whois-test3`, versionCode 87) because that APK was the exact artifact
that passed tablet testing; that mismatch no longer exists.

Rollback anchors for the maintainer: release tag `v2.10.5` (previous published build),
tag `baseline-2.10.4-p0-diag` (`de993d08`) and branch `fix/build85-export-and-whois`
(`1e5aec70`, the verified Build 86 source).

## Permissions explained

| Permission | Why |
| --- | --- |
| `INTERNET`, `ACCESS_NETWORK_STATE` | Reach the lookup backends, run network tools. |
| `FOREGROUND_SERVICE` (+ `DATA_SYNC`, `SPECIAL_USE`) | Keep monitoring visible and alive while the screen is off. |
| `BIND_VPN_SERVICE` | Local loopback capture used by Traffic Monitor and Device Monitor. |
| `POST_NOTIFICATIONS` | The persistent monitoring notice. |
| `QUERY_ALL_PACKAGES` | The app picker must be able to list what is installed. |
| `VIBRATE` | Optional alerts; the unknown-host vibration is off by default. |

NetWatch does not request Usage Access, location, contacts, SMS or storage-wide permissions.
CSV files are written to the app's own external files directory and shared through the
Android share sheet, which needs no storage permission.

## VPN consent

The capture runs as a local VPN interface. Android requires explicit consent for this, and
it is shown once per install:

- All traffic is inspected locally; nothing is tunnelled to a remote server.
- While monitoring is active a key icon appears in the status bar.
- Stopping the monitor, or swiping NetWatch out of Recents, tears the tunnel down.

Declining the prompt does not break the rest of the app: Network Tools, Domain Intel,
Domain Checker, Speed Test and My Info all work without it. Only the two monitoring tabs
need it.

## Uninstall

Long-press the launcher icon → App info → Uninstall. Saved session history and exported
CSVs inside the app's private directory are removed with it. Files you already shared to
other apps are unaffected.
