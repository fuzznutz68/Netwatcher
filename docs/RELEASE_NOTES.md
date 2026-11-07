# Release notes

Newest first. Earlier entries link to their original GitHub releases, which remain the
authoritative copy of those notes; nothing below rewrites history.

## v2.10.6 — Build 88 (current)

Cosmetic correction on top of the tablet-tested Build 87. Same package, same certificate,
same behaviour everywhere except one line of the UI.

- **Tools tab footer fixed.** The footer printed a hardcoded `netwatch tools v2.10.1` for
  several releases. It now reads the installed package's `versionName` through a new
  `installedVersionName()` helper, so it always matches the running build and falls back to
  a bare `netwatch tools` if the package query fails.
- **Internal identity now matches the tag.** `versionCode 88` / `versionName 2.10.6`,
  replacing `87` / `2.10.4-whois-test3`.

No change to capture, filtering, WHOIS, Device Monitor, Traffic Trace, CSV export, app
enumeration or backend calls. APK SHA-256
`26f2bf5c34be3f5de63e2f55bcf794bc3b3543f7ec2d42a503b7b75588427445`.

Verification: 191 regression assertions (0 failures), release build successful, shipped dex
contains `netwatch tools v` and no stale `v2.10.1` literal, signing certificate unchanged.
Confirmed on hardware: a build 88 tablet capture of the Tools tab shows the footer reading
`netwatch tools v2.10.6`.

Documentation: [user guide](USER_GUIDE.md), [installation](INSTALLATION.md),
[technical reference](TECHNICAL.md), [features](FEATURES.md), [security](SECURITY.md).

## v2.10.5 — Build 87 (superseded by v2.10.6)

Tablet-verified test build. APK internal identity unchanged from the tested artifact:
`versionCode 87`, `versionName 2.10.4-whois-test3`, package `com.netwatch.net`.
APK SHA-256 `2f3d141f8ffb7b898f1afd45f9bc4da9da628dfd24a0e0bca394d3104421a9a8`.

Added and fixed:

- **WHOIS added to Network Tools** — sixth tool, terminal styling, 48dp layout that survives
  enlarged font scales.
- **IPv4 and IPv6 WHOIS support** — IP literals only; port-aware IPv6 parsing so
  `…:0:8e:443` keeps its full address; domains rejected locally.
- **Corrected WHOIS field rendering** — current backend keys plus legacy fallbacks, and JSON
  `null` no longer renders as the text `null`.
- **Corrected Device Monitor IPv6 display** — the receiver used an IPv4-only colon split, so
  IPv6 rows showed a single hextet, offered a bogus "Copy Hostname" and truncated the WHOIS
  title. Now uses the shared port-aware splitter. Lookups were never affected.
- **Fixed Device Monitor CSV sharing** — FileProvider now declares the external files root
  used by the exporter.
- **Traffic Trace regression tested** — connection capture, UID filtering, host log and
  session stats verified on Android 14.

Verification: 191 regression assertions, 0 failures; release build successful; tablet pass
on WHOIS, IPv6 display, Device Monitor CSV export and Traffic Trace.

Known limitations: backend hardening is partially mitigated; registry country is not
physical location; RDAP availability is intermittent. See [SECURITY.md](SECURITY.md) and
[FEATURES.md](FEATURES.md).

Documentation for this release: [user guide](USER_GUIDE.md), [installation](INSTALLATION.md),
[technical reference](TECHNICAL.md).

## v2.10.4 line — Builds 85–86 (test builds, not published as releases)

- Build 85 `2.10.4-whois-test`: first WHOIS test build.
- Build 86 `2.10.4-whois-test2`: Device Monitor CSV export path fix (FileProvider
  `external-files-path`) and WHOIS `null`-field fix.
- Build 87 `2.10.4-whois-test3`: Device Monitor IPv6 display fix; published as v2.10.5.

## v2.10.1

Security work: the `trafficProbe` backend function was disabled (HTTP 503), `domainIntel`
was hardened (host validation, private-range rejection, capped redirects/body/DNS work), and
`geoIp`/`ipWhois` were migrated to registry data (Team Cymru over DoH, RDAP, PTR) with
registry-only country labelling. See [SECURITY.md](SECURITY.md).
[Release](https://github.com/fuzznutz68/Netwatcher/releases/tag/v2.10.1-release)

## v2.9.3, v2.9.2

Network Tools expansion; v2.9.2 shipped the rootless LAN Scanner (ARP cache plus ping sweep,
UPnP/SSDP, reverse DNS, NetBIOS, banner grabs, OUI vendor lookup).
[2.9.3](https://github.com/fuzznutz68/Netwatcher/releases/tag/v2.9.3-release) ·
[2.9.2](https://github.com/fuzznutz68/Netwatcher/releases/tag/v2.9.2-release)

## v2.8.4, v2.8.3, v2.8.2

Windows desktop companion (WPF, .NET 8, self-contained build) and Network Tools on desktop.
[2.8.4](https://github.com/fuzznutz68/Netwatcher/releases/tag/v2.8.4-release) ·
[2.8.2](https://github.com/fuzznutz68/Netwatcher/releases/tag/v2.8.2-release)

## v2.7.x

Deep Domain Scan (certificate transparency plus prefix probing); companion domain mapping
for CDN-hosted traffic.
[2.7.3](https://github.com/fuzznutz68/Netwatcher/releases/tag/v2.7.3) ·
[2.7.1](https://github.com/fuzznutz68/Netwatcher/releases/tag/v2.7.1) ·
[2.7.0](https://github.com/fuzznutz68/Netwatcher/releases/tag/v2.7.0)

## v2.6.0

First Windows desktop build alongside the Android app.
[Release](https://github.com/fuzznutz68/Netwatcher/releases/tag/v2.6.0-release)

## v2.5.x

Traffic Monitor reliability: strict per-app UID attribution (accuracy over completeness),
session-scoped TX/RX baselines, DNS-resolver filtering, and `onTaskRemoved` shutdown when
the app leaves Recents — which removed the need for Usage Access.
[2.5.3](https://github.com/fuzznutz68/Netwatcher/releases/tag/v2.5.3) ·
[2.5.2](https://github.com/fuzznutz68/Netwatcher/releases/tag/v2.5.2) ·
[2.5.1](https://github.com/fuzznutz68/Netwatcher/releases/tag/v2.5.1)

## v2.4.x

Shared VPN capture engine replacing `/proc/net/tcp` discovery; local-network noise filtering;
light/dark theme experiment reverted after readability feedback.
notes for 2.4.2 are in the project history

## v2.3.0

Edge-to-edge display handling and removal of orientation locks for Android 15/16 large
screens.
[Release](https://github.com/fuzznutz68/Netwatcher/releases/tag/v2.3.0-release)

## v2.2.x and earlier

Screenshots and original notes are attached to each release on the
[releases page](https://github.com/fuzznutz68/Netwatcher/releases). Those pages are the
authoritative record and have not been modified.
