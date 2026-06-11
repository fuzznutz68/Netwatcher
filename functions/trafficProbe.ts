import { createClientFromRequest } from 'npm:@base44/sdk@0.8.31';

Deno.serve(async (req) => {
  try {
    const base44 = createClientFromRequest(req);
    const user = await base44.auth.me();
    if (!user) {
      return Response.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const body = await req.json().catch(() => ({}));
    const { domain } = body;

    if (!domain) {
      return Response.json({ error: 'Domain is required' }, { status: 400 });
    }

    const cleanDomain = domain.replace(/^https?:\/\//, '').replace(/\/.*$/, '').toLowerCase().trim();
    const results: any = {
      domain: cleanDomain,
      timestamp: new Date().toISOString(),
      reachability: {},
      ports: [],
      traceroute: null,
      headers: null,
      tlsInfo: null,
      errors: []
    };

    // --- Reachability: HTTP + HTTPS ---
    for (const proto of ['http', 'https']) {
      try {
        const start = Date.now();
        const res = await fetch(`${proto}://${cleanDomain}`, {
          method: 'HEAD',
          signal: AbortSignal.timeout(8000),
          redirect: 'follow'
        });
        const latency = Date.now() - start;
        results.reachability[proto] = {
          reachable: true,
          statusCode: res.status,
          latencyMs: latency,
          finalUrl: res.url
        };
        // Grab response headers for HTTPS
        if (proto === 'https') {
          const headers: any = {};
          res.headers.forEach((v, k) => { headers[k] = v; });
          results.headers = headers;
        }
      } catch (e: any) {
        results.reachability[proto] = { reachable: false, error: e.message };
        results.errors.push(`${proto.toUpperCase()} probe failed: ${e.message}`);
      }
    }

    // --- Common Port Checks (TCP connect via fetch HEAD trick) ---
    const commonPorts = [
      { port: 80, label: 'HTTP' },
      { port: 443, label: 'HTTPS' },
      { port: 21, label: 'FTP' },
      { port: 22, label: 'SSH' },
      { port: 25, label: 'SMTP' },
      { port: 3306, label: 'MySQL' },
      { port: 8080, label: 'HTTP-Alt' },
      { port: 8443, label: 'HTTPS-Alt' }
    ];

    await Promise.allSettled(commonPorts.map(async ({ port, label }) => {
      try {
        const conn = await Deno.connect({ hostname: cleanDomain, port, transport: 'tcp' });
        conn.close();
        results.ports.push({ port, label, open: true });
      } catch (_) {
        results.ports.push({ port, label, open: false });
      }
    }));
    results.ports.sort((a: any, b: any) => a.port - b.port);

    // --- DNS resolution timing ---
    try {
      const dnsStart = Date.now();
      const dnsRes = await fetch(`https://cloudflare-dns.com/dns-query?name=${cleanDomain}&type=A`, {
        headers: { 'Accept': 'application/dns-json' },
        signal: AbortSignal.timeout(5000)
      });
      const dnsData = await dnsRes.json();
      const dnsLatency = Date.now() - dnsStart;
      results.dnsResolution = {
        latencyMs: dnsLatency,
        ips: (dnsData.Answer || []).map((r: any) => r.data)
      };
    } catch (e: any) {
      results.errors.push(`DNS timing failed: ${e.message}`);
    }

    // --- TLS Certificate info ---
    try {
      const tlsRes = await fetch(`https://api.certspotter.com/v1/issuances?domain=${cleanDomain}&include_subdomains=false&expand=dns_names&expand=issuer&expand=cert`, {
        signal: AbortSignal.timeout(8000)
      });
      if (tlsRes.ok) {
        const certs = await tlsRes.json();
        if (certs.length > 0) {
          const latest = certs[0];
          results.tlsInfo = {
            issuer: latest.issuer?.name || 'Unknown',
            dnsNames: latest.dns_names || [],
            notBefore: latest.cert?.not_before,
            notAfter: latest.cert?.not_after
          };
        }
      }
    } catch (e: any) {
      results.errors.push(`TLS info fetch failed: ${e.message}`);
    }

    return Response.json(results);
  } catch (error: any) {
    return Response.json({ error: error.message }, { status: 500 });
  }
});
