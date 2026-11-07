# Device Monitor IPv6 display fix

Branch `fix/device-monitor-ipv6-display`, cut from the verified build 86 source
(`1e5aec70`). Commit `50d54f9d`, one file, one line, +1 / -1.

```diff
--- a/NetWatchAPK/app/src/main/java/com/netwatch/app/MainActivity.java
+++ b/NetWatchAPK/app/src/main/java/com/netwatch/app/MainActivity.java
@@ -4750,7 +4750,7 @@
-                String rawIp  = ipPort.contains(":") ? ipPort.split(":")[0] : ipPort;
+                String rawIp  = splitServiceIpPort(ipPort)[0];   // IPv4 and IPv6 alike
                 String display = (host != null && !host.isEmpty() && !host.equals(rawIp)) ? host : rawIp;
```

Nothing else changed. `NetWatchVpnService`, `splitServiceIpPort` and its parser
rules, Network Tools WHOIS, CSV export, the manifest, both backend functions and
the production baseline are untouched. `baseline-2.10.4-p0-diag` still at
`de993d08`.

## Regression tests

New suite `DmRows` exercises the whole Device Monitor pipeline row by row:
receiver derivation -> row classification -> long-press menu -> WHOIS argument
and dialog title. Production helpers (`splitServiceIpPort`, `isIpLiteral`,
`normalizeIpInput`, `isDigits`, `isHex`, the literal validators) are extracted
verbatim from the patched source; the four inline expressions are replicated
line for line from 4753-4754, 4855-4857, 4884-4886 and 5103-5108, since they
live inside a lambda and a dialog method that this fix must not restructure.

```
DmRows     passed 60, failed 0
Harness2   passed 131, failed 0        (existing WHOIS / parser suite, unchanged)
total      191 assertions, 0 failures
```

Coverage, against the required list:

| Requirement | Assertions |
|---|---|
| Unresolved IPv4 displays correctly | `unresolved-v4`, `unresolved-v4-dns`: display, resolved flag, row line, copy-hostname, WHOIS arg, title |
| Unresolved IPv6 shows the complete address | `unresolved-v6`: display `2a03:2880:f382:90:face:b00c:0:8e`, 8 groups, no `:443` leak |
| IPv6 not falsely classified as resolved | `v6 is not treated as a hostname`, `resolved flag`, `row line == ipPort` |
| Copy Hostname not offered for unresolved IPv6 | `no copy-hostname for unresolved v6`, plus `copy ip still offered` |
| WHOIS gets the full address and titles correctly | `whois argument`, `title uses the address, not a hextet`, `request argument carries no port` |
| Existing IPv4 behaviour unchanged | five IPv4 inputs compared against the pre-fix derivation, plus a resolved-row comparison |

Also asserted, to prove the parser contract was preserved rather than adjusted:

- service shape for the reported address is 8 groups plus a port (8 colons),
  which is the branch `splitServiceIpPort` already had
- `0:0:0:0:0:0:0:1:443` splits to `0:0:0:0:0:0:0:1` / `443`
- uppercase hextets split the same way
- compressed `2606:4700:4700::1111:443` still falls through unchanged (the
  known producer-specific limitation, deliberately not altered)
- bracketed `[2606:4700:4700::1111]:443` unchanged

## Compilation

`:app:compileReleaseJavaWithJavac` -> BUILD SUCCESSFUL in 10s.

No APK was produced: `app-release.apk` is still build 86's artifact, byte for
byte (`919b129d...`, 8,448,804 bytes, mtime 14:28).

## What changes on the device

An unresolved IPv6 row shows one white line with the complete `address:port`,
no cyan hextet and no duplicate yellow line. Long-press drops "Copy Hostname"
because the hostname now equals the IP. The dialog titles itself with the full
address. The lookup argument is unchanged, since it was already correct.

## Pending

APK build, merge, publish and deploy all await separate authorization. Physical
tablet confirmation of the row and the dialog title still outstanding.
