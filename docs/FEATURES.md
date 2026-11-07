# Features

Current as of **v2.10.5 (Build 87)**. For step-by-step instructions see the
[user guide](USER_GUIDE.md).

## Traffic Monitor

Select one installed app and see the hosts it contacts.

- Live host log with destination address, session TX/RX and timestamp.
- Traffic Trace for a one-shot look at current connections.
- Trusted-domain marking that persists per domain root.
- Automatic session history with per-session browse, CSV export and delete.
- Session-scoped counters: TX/RX are measured from the moment you tap START, not since boot.

### Accuracy rules
{#accuracy-rules}

Traffic Monitor prefers accuracy over completeness:

- A connection is shown only when its owning UID matches the selected app, resolved through
  `ConnectivityManager.getConnectionOwnerUid`.
- Connections whose owner cannot be confirmed (common for UDP/QUIC flows to CDNs) are
  dropped, never guessed. There is no "show everything" fallback.
- Loopback, link-local, RFC1918, multicast and broadcast destinations are filtered out, as
  are well-known public DNS resolvers (8.8.8.8, 1.1.1.1, 9.9.9.9, 208.67.222.222 and their
  peers). DNS-over-HTTPS traffic is filtered by address too, not just port 53.

Consequence: a quiet log on an idle app is correct behaviour, not a bug.

## Device Monitor

Whole-device view of observed connections, independent of any app selection.

- Rows: app attribution, destination, port, protocol, timestamp.
- Long-press: copy IP, copy hostname (only when genuinely resolved), WHOIS, Domain Intel.
- CSV export shared through the Android share sheet.
- Complete IPv6 addresses in rows, menus and dialog titles (Build 87 fix).

## Domain Intel

- DNS records, TLS certificate subject/issuer/validity, open port probes, CDN/org context.
- Deep scan: certificate-transparency subdomain discovery plus common-prefix probing, with
  bounded work so a large domain cannot stall the UI.
- Report copy/share for pasting into a ticket.

## Domain Checker

Categorised reachability tests (cloud providers, AI services, gaming, finance,
messengers, developer infrastructure). Useful for spotting ISP- or region-level blocking.

## Network Tools

Six rootless tools in one panel: Ping, Trace (≤30 hops), Port, DNS (system resolver or DoH),
LAN scan (ARP cache + ping sweep, UPnP/SSDP, reverse DNS, NetBIOS, HTTP/FTP banners, OUI
vendor lookup) and WHOIS.

### WHOIS

- IP literals only, IPv4 and IPv6, optional port suffix; domains rejected locally by design.
- Single request in flight, enforced with an atomic guard; overlapping taps are refused.
- Fields: Org, ASN (name), CIDR, Country, Net, Registrar, Abuse, Hostname. Empty values are
  omitted rather than rendered as `null`.
- Distinct outcomes for malformed input, HTTP 400, 429, 5xx, timeout, unreachable service and
  unexpected responses.
- Country is RIR registry data, shown as `<CC> (registry)` with a neutral globe icon. It is
  never presented as physical location, and no city/region/coordinate is returned.
- RDAP unavailability is reported in the dialog instead of being hidden.

## Speed Test and My Info

- Speed Test: download/upload throughput and latency against a nearby endpoint.
- My Info: public IP, ISP, timezone, network type, and a map link that opens whichever
  mapping app you choose.

## Cross-cutting

- Terminal-style UI (deep black `#0A0E17`, electric cyan `#00E5FF`), edge-to-edge on
  Android 15/16, usable on large screens and tablets with large font scales.
- English and Russian throughout, switchable at runtime.
- Monitoring services stop when the app is removed from Recents (`onTaskRemoved`), so no
  capture continues invisibly.
- No root, no Usage Access, no analytics SDK, no ads.

## Deliberately out of scope

- No packet payload inspection or content logging; only connection metadata.
- No blocking, firewalling or traffic shaping — NetWatch observes, it does not filter.
- No city-level geolocation of addresses.
- The Windows desktop port covers intelligence and tools, not Traffic Monitor.
