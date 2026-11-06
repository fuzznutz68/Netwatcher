# NetWatch v2.11 — D1/D2 Architecture Comparison

Scope: how to observe network activity without breaking TCP, UDP, DNS, or QUIC.
Status: analysis only. Current engine to remain untouched until a choice is approved and device-tested.

---

## 1. Platform constraint that drives everything

Android's `VpnService` has **no capture-only or mirror mode**. Any packet matching an added route is removed from the normal network path and delivered to the app's TUN file descriptor. From there it must be either forwarded (you implement the transport) or dropped.

Therefore "capture without forwarding" is only achievable by **choosing what enters the tunnel**. The practical choice is DNS: route only the VPN DNS endpoint, leave 0.0.0.0/0 untouched.

Consequences:
- TCP, UDP, QUIC keep using the physical network directly → full connectivity, zero added latency.
- You observe name resolution (the product's core: domain intelligence), not arbitrary connection tuples.
- `addAllowedApplication()` restricts the tunnel to one package → **implicit, exact UID attribution** with no `getConnectionOwnerUid()` heuristics at all.

---

## 2. Options

### Option A — DNS-scoped tunnel (recommended)

VpnService with:
- `addDnsServer("10.99.0.1")` plus `addRoute("10.99.0.1", 32)` — nothing else.
- Per-app mode: `addAllowedApplication(targetPkg)`; device mode: no allow-list.
- A small DNS proxy: parse query, forward over `protect()`ed UDP socket, return the response unmodified (transaction ID preserved). Single request/response, no connection state.

| Criterion | Result |
|---|---|
| TCP / UDP / QUIC connectivity | Untouched — they bypass the tunnel |
| DNS connectivity | Preserved via proxy; add upstream timeout + SERVFAIL on failure |
| UID attribution | Exact in per-app mode (tunnel contains only that app); device mode uses `getConnectionOwnerUid` on DNS sockets (reliable for UDP DNS) |
| Battery | Negligible — a few packets per lookup |
| Reliability | High; no packet state machine |
| Android compatibility | API 30+, pure Java, no NDK, no 16 KB concerns |
| Complexity | M — ~3–5 dev days including lifecycle, tests |
| Rating (1-5) | 5 |

Limitations to document in-app:
- Android Private DNS (DoT) and app-level DoH bypass the VPN DNS → those lookups cannot be observed. Detect Private DNS state and warn.
- Destination IPs of established connections are not visible; domain-level visibility remains.
- `TrafficStats` still supplies per-UID byte counters.

### Option B — Full user-space forwarding (established stacks)

You keep the global route and implement a real datapath.

| Component | Status | Notes |
|---|---|---|
| hev-socks5-tunnel (C) | Maintained | TUN → SOCKS5; needs an upstream; UDP associate for QUIC; NDK integration |
| xjasonlyu/tun2socks (Go) | Maintained | Direct-dial mode; large binary (~8–12 MB/ABI), 20–40 MB RAM |
| lwIP (NetGuard approach) | Mature | You own the TCP state machine and NAT; highest effort |
| badvpn tun2socks | Unmaintained | Not recommended |

| Criterion | Result |
|---|---|
| Connectivity | Full, if the stack is correct; any bug breaks user traffic |
| UID attribution | Available per connection via owner-UID lookup (still imperfect for QUIC) |
| Battery | Moderate to high — every packet traverses userspace |
| Reliability | Medium; handshake, retransmit, MTU, IPv6, teardown edge cases |
| Complexity | L — 15–25 dev days, NDK/16 KB alignment, extensive device testing |
| Rating | 3 |

### Option C — Pulse capture

Open a global tunnel for 2–3 s, sample, close. Connectivity is interrupted during each pulse, which conflicts with the "preserve connectivity" requirement. Not recommended.

### Option D — No VPN at all

`TrafficStats` per UID + `NsdManager`/mDNS + `ConnectivityManager`. Zero risk, zero overhead, but no per-connection visibility for other apps — a functional regression for this product. Viable as a low-power "basic mode" later.

---

## 3. Recommendation

Adopt **Option A** as the v2.11 engine, with per-app attribution via `addAllowedApplication()`.

This directly satisfies every stated requirement: connectivity preserved, low overhead, strict UID scope without heuristics, no paid services, no root, no NDK. It also removes the two worst defects (D1 broken TCP forwarding, D2 one-socket-per-packet) by deleting that code path rather than repairing it.

If per-connection IP visibility is later deemed essential, add Option B as an explicitly opt-in "deep capture" mode, behind a settings flag, with its own warning about battery and traffic handling.

---

## 4. Migration guardrails (when approved)

1. Build the new engine beside the old one behind a feature flag; do not delete the current code first.
2. Device-test on the tablet: browsing, video, gaming, VPN coexistence, airplane mode, Private DNS on/off.
3. Compare host discovery against v2.10.1 on the same network for one week.
4. Keep strict UID filtering semantics unchanged.
5. Only remove the old engine after the new one passes the regression matrix.
