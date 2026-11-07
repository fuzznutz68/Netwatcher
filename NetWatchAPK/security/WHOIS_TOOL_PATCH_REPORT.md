# WHOIS Network Tools patch - corrections applied, retested

Branch `feat/whois-network-tool`, worktree `/app/wt-whois` from baseline
`de993d08`. Two files, +302 / -31. No build, no merge, no deploy.

## Correction 1 - IP-only input validation

`isIPv4Literal`, `isIPv6Literal`, `isHex` and `isIpLiteral` validate shape only;
nothing resolves names (`InetAddress.getByName` is never called on user input).

`showIpWhois` now rejects before any network activity:

- empty -> "Enter an IP address." dialog
- not a literal -> "WHOIS works with IP addresses only. Enter an IPv4 or IPv6
  address, for example 1.1.1.1 or 2606:4700:4700::1111." dialog
- only then the single-flight gate and the request

`google.com`, `example`, `1.1.1.1:443`, `256.1.1.1`, `1:2:3:4:5:6:7` are all
refused locally, so the backend is never called with a domain. No DNS lookup was
added. The tools tab hint also changes per mode to "IP address (e.g. 1.1.1.1)".

## Correction 2 - parser for the known Device Monitor format

`splitIpPort` is gone; `splitServiceIpPort` replaces it and is called from
exactly one place, `buildDeviceRow`. It no longer applies `lastIndexOf(':')` to
arbitrary strings.

The format is now pinned to what the service actually emits. `NetWatchVpnService.ipv6()`
formats sixteen bytes as eight uncompressed lowercase groups, then `emit()` sends
`ip + ":" + port`. So the wire shapes are exactly:

- IPv4: `a.b.c.d:port` (one colon)
- IPv6: eight groups + port (eight colons)
- bracketed is accepted defensively

Anything with a different colon count is returned whole with an empty port. The
split is trusted only when the port is 1-5 digits <= 65535 and the prefix is a
valid literal. A bare or compressed IPv6 therefore keeps every character, and
the address handed to WHOIS is never truncated.

## Correction 3 - encoding

Byte-level audit of both changed files: valid UTF-8, zero U+FFFD replacement
characters, no double-encoded sequences (`Ð`, `Ñ`, `â€`), and every new Russian
string re-read successfully from disk:

    Введите IP-адрес.
    WHOIS работает только с IP-адресами.
    WHOIS уже выполняется
    WHOIS: превышено время ожидания
    RDAP недоступен для этого адреса
    WHOIS работает только с публичными IP-адресами (не с доменами).

The mojibake you saw does not exist in the source tree; it is introduced by the
viewer/console decoding a UTF-8 file as a single-byte code page. The generated
diff is UTF-8 with Cyrillic context lines intact.

## Single dialog, single request

`whoisInFlight` is now an `AtomicBoolean` claimed with `compareAndSet` through
`acquireWhoisSlot`, released in `finally`. `showWhoisDialog` tracks one
`AlertDialog` and dismisses any visible predecessor before showing a new result,
so results replace rather than stack. Both entry points (tools tab, Device
Monitor long-press) share that dialog.

## Test results

JVM harness built by extracting the methods verbatim from the patched file
(`org.json` 20240303, JDK 17):

```
passed 72, failed 0
```

- **Service format, 17 cases** (both halves asserted): `1.2.3.4:443`,
  `1.1.1.1:8080`, `2606:4700:4700:0:0:0:0:1111:443`, `2001:db8:0:0:0:0:0:1:22`,
  `[2606:4700:4700::1111]:443`, `[2606::1]`, bare `2606:4700:4700::1111`,
  bare `2606:4700:4700:0:0:0:0:1111`, `1.2.3.4`, `::1`, `1.2.3.4:abc`,
  `1.2.3.4:65536`, `999.1.1.1:443`, `2001:db8::/32`, unclosed `[2606::1`,
  empty, `:443`.
- **Literal validation, 20 cases**: valid and invalid dotted quads, leading
  zeros, 7 vs 8 vs 9 group IPv6, `::`, `::ffff:192.168.0.1`, zone id
  `fe80::1%wlan0`, `google.com`, `example`, `1.1.1.1:443`, empty.
- **Normalization, 4 cases**: brackets stripped, whitespace trimmed, null, full
  eight-group address passes through unchanged.
- **Single-flight gate, 4 cases**: first caller wins, second blocked, released
  flag works, null flag refused.
- **Response mapping, 11 cases**: new keys (`asn_name`, `rdap_name`,
  `abuse_contact`, `AU (registry)`), legacy fallbacks (`asnName`, `netName`,
  `abuse`, null cidr), RDAP-failure payload.

**Static checks:** layout is well-formed XML with six equal-weight 48dp buttons
and autosizing labels (8-12sp, all six present); `javac` parse-only pass on
`MainActivity.java` reports zero syntax errors. Full compile needs the Android
SDK and was not run.

## Manual checklist for the tablet build (needs separate build approval)

| Area | Check |
|---|---|
| Network Tools | six buttons PING TRACE PORT DNS WHOIS LAN at normal and enlarged font scale |
| WHOIS | `google.com` -> IP-only dialog, no request sent |
| WHOIS | `1.1.1.1` -> AS13335 (Cloudflare, Inc.), Net APNIC-LABS, AU (registry) |
| WHOIS | `2606:4700:4700::1111` -> full address queried, AS13335, US (registry) |
| WHOIS | `8.8.8.8` -> cidr kept plus "(RDAP unavailable for this address)" |
| WHOIS | `192.168.1.1`, `127.0.0.1` -> "Not a public IP address" |
| WHOIS | RUN tapped twice -> second says a lookup is already running |
| WHOIS | two lookups in sequence -> second dialog replaces the first, never stacks |
| Device Monitor | long-press menu intact; IPv4 and IPv6 rows both resolve fully |
| Tools | PING, TRACE, PORT, DNS, LAN unchanged; LAN still hides the host field |
| Traffic Trace | rows and app list identical to baseline |
| Language | EN/RU dialogs and toasts |

## State

Baseline `de993d08` untouched, main tree sources identical to it, live backend
functions unchanged, no APK built or published. D14 remains PARTIALLY MITIGATED.
