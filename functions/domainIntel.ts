// NetWatch - Domain Intelligence v3 (public, no auth required)
// Enhanced: crt.sh + brute-force + CDN detection + cross-domain discovery + deep PTR

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

// Extract the registrable domain (e.g. "api.paypal.com" -> "paypal.com")
function getRegistrableDomain(host: string): string {
  const parts = host.split('.');
  if (parts.length <= 2) return host;
  const multiTlds = ['co.uk', 'co.jp', 'com.au', 'com.br', 'co.kr', 'com.cn', 'com.tw', 'com.hk', 'com.sg', 'co.in', 'com.mx', 'co.za'];
  const lastTwo = parts.slice(-2).join('.');
  if (multiTlds.includes(lastTwo)) return parts.slice(-3).join('.');
  return parts.slice(-2).join('.');
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: { 'Access-Control-Allow-Origin': '*' } });
  }

  try {
    const body = await req.json().catch(() => ({}));
    const { domain, deep } = body;
    if (!domain) return Response.json({ error: 'Domain is required' }, { status: 400 });

    const cleanDomain = domain
      .replace(/^https?:\/\//, '')
      .replace(/\/.*$/, '')
      .toLowerCase()
      .trim();

    const isDeep = deep === true || deep === 'true';

    const results: any = {
      domain: cleanDomain,
      timestamp: new Date().toISOString(),
      deep: isDeep,
      ipv4: [],
      ipv6: [],
      cname: null,
      cdn: null,
      subdomains: [],
      sharedHostDomains: [],
      crossDomains: [],
      certNames: [],
      pageHosts: [],
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

    results.cdn = detectCdn(results.cname || '', results.ipv4);

    // ── 2. crt.sh certificate transparency ──────────────────────────────────
    const subSet = new Set<string>();
    const crossDomainSet = new Set<string>();
    const certNameSet = new Set<string>();

    try {
      const r = await fetch(
        `https://crt.sh/?q=%25.${cleanDomain}&output=json`,
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
              if (!n || n.includes(' ') || n.includes('@')) continue;
              certNameSet.add(n);

              if (n.endsWith('.' + cleanDomain) && n !== cleanDomain) {
                subSet.add(n);
              }

              // Cross-domain: cert SANs referencing different root domains
              const regDomain = getRegistrableDomain(n);
              if (regDomain !== cleanDomain && regDomain !== getRegistrableDomain(cleanDomain)) {
                const queryLabels = cleanDomain.split('.').slice(-2)[0];
                const regLabels = regDomain.split('.').slice(-2)[0];
                if (queryLabels && regLabels && (regLabels.includes(queryLabels) || queryLabels.includes(regLabels))) {
                  crossDomainSet.add(regDomain);
                }
              }
            }
          }
        }
      }
    } catch (e: any) { results.errors.push('crt.sh: ' + e.message); }

    results.certNames = Array.from(certNameSet).slice(0, 100);

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
      // Additional prefixes for deep scan
      'checkout', 'payment', 'payments', 'billing', 'invoice', 'subscription',
      'sdk', 'hooks', 'webhooks', 'callback', 'redirect',
      'i', 'css', 'js', 'fonts', 'static1', 'static2',
      'edge', 'origin', 'backend', 'server', 'node', 'worker',
      'proxy', 'gateway', 'router', 'lb', 'loadbalancer',
      'sandbox', 'demo', 'trial', 'free', 'plus', 'pro', 'enterprise',
      'internal', 'private', 'public', 'ext', 'external',
      'go', 'link', 'links', 'short', 's', 'r',
      'widget', 'embed', 'iframe', 'frame',
      'notifications', 'push', 'fcm', 'apns', 'firebase',
      'collector', 'ingest', 'event', 'events', 'telemetry',
      'config', 'settings', 'env', 'metadata',
      'health', 'ready', 'alive', 'ping',
      'swagger', 'openapi', 'api-docs',
      'gql', 'query',
      'stream', 'streaming', 'live', 'rtmp', 'hls',
      'storage', 'bucket', 's3', 'blob',
      'ml', 'ai', 'model', 'inference', 'predict',
    ];

    await Promise.allSettled(
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

    for (let i = 0; i < Math.min(allSubs.length, 200); i += BATCH) {
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

    subdomainResults.sort((a, b) => {
      if (a.live !== b.live) return a.live ? -1 : 1;
      return a.name.localeCompare(b.name);
    });

    results.subdomains = subdomainResults;
    results.totalDiscovered = allSubs.length;
    results.liveCount = subdomainResults.filter(s => s.live).length;

    // ── 4b. Page-Embedded Host Discovery (hidden dependencies) ────────────────
    // Fetches the live site and extracts every external hostname referenced in
    // scripts, stylesheets, images, iframes, form actions and inline JS.
    // This is the ONLY way to find domains like ttua.nu that share no DNS,
    // certificate or name similarity with the primary domain.
    try {
      const UAs = { 
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.9'
      };
      
      const htmlPages = await Promise.allSettled([
        fetch(`https://${cleanDomain}/`, { headers: UAs, redirect: 'follow', signal: AbortSignal.timeout(9000) }),
        fetch(`https://www.${cleanDomain}/`, { headers: UAs, redirect: 'follow', signal: AbortSignal.timeout(9000) }),
      ]);
      
      let html = '';
      for (const p of htmlPages) {
        if (p.status === 'fulfilled' && p.value.ok) {
          try { html += await p.value.text(); } catch (_) {}
        }
      }
      html = html.slice(0, 1500000); // safety cap

      if (html.length > 0) {
        const queryReg = getRegistrableDomain(cleanDomain);
        const hostSource = new Map<string, string>(); // host -> source type (first match wins)
        const sourcePriority = ['script', 'iframe', 'form', 'stylesheet', 'img', 'inline'];
        
        const classify = (host: string, src: string) => {
          if (!host || host.includes(' ') || host.includes('@')) return;
          // Skip the query domain itself and its subdomains
          if (host === cleanDomain || host.endsWith('.' + cleanDomain)) return;
          if (getRegistrableDomain(host) === queryReg) return;
          // Skip pure IPs and localhost
          if (/^\d+\.\d+\.\d+\.\d+$/.test(host) || host === 'localhost') return;
          if (!host.includes('.') || host.length > 253) return;
          const existing = hostSource.get(host);
          if (existing && sourcePriority.indexOf(existing) <= sourcePriority.indexOf(src)) return;
          hostSource.set(host, src);
        };

        const extractHost = (u: string): string | null => {
          if (!u) return null;
          const m = u.match(/^(?:https?:)?\/\/([^\/?#'"]+)/);
          if (!m) return null;
          return m[1].toLowerCase().split(':')[0].replace(/\.$/, '');
        };

        // script src= (including trackers, tag managers, analytics)
        let re = /<script[^>]+src=["']([^"']+)["']/gi; let m;
        while ((m = re.exec(html))) classify(extractHost(m[1]) || '', 'script');
        // iframe src=
        re = /<iframe[^>]+src=["']([^"']+)["']/gi;
        while ((m = re.exec(html))) classify(extractHost(m[1]) || '', 'iframe');
        // form action=
        re = /<form[^>]+action=["']([^"']+)["']/gi;
        while ((m = re.exec(html))) classify(extractHost(m[1]) || '', 'form');
        // link href= (stylesheets, preconnect, preloads)
        re = /<link[^>]+href=["']([^"']+)["']/gi;
        while ((m = re.exec(html))) classify(extractHost(m[1]) || '', 'stylesheet');
        // img src=
        re = /<img[^>]+src=["']([^"']+)["']/gi;
        while ((m = re.exec(html))) classify(extractHost(m[1]) || '', 'img');
        // meta refresh + og tags
        re = /<meta[^>]+(?:url|content)=["']([^"']*https?[^"']*)["']/gi;
        while ((m = re.exec(html))) classify(extractHost(m[1]) || '', 'iframe');
        // Generic https:// URLs anywhere (inline JS, JSON blobs, srcset)
        re = /(?:https?:)?\/\/([a-zA-Z0-9][a-zA-Z0-9.-]*\.[a-zA-Z]{2,})(?:[\/"'?#:]|$)/gi;
        while ((m = re.exec(html))) classify(m[1].toLowerCase(), 'inline');

        // Resolve the top external hosts (max 15, scripts first)
        const sortedHosts = Array.from(hostSource.entries())
          .sort((a, b) => {
            const pi = sourcePriority.indexOf(a[1]), pj = sourcePriority.indexOf(b[1]);
            if (pi !== pj) return pi - pj;
            return a[0].localeCompare(b[0]);
          })
          .slice(0, 15);

        const pageResolved = await Promise.allSettled(
          sortedHosts.map(async ([host, src]) => {
            try {
              const [aRecs, cnameRecs] = await Promise.allSettled([
                fetchDns(host, 'A'),
                fetchDns(host, 'CNAME'),
              ]);
              const ips: string[] = aRecs.status === 'fulfilled'
                ? [...new Set(aRecs.value.map((r: any) => r.data as string))]
                : [];
              const cname = cnameRecs.status === 'fulfilled' && cnameRecs.value.length > 0
                ? cnameRecs.value[0].data.replace(/\.$/, '')
                : null;
              const cdn = detectCdn(cname || '', ips);
              return { domain: host, source: src, ips, cname, cdn, live: ips.length > 0 };
            } catch (_) {
              return { domain: host, source: src, ips: [], cname: null, cdn: null, live: false };
            }
          })
        );
        for (const r of pageResolved) {
          if (r.status === 'fulfilled') results.pageHosts.push(r.value);
        }
        // live first, then scripts first
        results.pageHosts.sort((a: any, b: any) => {
          if (a.live !== b.live) return a.live ? -1 : 1;
          const pi = sourcePriority.indexOf(a.source), pj = sourcePriority.indexOf(b.source);
          if (pi !== pj) return pi - pj;
          return a.domain.localeCompare(b.domain);
        });
      }
    } catch (e: any) { results.errors.push('pageEmbed: ' + e.message); }

    // ── 5. Cross-domain discovery ────────────────────────────────────────────
    if (crossDomainSet.size > 0) {
      const crossResults: any[] = [];
      const crossArr = Array.from(crossDomainSet).slice(0, 10);
      const crossResolved = await Promise.allSettled(
        crossArr.map(async (cd) => {
          try {
            const recs = await fetchDns(cd, 'A');
            const ips = [...new Set(recs.map((r: any) => r.data as string))];
            const cnameRecs = await fetchDns(cd, 'CNAME').catch(() => [] as any[]);
            const cname = cnameRecs.length > 0 ? cnameRecs[0].data.replace(/\.$/, '') : null;
            const cdn = detectCdn(cname || '', ips);
            return { domain: cd, ips, cname, cdn, live: ips.length > 0 };
          } catch (_) {
            return { domain: cd, ips: [], cname: null, cdn: null, live: false };
          }
        })
      );
      for (const r of crossResolved) {
        if (r.status === 'fulfilled') crossResults.push(r.value);
      }
      results.crossDomains = crossResults;
    }

    // ── 6. PTR / Shared-host (deep: check ALL resolved IPs) ───────────────────
    const ptrDomains = new Set<string>();
    const ipsToCheck = isDeep
      ? [...new Set([
          ...results.ipv4,
          ...subdomainResults.filter(s => s.live).flatMap(s => s.ips).filter(ip => /^\d+\.\d+\.\d+\.\d+$/.test(ip))
        ])].slice(0, 10)
      : results.ipv4.slice(0, 3);

    await Promise.allSettled(ipsToCheck.map(async (ip: string) => {
      try {
        const reversed = ip.split('.').reverse().join('.') + '.in-addr.arpa';
        const recs = await fetchDns(reversed, 'PTR');
        for (const r of recs) {
          const ptr = r.data.replace(/\.$/, '').toLowerCase();
          if (ptr && ptr !== cleanDomain) {
            ptrDomains.add(ptr);
            const ptrReg = getRegistrableDomain(ptr);
            if (ptrReg !== cleanDomain && ptrReg !== getRegistrableDomain(cleanDomain)) {
              const queryLabel = cleanDomain.split('.').slice(-2)[0];
              const ptrLabel = ptrReg.split('.').slice(-2)[0];
              if (ptrLabel && queryLabel && (ptrLabel.includes(queryLabel) || queryLabel.includes(ptrLabel))) {
                crossDomainSet.add(ptrReg);
              }
            }
          }
        }
      } catch (_) {}
    }));
    results.sharedHostDomains = Array.from(ptrDomains).slice(0, 30);

    // Update crossDomains if PTR revealed more
    if (isDeep && crossDomainSet.size > (results.crossDomains?.length || 0)) {
      const existing = new Set((results.crossDomains || []).map((c: any) => c.domain));
      const newOnes = Array.from(crossDomainSet).filter(d => !existing.has(d)).slice(0, 5);
      if (newOnes.length > 0) {
        const newResolved = await Promise.allSettled(
          newOnes.map(async (cd) => {
            try {
              const recs = await fetchDns(cd, 'A');
              const ips = [...new Set(recs.map((r: any) => r.data as string))];
              return { domain: cd, ips, cname: null, cdn: detectCdn('', ips), live: ips.length > 0 };
            } catch (_) {
              return { domain: cd, ips: [], cname: null, cdn: null, live: false };
            }
          })
        );
        for (const r of newResolved) {
          if (r.status === 'fulfilled') results.crossDomains.push(r.value);
        }
      }
    }

    return Response.json(results, {
      headers: { 'Access-Control-Allow-Origin': '*', 'Content-Type': 'application/json' }
    });

  } catch (err: any) {
    return Response.json({ error: err.message }, { status: 500 });
  }
});
