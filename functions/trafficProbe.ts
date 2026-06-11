// NetWatch - Traffic Probe function (no auth required - public API)
Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: { 'Access-Control-Allow-Origin': '*' } });
  }

  try {
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

    // --- HTTP + HTTPS reachability ---
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
        if (proto === 'https') {
          const headers: any = {};
          res.headers.forEach((v: string, k: string) => { headers[k] = v; });
          results.headers = headers;
        }
      } catch (e: any) {
        results.reachability[proto] = { reachable: false, error: e.message };
        results.errors.push(`${proto.toUpperCase()} probe: ${e.message}`);
      }
    }

    // --- Port scan ---
    const commonPorts = [
      { port: 80,   label: 'HTTP'      },
      { port: 443,  label: 'HTTPS'     },
      { port: 21,   label: 'FTP'       },
      { port: 22,   label: 'SSH'       },
      { port: 25,   label: 'SMTP'      },
      { port: 3306, label: 'MySQL'     },
      { port: 8080, label: 'HTTP-Alt'  },
      { port: 8443, label: 'HTTPS-Alt' }
    ];

    await Promise.allSettled(commonPorts.map(async ({ port, label }) => {
      try {
        const conn = await (Deno as any).connect({ hostname: cleanDomain, port, transport: 'tcp' });
        conn.close();
        results.ports.push({ port, label, open: true });
      } catch (_) {
        results.ports.push({ port, label, open: false });
      }
    }));
    results.ports.sort((a: any, b: any) => a.port - b.port);

    // --- TLS Certificate info via CertSpotter ---
    try {
      const tlsRes = await fetch(
        `https://api.certspotter.com/v1/issuances?domain=${cleanDomain}&include_subdomains=false&expand=dns_names&expand=issuer&expand=cert`,
        { signal: AbortSignal.timeout(8000) }
      );
      if (tlsRes.ok) {
        const certs = await tlsRes.json();
        if (Array.isArray(certs) && certs.length > 0) {
          const latest = certs[0];
          results.tlsInfo = {
            issuer: latest.issuer?.name || 'Unknown',
            dnsNames: latest.dns_names || [],
            notBefore: latest.cert?.not_before || null,
            notAfter:  latest.cert?.not_after  || null
          };
        }
      }
    } catch (e: any) {
      results.errors.push(`TLS info: ${e.message}`);
    }

    return Response.json(results, {
      headers: { 'Access-Control-Allow-Origin': '*', 'Content-Type': 'application/json' }
    });

  } catch (error: any) {
    return Response.json({ error: error.message }, { status: 500 });
  }
});
