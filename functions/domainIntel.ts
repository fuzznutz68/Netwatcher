// NetWatch - Domain Intelligence function (no auth required - public API)
Deno.serve(async (req) => {
  // Allow CORS for mobile clients
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
      dns: {},
      subdomains: [],
      subdomainIps: [],
      reverseIp: [],
      mainIp: null,
      errors: []
    };

    // --- DNS Records via Cloudflare DoH ---
    const dnsTypes = ['A', 'AAAA', 'MX', 'NS', 'TXT', 'CNAME', 'SOA'];
    for (const type of dnsTypes) {
      try {
        const res = await fetch(`https://cloudflare-dns.com/dns-query?name=${cleanDomain}&type=${type}`, {
          headers: { 'Accept': 'application/dns-json' },
          signal: AbortSignal.timeout(8000)
        });
        const data = await res.json();
        if (data.Answer && data.Answer.length > 0) {
          results.dns[type] = data.Answer.map((r: any) => ({
            name: r.name,
            data: r.data,
            ttl: r.TTL
          }));
        } else {
          results.dns[type] = [];
        }
      } catch (e: any) {
        results.dns[type] = [];
        results.errors.push(`DNS ${type}: ${e.message}`);
      }
    }

    // --- Subdomain enumeration via crt.sh ---
    try {
      const crtRes = await fetch(`https://crt.sh/?q=%25.${cleanDomain}&output=json`, {
        headers: { 'Accept': 'application/json' },
        signal: AbortSignal.timeout(12000)
      });
      if (crtRes.ok) {
        const crtData = await crtRes.json();
        const subdomainSet = new Set<string>();
        for (const entry of crtData) {
          const names = (entry.name_value || '').split('\n');
          for (const name of names) {
            const cleaned = name.trim().toLowerCase().replace(/^\*\./, '');
            if (cleaned.endsWith(cleanDomain) && cleaned !== cleanDomain) {
              subdomainSet.add(cleaned);
            }
          }
        }
        results.subdomains = Array.from(subdomainSet).slice(0, 50);
      }
    } catch (e: any) {
      results.errors.push(`Subdomains: ${e.message}`);
    }

    // --- Main IP + Reverse IP lookup ---
    const aRecords = results.dns['A'] || [];
    if (aRecords.length > 0) {
      const ip = aRecords[0].data;
      results.mainIp = ip;
      try {
        const revRes = await fetch(`https://api.hackertarget.com/reverseiplookup/?q=${ip}`, {
          signal: AbortSignal.timeout(8000)
        });
        if (revRes.ok) {
          const text = await revRes.text();
          if (!text.includes('error') && !text.includes('API count exceeded')) {
            results.reverseIp = text.split('\n').filter(Boolean).slice(0, 20);
          }
        }
      } catch (e: any) {
        results.errors.push(`Reverse IP: ${e.message}`);
      }
    }

    // --- Resolve IPs for top subdomains ---
    const toResolve = results.subdomains.slice(0, 10);
    const subIpResults = await Promise.allSettled(toResolve.map(async (sub: string) => {
      try {
        const res = await fetch(`https://cloudflare-dns.com/dns-query?name=${sub}&type=A`, {
          headers: { 'Accept': 'application/dns-json' },
          signal: AbortSignal.timeout(4000)
        });
        const data = await res.json();
        if (data.Answer && data.Answer.length > 0) {
          return { subdomain: sub, ips: data.Answer.map((r: any) => r.data) };
        }
      } catch (_) {}
      return null;
    }));
    results.subdomainIps = subIpResults
      .filter((r: any) => r.status === 'fulfilled' && r.value)
      .map((r: any) => r.value);

    return Response.json(results, {
      headers: { 'Access-Control-Allow-Origin': '*', 'Content-Type': 'application/json' }
    });

  } catch (error: any) {
    return Response.json({ error: error.message }, { status: 500 });
  }
});
