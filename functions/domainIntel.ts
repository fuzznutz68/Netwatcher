// NetWatch - Domain Intelligence (public, no auth required)
Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: { 'Access-Control-Allow-Origin': '*' } });
  }

  try {
    const body = await req.json().catch(() => ({}));
    const { domain } = body;
    if (!domain) return Response.json({ error: 'Domain is required' }, { status: 400 });

    const cleanDomain = domain
      .replace(/^https?:\/\//, '')
      .replace(/\/.*$/, '')
      .toLowerCase()
      .trim();

    const results: any = {
      domain: cleanDomain,
      timestamp: new Date().toISOString(),
      ipv4: [],
      ipv6: [],
      cname: null,
      subdomains: [],        // [{name, ips:[]}]
      sharedHostDomains: [], // other domains on same IP
      errors: []
    };

    // ── 1. DNS lookups via Cloudflare DoH ────────────────────────────────────
    const fetchDns = async (name: string, type: string) => {
      const r = await fetch(
        `https://cloudflare-dns.com/dns-query?name=${name}&type=${type}`,
        { headers: { Accept: 'application/dns-json' }, signal: AbortSignal.timeout(6000) }
      );
      const d = await r.json();
      return (d.Answer || []) as any[];
    };

    try {
      const recs = await fetchDns(cleanDomain, 'A');
      results.ipv4 = [...new Set(recs.map((r: any) => r.data as string))];
    } catch (e: any) { results.errors.push('A: ' + e.message); }

    try {
      const recs = await fetchDns(cleanDomain, 'AAAA');
      results.ipv6 = [...new Set(recs.map((r: any) => r.data as string))];
    } catch (e: any) { results.errors.push('AAAA: ' + e.message); }

    try {
      const recs = await fetchDns(cleanDomain, 'CNAME');
      if (recs.length > 0) results.cname = recs[0].data;
    } catch (_) {}

    // ── 2. Subdomains ────────────────────────────────────────────────────────
    const subMap = new Map<string, string[]>();

    // Source A: crt.sh certificate transparency logs
    try {
      const r = await fetch(
        `https://crt.sh/?q=%.${cleanDomain}&output=json`,
        { signal: AbortSignal.timeout(15000) }
      );
      if (r.ok) {
        const text = await r.text();
        if (text.trim().startsWith('[')) {
          const rows = JSON.parse(text);
          for (const row of rows) {
            const names = [
              ...(row.name_value || '').split('\n'),
              row.common_name || ''
            ];
            for (const raw of names) {
              const n = raw.trim().toLowerCase().replace(/^\*\./, '');
              if (n.endsWith('.' + cleanDomain) && n !== cleanDomain) {
                if (!subMap.has(n)) subMap.set(n, []);
              }
            }
          }
        }
      }
    } catch (e: any) { results.errors.push('crt.sh: ' + e.message); }

    // Source B: DNS brute-force on common prefixes
    const commonPrefixes = [
      'www', 'mail', 'ftp', 'smtp', 'api', 'dev', 'staging', 'blog', 'shop',
      'app', 'cdn', 'static', 'media', 'admin', 'portal', 'news', 'support',
      'help', 'docs', 'dashboard', 'login', 'secure', 'vpn', 'remote', 'mobile',
      'm', 'img', 'images', 'assets', 'beta', 'test', 'uat', 'prod', 'store',
      'web', 'v2', 'old', 'new', 'api2', 'status', 'auth', 'sso', 'id', 'accounts'
    ];

    const bruteResults = await Promise.allSettled(
      commonPrefixes.map(async (prefix) => {
        const fqdn = `${prefix}.${cleanDomain}`;
        try {
          const recs = await fetchDns(fqdn, 'A');
          if (recs.length > 0) {
            return { name: fqdn, ips: [...new Set(recs.map((r: any) => r.data as string))] };
          }
        } catch (_) {}
        return null;
      })
    );

    for (const r of bruteResults) {
      if (r.status === 'fulfilled' && r.value) {
        subMap.set(r.value.name, r.value.ips);
      }
    }

    // Resolve IPs for crt.sh subdomains that don't have IPs yet (up to 15)
    const noIpSubs = Array.from(subMap.entries())
      .filter(([, ips]) => ips.length === 0)
      .slice(0, 15)
      .map(([name]) => name);

    const resolveResults = await Promise.allSettled(
      noIpSubs.map(async (sub) => {
        try {
          const recs = await fetchDns(sub, 'A');
          return { name: sub, ips: [...new Set(recs.map((r: any) => r.data as string))] };
        } catch (_) { return { name: sub, ips: [] }; }
      })
    );
    for (const r of resolveResults) {
      if (r.status === 'fulfilled') subMap.set(r.value.name, r.value.ips);
    }

    results.subdomains = Array.from(subMap.entries())
      .map(([name, ips]) => ({ name, ips }))
      .sort((a, b) => a.name.localeCompare(b.name))
      .slice(0, 50);

    // ── 3. Shared-host / hidden domains via DNS PTR records ──────────────────
    // For each resolved IP, attempt a PTR lookup
    const ptrDomains = new Set<string>();
    const ipLookups = results.ipv4.slice(0, 3);
    await Promise.allSettled(ipLookups.map(async (ip: string) => {
      try {
        // Reverse the IP for PTR query: e.g. 1.2.3.4 → 4.3.2.1.in-addr.arpa
        const reversed = ip.split('.').reverse().join('.') + '.in-addr.arpa';
        const recs = await fetchDns(reversed, 'PTR');
        for (const r of recs) {
          const ptr = r.data.replace(/\.$/, '').toLowerCase();
          if (ptr && ptr !== cleanDomain) ptrDomains.add(ptr);
        }
      } catch (_) {}
    }));
    results.sharedHostDomains = Array.from(ptrDomains).slice(0, 20);

    return Response.json(results, {
      headers: { 'Access-Control-Allow-Origin': '*', 'Content-Type': 'application/json' }
    });

  } catch (err: any) {
    return Response.json({ error: err.message }, { status: 500 });
  }
});
