# Network Security Config — Cleartext Endpoint Documentation

**Config:** `app/src/main/res/xml/network_security_config.xml`
**Default:** `cleartextTrafficPermitted="false"`
**Manifest:** `android:usesCleartextTraffic="false"` + `android:networkSecurityConfig="@xml/network_security_config"`

## Why any cleartext remains

The built-in speed test downloads from public third-party test endpoints that
serve **plain HTTP only**. There is no HTTPS equivalent for these hosts, so the
feature would be dead without an exception. Every other app request is HTTPS.

The LAN scanner's HTTP banner probe (port 80/8080) uses **raw TCP sockets**,
which are not governed by Network Security Config. It is therefore unaffected
by the cleartext default and needs no allowlist entry.

## Allowlisted cleartext hosts (speed test)

| Label | Host | Port |
|-------|------|------|
| US East (Linode Newark) | `speedtest.newark.linode.com` | 80 |
| US West (Linode Fremont) | `speedtest.fremont.linode.com` | 80 |
| Canada (Linode Toronto) | `speedtest.toronto.linode.com` | 80 |
| EU (Linode London) | `speedtest.london.linode.com` | 80 |
| EU (Linode Frankfurt) | `speedtest.frankfurt.linode.com` | 80 |
| Asia (Linode Singapore) | `speedtest.singapore.linode.com` | 80 |
| Asia (Linode Tokyo) | `speedtest.tokyo2.linode.com` | 80 |
| US NYC (Ookla Armstrong) | `speedtest-ad-1.zoominternet.net` | 8080 |
| US LA (Ookla GeoLinks) | `la-ookla.geolinks.com` | 8080 |
| US Chicago (Ookla Highline) | `stchi.highlinefast.com` | 8080 |
| US Dallas (Ookla Frontier) | `dallas.tx.speedtest.frontier.com` | 8080 |
| US Miami (Ookla Hotwire) | `speedtest.hotwirecommunications.com` | 8080 |
| Selectel / regional entries | see `SPEED_TEST_SERVERS` in `MainActivity` | 80/8080 |

Source of truth: the `SPEED_TEST_SERVERS` array in `MainActivity.java`.

## HTTPS endpoints (no exception needed)

- Domain Intel / Traffic Probe / GeoIP / WHOIS — `https://…base44.app/functions/*`
- DoH resolution — `https://dns.google`, `https://cloudflare-dns.com`
- My Info / IP geolocation — HTTPS provider
- Domain Checker probes — HTTPS

## Evaluation of narrower rules

| Option | Effect | Verdict |
|--------|--------|---------|
| Global cleartext `true` (previous) | Any HTTP destination permitted | Rejected — too broad |
| Base `false` + host allowlist (adopted) | Only the listed test hosts may use HTTP | Adopted |
| Base `false`, no exceptions | Speed test breaks | Rejected |
| Per-IP allowlist for LAN | NSC cannot express IP ranges, and raw sockets bypass it anyway | Not applicable |

## Residual risk

- A speed-test provider could redirect to a different cleartext host; that test
  would fail until the host is added. Acceptable and visible to the user.
- Host allowlists in NSC are exact hostnames; subdomains must be listed
  explicitly unless `includeSubdomains="true"` is set (not used here).

## Future work

Move the speed test to HTTPS-capable endpoints (Cloudflare/Ookla HTTPS
endpoints or a self-hosted worker) and delete the cleartext allowlist entirely.
