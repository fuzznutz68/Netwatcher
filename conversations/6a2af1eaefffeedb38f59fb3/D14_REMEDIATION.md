# D14 — Backend Endpoint Security Remediation Plan

**Status:** proposal only. No backend changes deployed. No client-breaking changes.
**Endpoints:** `domainIntel`, `trafficProbe`, `geoIp`, `ipWhois`
**Date:** 2026-11-06

---

## 1. Findings

### F1 — SSRF in `domainIntel` and `trafficProbe` — **HIGH, exploitable now**
Input `domain` is stripped of scheme and path only. There is no hostname
validation, no IP-literal rejection, no post-DNS address check, and redirects are
followed (`redirect: 'follow'`). A caller can submit `127.0.0.1`, `10.0.0.5`,
`169.254.169.254`, `[::1]` or an internal hostname and make the function issue
requests from the platform's network position. Response content is partially
reflected (titles, headers, status), giving a blind-to-semi-blind SSRF primitive.

### F2 — Open TCP port scanning in `trafficProbe` — **HIGH, exploitable now**
`Deno.connect({ hostname, port })` is executed against caller-supplied hosts and
a built-in port list. The function is an unauthenticated port scanner operating
from your platform egress. Consequences: abuse complaints, IP reputation damage,
potential ToS/legal exposure, and reconnaissance of arbitrary third parties.

### F3 — Unauthenticated, unthrottled expensive endpoints — **MEDIUM**
`domainIntel` performs a CT-log query, ~150 DNS prefix probes and up to 200
subdomain resolutions per request. With no auth, quota or cache, a trivial loop
burns platform credits, saturates function concurrency and hammers crt.sh.

### F4 — Plaintext GeoIP and third-party IP disclosure — **MEDIUM**
`geoIp` posts up to 50 IPs per call to `http://ip-api.com` (plain HTTP), with no
cache. This leaks every monitored destination IP to a third party in cleartext
and will hit the provider's free-tier limit (45 req/min) under normal use.

### F5 — Unauthenticated WHOIS enumeration — **LOW/MEDIUM**
`ipWhois` accepts arbitrary IPs with no quota. Lower impact, same abuse class.

### F6 — Logging and error surface — **LOW**
Upstream errors are returned in `errors[]`. No credential leakage observed.
No request-body logging observed.

---

## 2. Remediation design

### 2.1 Input validation (all endpoints)

**Domain-accepting endpoints** (`domainIntel`, `trafficProbe`):
1. Reject anything that is not a plain hostname: no scheme, no userinfo, no port,
   no path, no query, no whitespace.
2. Enforce RFC 1123: total length ≤ 253, labels 1–63, `[a-z0-9-]`, no leading or
   trailing hyphen, at least one dot, final label alphabetic.
3. Reject IP literals outright in domain fields (IPv4 dotted-quad, IPv6 with or
   without brackets, integer/octal/hex forms, IPv4-mapped IPv6).
4. Normalize IDNA to ASCII, lowercase, strip trailing dot.
5. Reject known metadata hostnames (`metadata.google.internal`,
   `instance-data`, `169.254.169.254.nip.io`-style wildcard resolvers).

**IP-accepting endpoints** (`geoIp`, `ipWhois`):
1. Parse with a strict IP parser (not regex), reject zones and mapped forms.
2. Reject any address in the deny list below.

### 2.2 Address deny list — applied after DNS resolution, not only to input

IPv4:
`0.0.0.0/8`, `10.0.0.0/8`, `100.64.0.0/10`, `127.0.0.0/8`, `169.254.0.0/16`,
`172.16.0.0/12`, `192.0.0.0/24`, `192.0.2.0/24`, `192.168.0.0/16`,
`198.18.0.0/15`, `198.51.100.0/24`, `203.0.113.0/24`, `224.0.0.0/4`,
`240.0.0.0/4`, `255.255.255.255/32`.

IPv6:
`::/128`, `::1/128`, `fc00::/7`, `fe80::/10`, `ff00::/8`, `2001:db8::/32`,
`64:ff9b::/96`, `::ffff:0:0/96`, `2002::/16` (6to4).

Cloud metadata: block `169.254.169.254` and provider-specific equivalents at the
**network layer**, not only in application code.

### 2.3 DNS rebinding and redirect protection

- Resolve the hostname **once**, validate every returned A/AAAA record, then
  connect to the validated IP. Do not let the HTTP client re-resolve.
- Because `fetch(hostname)` re-resolves internally, prefer one of:
  - an egress proxy that enforces the allowlist and connects to pinned IPs, or
  - a small fetch wrapper using a custom dispatcher with a fixed IP + `Host`
    header and correct SNI (Deno supports `Deno.connectTls({ hostname, port })`
    for raw TLS; higher-level clients may require a proxy).
