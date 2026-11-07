# D14 — Containment & Remediation Status

**Nothing below is deployed.** All code is staged in the repo; live functions are unchanged.

## 1. What the hosting environment can enforce

| Control | Enforceable in-function | Needs platform/network config |
|---|---|---|
| Input/domain validation | Yes | — |
| Resolved-IP validation (v4/v6/private/metadata) | Yes | — |
| Redirect validation | Yes | — |
| Per-request timeouts | Yes (`AbortSignal.timeout`) | — |
| Concurrency cap | Yes, **per isolate only** | Global cap needs gateway |
| Rate limiting | Best-effort in-memory, per isolate | Real limit needs gateway/WAF |
| **Egress firewall (block RFC1918/link-local/metadata)** | No | **Yes — the only enforceable anti-rebinding control** |
| Kill switch | Yes (env var) | Env var must be set in the function settings |

The platform deploys each function independently with no cross-file imports, so the
guard is inlined per function. Function-level memory state is not shared across
instances, so in-function rate limiting is a speed bump, not a quota.

## 2. Implemented and tested (staged)

`security/netGuard.mjs` — 219 lines, dependency-free, 13 passing tests:

- IPv4 blocked: 0/8, 10/8, 100.64/10 (CGNAT incl. Alibaba metadata), 127/8,
  169.254/16 (AWS/GCP/Azure metadata), 172.16/12, 192.0.0/24, 192.0.2/24,
  192.88.99/24, 192.168/16, 198.18/15, 198.51.100/24, 203.0.113/24, 224/4, 240/4.
- IPv6 blocked: `::`, `::1`, fc00::/7, fe80::/10, ff00::/8, 2001:db8::/32,
  2001::/32, 100::/64 — plus **unwrapping** of `::ffff:` mapped, v4-compatible,
  NAT64 `64:ff9b::/96` and 6to4 `2002::/16` before re-checking.
- Hostname: RFC1123 labels, ≥2 labels, alphabetic TLD, no IP literal, no scheme,
  no port, no userinfo, no trailing dot, no `.local`/`.internal`/`localhost`,
  explicit metadata hostname list, 253/63 length caps.
- `resolveAndPin()`: resolves A+AAAA, **rejects the host if any record is private**,
  returns the address to connect to.
- `validateRedirect()`: scheme, port (80/443), credentials, and target host.
- `createLimiter()`: concurrency cap + token bucket, bounded map.

## 3. Patch spec — trafficProbe (staged in full)

`security/staged/trafficProbe.patched.ts`:
kill switch → resolve+pin → manual 3-hop redirects → **port scan OFF unless
`PROBE_ALLOW_PORTSCAN=true`** → connect to the pinned IP, never re-resolve.

## 4. Patch spec — domainIntel (not yet written; anchors)

| Line | Current | Change |
|---|---|---|
| 106 | regex-only `cleanDomain` | replace with `normalizeDomain()` + reject |
| 142–152 | DNS fetch for A/AAAA/CNAME | validate every record with `checkResolved()` |
| 164 | crt.sh fetch | fixed host, keep; add timeout cap |
| 309–310 | `fetch(target, redirect:'follow')` | `redirect:'manual'` + `validateRedirect` per hop |

domainIntel is 21 KB with 4 outbound call sites; I did not blind-rewrite it. The patch
above is surgical and needs one review pass before deployment.

## 5. Residual risks (not resolved)

1. **DNS-rebinding TOCTOU on HTTP fetches.** `fetch()` re-resolves internally and TLS
   SNI prevents connecting to a pinned IP with the right certificate. Pinning works for
   raw TCP (`Deno.connect`), not for `fetch`. The enforceable fix is an egress ACL.
2. **No authentication.** Endpoints are open. Recommended: Play Integrity verdict →
   short-lived token issued server-side, or Base44 session auth via
   `createClientFromRequest`. No reusable secret can live in the APK.
3. **Cost.** domainIntel does CT lookup + prefix probes + per-subdomain resolution.
   Deep scan needs a hard cap (proposed: 40 prefixes, 60 resolutions, 512 KB body).
4. In-memory limits do not survive scale-out.

## 6. Recommended immediate containment (owner action, no code deploy)

1. Set `NETWATCH_PROBE_MODE=disabled` on trafficProbe — stops port scanning outright.
2. Set `NETWATCH_PROBE_MODE=disabled` on domainIntel if abuse is suspected.
3. Ask the platform for an egress policy denying RFC1918/link-local/metadata; this is
   the control that actually closes rebinding.
4. Request gateway rate limits per IP and global on all four public functions.
