# Build 85 - two fixes implemented and verified

Branch `fix/build85-export-and-whois`, created from `9fac8635` and isolated from
`feat/whois-network-tool`. Fix commit `d25b02b3`, two files, +20 / -10.
No APK, no merge, no release, no deploy. Baseline tag
`baseline-2.10.4-p0-diag` still points at `de993d08`.

## Changed files

```
NetWatchAPK/app/src/main/res/xml/file_provider_paths.xml   | 2 ++
NetWatchAPK/app/src/main/java/com/netwatch/app/MainActivity.java | 28 +++++++++-----
```

Nothing else in the tree moved: `NetWatchVpnService`, `TrafficMonitorService`,
`HistoryManager`, Traffic Trace, app enumeration, both backend functions, and
the current diff/report files are untouched.

## 1. FileProvider root

```diff
 <paths>
     <cache-path name="exports" path="exports/" />
+    <!-- Device Monitor export writes to getExternalFilesDir(null)/NetWatch -->
+    <external-files-path name="device_logs" path="NetWatch/" />
 </paths>
```

Two roots now, both narrow. No `<root-path>`, no `<external-path>`, no traversal.

## 2. WHOIS null handling

```java
/** Android's org.json optString() returns the literal "null" for a JSON null. */
private static String optText(org.json.JSONObject j, String key) {
    if (j == null || j.isNull(key)) return "";
    String v = j.optString(key, "").trim();      // trim before comparing: " null " is null too
    return "null".equals(v) ? "" : v;
}
```

Applied to all nine reads: `asn_name/asnName`, `rdap_name/netName`,
`abuse_contact/abuse`, `rdap_registrar`, `org`, `asn`, `cidr`,
`country/country_code`, `hostname`. `firstNonEmpty` still gives the new key
priority and the legacy name as fallback, and the `rdapDown` detection plus the
"RDAP unavailable for this address" / "RDAP недоступен для этого адреса"
message are byte-identical to before.

### A defect the new tests caught

The first version of the helper compared `"null"` before trimming, so a provider
returning `" null "` still rendered as `null`. The added test
`literal null padded` failed on the first run and the helper was corrected to
trim first. Worth noting because the original proposal you approved had that
ordering bug in it.

## Verification

### Regression suite

JVM harness, methods extracted verbatim from the patched source, `org.json`
20240303, JDK 17:

```
passed 131, failed 0        (92 existing + 39 new)
```

New coverage: JSON null for every field, missing keys, empty strings,
whitespace-only, the literal `"null"`, padded `" null "`, uppercase `"NULL"`
treated as a real value, a null JSONObject, the full body mapping under those
payloads, legacy fallback when the new key is null, new-key priority when both
exist, `country` falling back to `country_code`, and a legacy-only payload.

To test Android behaviour off-device, the harness subclasses `JSONObject` as
`AndroidJson`, overriding `optString` to return `"null"` for a JSON null the way
AOSP does. Desktop `org.json` returns the fallback instead, which is why this
defect never reproduced in earlier runs. The fix keys on `isNull()` first, which
behaves identically on both, so the test is meaningful.

### FileProvider resolution

`verify_fileprovider.py` parses the real `file_provider_paths.xml`, builds the
roots FileProvider would build for `com.netwatch.net`, and resolves candidate
paths the way `SimplePathStrategy` does (canonical containment, longest match):

```
roots declared (2):
  cache-path             name=exports      -> /data/user/0/com.netwatch.net/cache/exports/
  external-files-path    name=device_logs  -> /storage/emulated/0/Android/data/com.netwatch.net/files/NetWatch/

PASS  Device Monitor export   -> root device_logs, suffix /device_log_<ts>.csv
PASS  Domain Intel export     -> root exports,     suffix /NetWatch_Traffic_<app>_<ts>.csv
PASS  unrelated public dir (/storage/emulated/0/Download/...) stays unaddressable
PASS  no root-path, no external-path, no traversal, paths end with /, names unique
PASS  manifest authority ${applicationId}.provider
PASS  manifest points at @xml/file_provider_paths
PASS  both getUriForFile calls use the same authority (2 sites)
```

This is a model of FileProvider's resolution logic, not the real class running on
the device; the on-device confirmation is still the tablet checklist below.

### Compile

`:app:compileReleaseJavaWithJavac` succeeds on the branch. That task runs
resource processing and R generation, which is what a real compile depends on.
No APK was produced: `app-release.apk` is still build 85's artifact, byte for
byte (`8e505c8b...`, mtime 13:54, unchanged).

## Tablet checks after your test build

| Step | Expected |
|---|---|
| Device Monitor, capture rows, Export CSV | share sheet opens; CSV starts `timestamp,app,host,ip_port,protocol` |
| Domain Intel, Export CSV | unchanged, shares from cache |
| Traffic export | unchanged |
| WHOIS `1.1.1.1` | ASN/Org/Country present, no Net/Registrar/Abuse line when RDAP has nothing, never the word "null" |
| WHOIS `2606:4700:4700::1111` | same, no "null" |
| WHOIS from a Device Monitor row | same body, no "null" |
| Traffic Trace and app picker | identical to build 85 |
