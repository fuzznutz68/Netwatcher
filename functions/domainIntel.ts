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

    // Normalize domain
    const cleanDomain = domain.replace(/^https?:\/\//, '').replace(/\/.*$/, '').toLowerCase().trim();

    const results: any = {
      domain: cleanDomain,
      timestamp: new Date().toISOString(),
      dns: {},
      subdomains: [],
      whois: null,
      reverseIp: [],
      errors: []
    };

    // --- DNS Records via Cloudflare DoH ---
    const dnsTypes = ['A', 'AAAA', 'MX', 'NS', 'TXT', 'CNAME', 'SOA'];
    for (const type of dnsTypes) {
      try {
        const res = await fetch(`https://cloudflare-dns.com/dns-query?name=${cleanDomain}&type=${type}`, {
          headers: { 'Accept': 'application/dns-json' }
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
        results.errors.push(`DNS ${type} lookup failed: ${e.message}`);
      }
    }

    // --- Subdomain enumeration via crt.sh ---
    try {
      const crtRes = await fetch(`https://crt.sh/?q=%25.${cleanDomain}&output=json`, {
        headers: { 'Accept': 'application/json' },
        signal: AbortSignal.timeout(10000)
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
      results.errors.push(`Subdomain enumeration failed: ${e.message}`);
    }

    // --- Reverse IP lookup via HackerTarget ---
    const aRecords = results.dns['A'] || [];
    if (aRecords.length > 0) {
      const ip = aRecords[0].data;
      results.mainIp = ip;
      try {
        const revRes = await fetch(`https://api.hacktarget.com/reverseiplookup/?q=${ip}`, {
          signal: AbortSignal.timeout(8000)
        });
        if (revRes.ok) {
          const text = await revRes.text();
          if (!text.includes('error') && !text.includes('API count exceeded')) {
            results.reverseIp = text.split('\n').filter(Boolean).slice(0, 20);
          }
        }
      } catch (e: any) {
        results.errors.push(`Reverse IP lookup failed: ${e.message}`);
      }
    }

    // --- Subdomain IPs ---
    const subdomainIps: any[] = [];
    const toResolve = results.subdomains.slice(0, 10); // limit to avoid timeout
    await Promise.allSettled(toResolve.map(async (sub: string) => {
      try {
        const res = await fetch(`https://cloudflare-dns.com/dns-query?name=${sub}&type=A`, {
          headers: { 'Accept': 'application/dns-json' },
          signal: AbortSignal.timeout(4000)
        });
        const data = await res.json();
        if (data.Answer && data.Answer.length > 0) {
          subdomainIps.push({
            subdomain: sub,
            ips: data.Answer.map((r: any) => r.data)
          });
        }
      } catch (_) {}
    }));
    results.subdomainIps = subdomainIps;

    return Response.json(results);
  } catch (error: any) {
    return Response.json({ error: error.message }, { status: 500 });
  }
});