- Set `redirect: 'manual'`, follow at most 3 hops, and run the full validation
  pipeline on every `Location` target. Reject protocol downgrade and non-HTTP(S).
- Cap response body (512 KB), headers (32 KB) and total request time (8 s).

### 2.4 Port policy

- `domainIntel`: allow only 80 and 443.
- `trafficProbe`: **remove port scanning from the public endpoint.** If the
  feature is required, restrict it to authenticated users, a fixed port list,
  a per-user daily quota, and an explicit consent/abuse policy. Never allow
  arbitrary port ranges.

### 2.5 Authentication and authorization

The APK cannot hold a reusable secret — any embedded key is extractable. Options,
in preference order:

1. **Authenticated Base44 session** (`createClientFromRequest(req)` + `auth.me()`):
   only signed-in users can call. Simplest and strongest available primitive.
   Requires a client update (attach the platform token).
2. **Per-install token** issued after Play Integrity attestation; revoked on abuse.
   Requires a client update and a token service.
3. **Transitional (no client change):** keep endpoints open but put them behind a
   WAF/API gateway with strict quotas and an app-version allowlist, then deprecate.

Do not ship a static API key in the APK as the long-term answer.

### 2.6 Rate limiting and resource bounds

| Control | Suggested value |
|---------|-----------------|
| Per-IP | 30 req/min, 300 req/hour |
| Per-token/user | 60 req/min |
| Global | 300 req/min (domainIntel: 60) |
| Concurrent requests per instance | 10 |
| Queue depth | 100, then 429 with `Retry-After` |
| Function timeout | 10 s hard |
| Deep-scan requests | 5/min per IP, separate quota |
| Outbound fetch concurrency | 8 |

Return `429` with `Retry-After`; never queue unbounded work.

### 2.7 Caching

- `domainIntel`: 10 min TTL keyed by normalized domain + deep flag.
- Subdomain/DNS results: 10 min.
- `geoIp`: 24 h keyed by IP.
- `ipWhois`: 24 h (7 days for allocation data).
- Negative caching: 60 s for NXDOMAIN, 30 s for upstream failure.
- Cache size cap with LRU eviction; deduplicate concurrent identical requests.

### 2.8 GeoIP hardening

Replace `http://ip-api.com` with one of:
- **Self-hosted MaxMind GeoLite2** (recommended): no per-query disclosure,
  no third-party rate limit, deterministic latency. Requires periodic DB updates
  and licence compliance.
- HTTPS provider with an API key (ipinfo.io / ipapi.co), server-side key only.

Never send full IP lists from untrusted callers without quota — batch size ≤ 50
and cache aggressively.

### 2.9 Logging

Log one structured line per request: timestamp, request id, endpoint, HTTP status,
latency, coarse error code, cache hit/miss, rate-limit bucket. **Never** log full
IPs (truncate to /24 or hash), hostnames, user identifiers or request bodies.
Retention 7–30 days. Alert on error-rate spikes and quota exhaustion.

---

## 3. Immediate containment (no code deploy, no client break)

Apply at the platform/network layer first:

1. **Egress firewall:** deny outbound traffic to RFC1918, link-local, loopback,
   multicast, CGNAT and `169.254.169.254` from function workloads.
2. **Gateway rate limits** on all four endpoints (per-IP and global), returning
   429. This alone stops trivial credit-burn loops.
3. **Disable port-scanning behaviour** via a feature flag if available, or cap
   `trafficProbe` concurrency to 1 and add a short per-IP cooldown.
4. **Cap `deep=true`** requests with a separate tight quota.
5. **Monitor** request volume per endpoint/IP; alert on anomalies.
6. **Cloud metadata:** enforce IMDSv2 / disable IMDS where possible.

None of these change request/response shapes, so the current APK keeps working.

---

## 4. Rollout and client compatibility

| Stage | Action | Client impact |
|-------|--------|---------------|
| 0 | Platform egress deny + gateway rate limits | None |
| 1 | Input validation + address deny list + manual redirects | None for valid input |
| 2 | Caching + geoIP HTTPS provider swap | None |
| 3 | Per-install/auth tokens, version-gated | Requires app update |
| 4 | Remove unauthenticated access for old versions | Breaking — needs review |

Stage 3 needs an app release (v2.11+) and a deprecation window. Until then,
stages 0–2 close the exploitable surface without breaking v2.10.x.

---

## 5. Acceptance criteria

- Requests to loopback/private/link-local/metadata addresses are rejected before
  any outbound connection, verified by automated tests.
- A hostname resolving to a private address is rejected even when the name is public.
- Redirects to prohibited destinations are rejected.
- `trafficProbe` cannot be used to scan arbitrary hosts/ports.
- Rate limits return 429 under burst; no unbounded queue.
- Cache hit ratio > 60% for repeat domains in normal use.
- No plaintext third-party requests remain.
- Logs contain no full IPs or hostnames.
