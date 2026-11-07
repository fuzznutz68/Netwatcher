# WHOIS Network Tools patch - implemented and tested (not built, not merged)

Date: 2026-11-07. Branch `feat/whois-network-tool`, commit `55cd3d13`, isolated
in worktree `/app/wt-whois` created from baseline `de993d08`.
Artifact for review: `security/patches/whois-tool.diff` (390 lines,
+199 / -30, two files).

## What changed

| File | Change |
|---|---|
| `app/src/main/res/layout/activity_main.xml` | `toolWhoisBtn` inserted between DNS and LAN; six buttons now `48dp` tall, equal weight, `marginRight 4dp`, `minWidth/minHeight 0dp`, 2dp side padding, `autoSizeTextType=uniform` 8-12sp |
| `MainActivity.java` | `TOOL_WHOIS = 5` (LAN unchanged at 4); field declaration; `findViewById`; click → `setToolMode(TOOL_WHOIS)`; style line; dispatch branch; `showIpWhois` rewrite; `splitIpPort` helper; help texts |

Nothing else. `git diff --stat de993d08` for `NetWatchAPK/app` reports exactly
those two files.

## Requirement traceability

1. `TOOL_WHOIS = 5`, `TOOL_LAN` stays 4, ids 0-4 untouched.
2. Six equal-weight buttons at 48dp; autosizing text (8-12sp) keeps labels
   legible at 360dp and at increased font scales without clipping.
3. WHOIS returns from `runNetworkTool()` **before** `toolsRunning = true`, so
   RUN stays enabled and STOP never appears. `whoisInFlight` (volatile) blocks a
   second request until the first finishes, in `finally`.
4. Same `ipWhois` URL, same `showInfoDialog`; no backend change.
5. Device Monitor long-press untouched and still calls the same method
   (line 4902), so it inherits the corrected field mapping.
6. `asn_name` / `rdap_name` / `abuse_contact` first, with `asnName` / `netName`
   / `abuse` fallbacks; `optString` everywhere, so a rolled-back backend cannot
   throw. Empty values are skipped rather than printed blank.
7. `splitIpPort()` handles IPv4, bracketed IPv6, unbracketed IPv6 as emitted by
   the VPN service, and a bare address with no port. An address is never
   truncated just because it contains colons.
8. Domain Intel help now says "TLS certificate info" / "Сведения о
   TLS-сертификате" instead of claiming WHOIS.
9. Tested below; RDAP-unavailable renders a short note instead of empty lines.
10. Manual tablet checklist below; PING/TRACE/PORT/DNS/LAN code paths untouched.

## Test results

**JVM harness against the real patched source** (methods extracted verbatim by
script, so the test cannot drift from the implementation): `org.json`
20240303.jar, JDK 17.

```
passed 47, failed 0
```

- 16 host/port cases, each asserting both halves: `1.2.3.4:443`, `1.2.3.4`,
  `1.2.3.4:abc`, `[2606:4700:4700::1111]:443`, `[2606:...]`, `2606:...:443`
  (unbracketed, service format), `2606:...` bare, `2606:4700::1111`, `::1`,
  `::1:443`, `:443`, empty, unclosed `[2606::1`, `2001:db8::/32`,
  `1.1.1.1:65536`, `1.1.1.1:8080`.
- 15 normalization and mapping assertions: bracket stripping, whitespace, null;
  new-backend payload (`APNIC-LABS`, `helpdesk@apnic.net`, `AU (registry)`);
  legacy payload (`asnName`, `netName`, `abuse`, null cidr); RDAP-failure
  payload (Net/Abuse empty, cidr kept from Cymru).

**Static checks:** `activity_main.xml` parses as well-formed XML; `javac`
parse-only pass over `MainActivity.java` reports zero syntax errors (the full
compile needs the Android SDK and was deliberately not run). Button geometry
verified programmatically: all six 48dp, weight 1, autosize on, WHOIS between
DNS and LAN.

**Not verified here:** anything that needs a device - real rendering at 360dp and
at 1.3x/1.5x font scale, dialog appearance, live lookups. Those are in the
manual checklist.

## Manual checklist for the tablet build (after separate build approval)

| Area | Check |
|---|---|
| Network Tools | six buttons visible in order PING TRACE PORT DNS WHOIS LAN, all readable at your font scale |
| WHOIS | `1.1.1.1` → AS13335 (Cloudflare, Inc.), Net APNIC-LABS, Abuse helpdesk@apnic.net, Country AU (registry) |
| WHOIS | `193.0.14.129` → AS25152, RIPE-NCC-K-ROOT, abuse@ripe.net |
| WHOIS | `2606:4700:4700::1111` → AS13335, US (registry) |
| WHOIS | `8.8.8.8` → cidr 8.8.8.0/24 plus "(RDAP unavailable for this address)" |
| WHOIS | `192.168.1.1`, `127.0.0.1`, `foo` → "Not a public IP address" dialog |
| WHOIS | tap RUN twice quickly → second press says a lookup is already running |
| RUN/STOP | after a WHOIS lookup RUN is still enabled, STOP never shown |
| Device Monitor | long-press menu unchanged; WHOIS on IPv4 row now shows ASN name, Net, Abuse |
| Device Monitor | WHOIS on an IPv6 row resolves the full address |
| Tools | DNS, PORT, PING, TRACE, LAN still behave; LAN still hides the host field |
| Traffic Trace | rows and app list identical to baseline |
| Language | EN/RU help and toasts correct |

## Risk notes carried into review

- Autosizing labels rely on API 26+ (minSdk is 30), so no fallback path is
  exercised in practice.
- `splitIpPort` treats a trailing 1-5 digit group as a port only when the
  remainder still looks like an address; a bare IPv6 whose final group is
  numeric and preceded by a non-`::` prefix could be read as host+port. That
  path is not used by any caller (the tools field passes raw text to WHOIS, and
  Device Monitor always appends a real port).
- Adding a sixth button reduces each label's width by ~10dp; if your font scale
  clips `WHOIS`, the fallback is wrapping the row in a HorizontalScrollView with
  `minWidth 64dp` per button.

## State

- Baseline tag `de993d08` untouched; main tree app sources identical to it.
- Live `geoIp` / `ipWhois` / `domainIntel` / `trafficProbe` untouched.
- No APK built, nothing merged, nothing published, private worktree only.
