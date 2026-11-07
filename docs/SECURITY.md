# Security

Status as of **v2.10.6 (Build 88)**. This document is about the app and its backend
functions, not about the Android platform.

## Current posture: PARTIALLY MITIGATED

The app is safe to run, but the backend is not yet fully hardened. State honestly:

| Area | State |
| --- | --- |
| `trafficProbe` backend function | **Disabled.** Returns HTTP 503; no fetch, no port scan. No client calls it. |
| `domainIntel` | Hardened: host validation, private/loopback/metadata rejection, manual redirect handling with a 3-hop cap, 1.5 MB body cap, bounded DNS work. |
| `geoIp` / `ipWhois` | Registry data via Team Cymru over Cloudflare DoH, RIR RDAP and PTR. Input validated, fixed trusted bootstrap hosts, manual redirection, bounded responses, TTL caching. |
| Request authentication | **Not implemented** on the public functions. |
| Platform egress restrictions | **Not implemented.** In-function limits do not replace an infrastructure-level egress ACL and rate limit. |

Consequence: the residual risk is that these endpoints are unauthenticated and exposed.
Mitigations in the functions themselves bound what a single request can do; a determined
abuser with many source addresses is a platform-level concern, not something the app code
can solve. The request for egress ACLs and gateway rate limits is tracked with the hosting
platform.

Functional impact of the disabled probe: none for users. Traffic Monitor and Device Monitor
derive their data on-device; Domain Intel and WHOIS never call `trafficProbe`.

## What the app does with data

- No payload capture. Only connection metadata (address, port, protocol, timestamp, owning
  UID) is read from the local VPN interface.
- No analytics, no crash SDK, no advertising identifiers.
- Lookups send only the queried host or address. No device identifier, install id or user
  identity accompanies a request.
- History, exports and preferences stay in the app's private storage and are removed on
  uninstall.

## Input validation rules worth knowing

- WHOIS accepts public IP literals only. Domain names, hostnames and non-public ranges are
  rejected before any network call, which prevents using the app as an arbitrary-host
  fetcher.
- IPv6 must be a valid literal; service-formatted `addr:port` is split on the last colon only
  when the suffix is numeric and the prefix still parses.
- Backend functions reject hosts that resolve to private, loopback, link-local or metadata
  addresses, including public-looking names that resolve to such an address.

## Data quality caveats (security-adjacent)

- Country values are **registry assignments**, rendered as `<CC> (registry)` with a neutral
  globe icon. They are not physical geolocation and must not be presented as such.
- RDAP availability is intermittent; an unavailable registrar record is reported, never
  invented.

## Signing and supply chain

- Release APKs are signed with the project release certificate
  (`SHA-256 4409b548…bd681af6`). Verify before installing anything claiming to be NetWatch.
- Keystores and `keystore.properties` are excluded from source archives and version control.
- Each release publishes `SHA256SUMS.txt` and, since v2.10.5, a source archive with
  `SOURCE_MANIFEST.sha256` so the APK can be tied to reviewed source.

## Reporting

Open an issue at <https://github.com/fuzznutz68/Netwatcher/issues> for non-sensitive
reports. For anything exploitable, describe it without reproduction detail in the issue and
ask for a private channel.
