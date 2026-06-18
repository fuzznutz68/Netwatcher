// NetWatch - Domain Intelligence v2 (public, no auth required)
// Enhanced: crt.sh + brute-force + CDN detection + live/dead split

const CDN_CNAME_PATTERNS: Record<string, string> = {
  'cloudflare': 'Cloudflare',
  'akamai': 'Akamai',
  'akamaitechnologies': 'Akamai',
  'fastly': 'Fastly',
  'cloudfront': 'AWS CloudFront',
  'amazonaws': 'AWS',
  'googleusercontent': 'Google Cloud',
  'googleplex': 'Google',
  'goog': 'Google',
  'azureedge': 'Azure CDN',
  'azure': 'Microsoft Azure',
  'msecnd': 'Azure CDN',
  'cdn77': 'CDN77',
  'stackpathcdn': 'StackPath',
  'netdna-cdn': 'StackPath',
  'maxcdn': 'StackPath',
  'edgekey': 'Akamai Edge',
  'edgesuite': 'Akamai Edge',
  'edgecastcdn': 'Verizon EdgeCast',
  'llnwd': 'Limelight',
  'limelight': 'Limelight',
  'incapdns': 'Imperva/Incapsula',
  'impervadns': 'Imperva',
  'sucuri': 'Sucuri',
  'zendesk': 'Zendesk',
  'shopify': 'Shopify',
  'github.io': 'GitHub Pages',
  'netlify': 'Netlify',
  'vercel': 'Vercel',
  'pages.dev': 'Cloudflare Pages',
  'workers.dev': 'Cloudflare Workers',
  'heroku': 'Heroku',
  'wpengine': 'WP Engine',
  'kinsta': 'Kinsta',
  'bunny.net': 'BunnyCDN',
  'b-cdn.net': 'BunnyCDN',
};

const CDN_IP_RANGES: Array<{prefix: string, label: string}> = [
  { prefix: '104.16.', label: 'Cloudflare' },
  { prefix: '104.17.', label: 'Cloudflare' },
  { prefix: '104.18.', label: 'Cloudflare' },
  { prefix: '104.19.', label: 'Cloudflare' },
  { prefix: '104.20.', label: 'Cloudflare' },
  { prefix: '104.21.', label: 'Cloudflare' },
  { prefix: '172.64.', label: 'Cloudflare' },
  { prefix: '172.65.', label: 'Cloudflare' },
  { prefix: '172.66.', label: 'Cloudflare' },
  { prefix: '172.67.', label: 'Cloudflare' },
  { prefix: '162.158.', label: 'Cloudflare' },
  { prefix: '198.41.', label: 'Cloudflare' },
  { prefix: '23.227.38.', label: 'Shopify' },
  { prefix: '151.101.', label: 'Fastly' },
  { prefix: '199.232.', label: 'Fastly/GitHub' },
  { prefix: '13.', label: 'AWS' },
  { prefix: '52.', label: 'AWS' },
  { prefix: '54.', label: 'AWS' },
  { prefix: '34.', label: 'Google Cloud' },
  { prefix: '35.', label: 'Google Cloud' },
  { prefix: '142.250.', label: 'Google' },
  { prefix: '216.58.', label: 'Google' },
  { prefix: '172.217.', label: 'Google' },
  { prefix: '20.', label: 'Microsoft Azure' },
  { prefix: '40.', label: 'Microsoft Azure' },
];

