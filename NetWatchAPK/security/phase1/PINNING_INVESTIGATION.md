# Connection pinning for validated public IPs — feasibility investigation

Question: can `domainIntel` connect to the **IP it already validated** instead of
letting the runtime resolve the hostname again, while keeping TLS hostname
verification and the redirect protections?

Short answer: **yes at the protocol level, unproven on this runtime.** Do not
implement it in Phase 1.

## 1. The gap being closed

`safeGet` resolves the hop hostname over DoH, validates every address, then calls
`fetch(url)` **by hostname**. The runtime resolves again at connect time through
its own resolver. Two different resolvers, one validation: a rebinding attacker
can answer public for the DoH query and private for the connect.

## 2. Protocol-level proof that pinning is possible

Measured from this sandbox against a real public host, connecting to a fixed IP
while presenting the hostname via SNI:

```
SNI one.one.one.one  → TLS OK, cert CN cloudflare-dns.com, SAN includes 1.1.1.1
                       authorized=true, ALPN http/1.1, TLS_AES_256_GCM_SHA384
                       HTTP/1.1 200 OK, Host header honoured
SNI accounts.google.com against the same IP
                     → rejected, ERR_TLS_CERT_ALTNAME_INVALID
```

So the important property holds: the certificate is still verified against the
**hostname in SNI**, not against the IP. Pinning removes DNS from the decision
without weakening TLS identity.

## 3. Why it is still not proven here

Three separate problems, in increasing order of difficulty:

1. **`fetch()` offers no pinning hook.** Neither the WHATWG fetch contract nor
   the platform's fetch implementation exposes "connect to this IP, use this
   name". Pinning requires a socket API: `Deno.connect({ hostname, port })` then
   `Deno.startTls(conn, { hostname })`, and a hand-written HTTP/1.1 exchange.
2. **Runtime permission is unknown.** Base44 functions may not permit raw
   outbound sockets at all; that is exactly the class of capability the platform
   has told us is restricted. This cannot be tested without deploying something.
   A one-function, no-input diagnostic would answer it in a single deploy, which
   is not authorized in Phase 1.
3. **Cost of doing it properly.** A hand-written HTTPS path means re-implementing
   what `fetch` gives us for free, each of which is a new risk:

   - HTTP/1.1 response parsing: status line, headers, `Transfer-Encoding:
     chunked`, `Content-Length`, and the read cap enforced mid-stream.
   - No transparent gzip/brotli: either omit `Accept-Encoding` (some sites serve
     uncompressed HTML, larger payloads) or decompress manually with a second cap.
   - No ALPN/HTTP2: fine for our purposes, but adds a failure mode on servers that
     insist on h2.
   - Redirects must be re-implemented per hop with re-validation (we already do
     this, but now on our own socket code).
   - Multi-IP origins: a pinned attempt to one address may fail while another
     validated address would have worked, so the loop must retry across the
     validated set, which multiplies connection attempts.

   Estimated size: roughly 200–300 lines replacing `fetch` for one code path,
   with more failure surface than the feature removes.

## 4. Options, ranked

| Option | Closes the rebind window | Effort | Risk | Verdict |
|---|---|---|---|---|
| A. Pinned socket connect + manual HTTPS (Deno.connect/startTls) | Fully | High | Medium-high, unproven permission | Only after a diagnostic deploy proves sockets are allowed |
| B. Post-response re-resolution check (resolve again after the fetch, compare, discard on change) | Detection only | Low (~30 lines) | Low | Good Phase 2 candidate: turns a silent window into a logged event |
| C. Platform egress ACL / SSRF proxy | Fully | None for us | None | Confirmed unavailable from Base44; accepted residual risk |
| D. Status quo + short per-hop timeouts | No | None | Low | Current Phase 1 position |

## 5. Recommendation

1. Keep Phase 1 as is: validation stays advisory, and that limitation is stated
   plainly in the report rather than papered over.
2. If the owner wants this closed properly, authorize one throwaway diagnostic
   function whose only job is to report whether `Deno.connect` and
   `Deno.startTls` are permitted, then decide between A and B.
3. In the meantime, B is cheap and worthwhile: it does not prevent a rebind, but
   it makes one visible in the errors array and in logs instead of invisible.