function detectCdn(cname: string, ips: string[]): string | null {
  if (cname) {
    const cn = cname.toLowerCase();
    for (const [pattern, label] of Object.entries(CDN_CNAME_PATTERNS)) {
      if (cn.includes(pattern)) return label;
    }
  }
  for (const ip of ips) {
    for (const range of CDN_IP_RANGES) {
      if (ip.startsWith(range.prefix)) return range.label;
    }
  }
  return null;
}

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
      cdn: null,
      subdomains: [],
      sharedHostDomains: [],
      errors: []
    };

    // ── DNS helper via Cloudflare DoH ────────────────────────────────────────
    const fetchDns = async (name: string, type: string) => {
      const r = await fetch(
        `https://cloudflare-dns.com/dns-query?name=${encodeURIComponent(name)}&type=${type}`,
        { headers: { Accept: 'application/dns-json' }, signal: AbortSignal.timeout(7000) }
      );
      const d = await r.json();
      return (d.Answer || []) as any[];
    };

    // ── 1. Root domain DNS ───────────────────────────────────────────────────
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
      if (recs.length > 0) results.cname = recs[0].data.replace(/\.$/, '');
    } catch (_) {}

    // Root CDN detection
    results.cdn = detectCdn(results.cname || '', results.ipv4);

    // ── 2. crt.sh certificate transparency ──────────────────────────────────
    const subSet = new Set<string>();
    try {
      const r = await fetch(
        `https://crt.sh/?q=%.${cleanDomain}&output=json`,
        { signal: AbortSignal.timeout(20000) }
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
              if (n.endsWith('.' + cleanDomain) && n !== cleanDomain && !n.includes(' ') && !n.includes('@')) {
                subSet.add(n);
              }
            }
          }
        }
      }
    } catch (e: any) { results.errors.push('crt.sh: ' + e.message); }

    // ── 3. DNS brute-force common prefixes ───────────────────────────────────
    const commonPrefixes = [
      'www', 'www2', 'mail', 'ftp', 'smtp', 'pop', 'imap',
      'api', 'api2', 'api3', 'rest', 'graphql', 'ws', 'websocket',
      'dev', 'staging', 'stage', 'uat', 'test', 'beta', 'alpha', 'preview',
      'prod', 'production', 'old', 'new', 'v1', 'v2', 'v3',
      'app', 'apps', 'web', 'portal', 'dashboard', 'console', 'panel',
      'admin', 'manage', 'management', 'cp', 'cpanel', 'plesk',
      'cdn', 'cdn2', 'static', 'assets', 'media', 'img', 'images', 'video',
      'upload', 'uploads', 'files', 'download', 'downloads', 'content',
      'blog', 'news', 'forum', 'community', 'shop', 'store', 'pay',
      'auth', 'sso', 'login', 'oauth', 'accounts', 'id', 'identity',
      'support', 'help', 'docs', 'documentation', 'kb', 'status', 'monitor',
      'vpn', 'remote', 'secure', 'ssl', 'mobile', 'm', 'wap',
      'smtp', 'mx', 'mx1', 'mx2', 'relay', 'bounce',
      'analytics', 'track', 'tracking', 'pixel', 'stats',
      'search', 'data', 'db', 'sql', 'cache', 'redis',
      'git', 'gitlab', 'github', 'ci', 'jenkins', 'build',
      'grafana', 'kibana', 'elastic', 'logs',
      'ns1', 'ns2', 'ns3', 'dns', 'dns1', 'dns2',
    ];

    const bruteResults = await Promise.allSettled(
      commonPrefixes.map(async (prefix) => {
        const fqdn = `${prefix}.${cleanDomain}`;
        try {
          const recs = await fetchDns(fqdn, 'A');
          if (recs.length > 0) subSet.add(fqdn);
        } catch (_) {}
      })
    );

    // ── 4. Resolve all discovered subdomains in parallel (batched) ────────────
    const allSubs = Array.from(subSet).sort();
    const BATCH = 20;
    const subdomainResults: any[] = [];

    for (let i = 0; i < Math.min(allSubs.length, 150); i += BATCH) {
      const batch = allSubs.slice(i, i + BATCH);
      const resolved = await Promise.allSettled(
        batch.map(async (sub) => {
          try {
            const [aRecs, cnameRecs] = await Promise.allSettled([
              fetchDns(sub, 'A'),
              fetchDns(sub, 'CNAME'),
            ]);
            const ips: string[] = aRecs.status === 'fulfilled'
              ? [...new Set(aRecs.value.map((r: any) => r.data as string))]
              : [];
            const subCname = cnameRecs.status === 'fulfilled' && cnameRecs.value.length > 0
              ? cnameRecs.value[0].data.replace(/\.$/, '')
              : null;
            const cdn = detectCdn(subCname || '', ips);
            const live = ips.length > 0;
            return { name: sub, ips, cname: subCname, cdn, live };
          } catch (_) {
            return { name: sub, ips: [], cname: null, cdn: null, live: false };
          }
        })
      );
      for (const r of resolved) {
        if (r.status === 'fulfilled') subdomainResults.push(r.value);
      }
    }

    // Sort: live first, then alphabetical
    subdomainResults.sort((a, b) => {
      if (a.live !== b.live) return a.live ? -1 : 1;
      return a.name.localeCompare(b.name);
    });

    results.subdomains = subdomainResults;
    results.totalDiscovered = allSubs.length;
    results.liveCount = subdomainResults.filter(s => s.live).length;

    // ── 5. PTR / Shared-host ─────────────────────────────────────────────────
    const ptrDomains = new Set<string>();
    await Promise.allSettled(results.ipv4.slice(0, 3).map(async (ip: string) => {
      try {
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
