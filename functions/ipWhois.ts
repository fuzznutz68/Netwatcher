// NetWatch - IP WHOIS / Intelligence lookup (public, no auth required)
// Accepts: POST { "ip": "1.2.3.4" }  OR  GET ?ip=1.2.3.4
// Returns: org, asn, country, city, cidr, rdap registrar, abuse contact, hostname

Deno.serve(async (req) => {
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
  };

  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    // ── Accept GET ?ip=... or POST { ip } ───────────────────────────────────
    let ip: string | undefined;

    if (req.method === 'GET') {
      const url = new URL(req.url);
      ip = url.searchParams.get('ip') ?? undefined;
    } else {
      const body = await req.json().catch(() => ({}));
      ip = (body as any).ip;
    }

    if (!ip || typeof ip !== 'string') {
      return Response.json({ error: 'ip is required' }, { status: 400, headers: corsHeaders });
    }

    // Validate basic IP format
    const clean = ip.trim();
    const ipv4 = /^(\d{1,3}\.){3}\d{1,3}$/.test(clean);
    const ipv6 = clean.includes(':');
    if (!ipv4 && !ipv6) {
      return Response.json({ error: 'Invalid IP address' }, { status: 400, headers: corsHeaders });
    }

    const result: any = {
      ip: clean,
      hostname: null,
      org: null,
      asn: null,
      asn_name: null,
      country: null,
      country_code: null,
      city: null,
      cidr: null,
      rdap_name: null,
      rdap_registrar: null,
      abuse_contact: null,
      whois_server: null,
      timestamp: new Date().toISOString(),
      errors: [],
    };

    // ── 1. ip-api.com — fast geo + org + ASN ────────────────────────────────
    try {
      const r = await fetch(
        `http://ip-api.com/json/${encodeURIComponent(clean)}?fields=status,message,country,countryCode,city,org,isp,as,query`,
        { signal: AbortSignal.timeout(5000) }
      );
      const d = await r.json() as any;
      if (d.status === 'success') {
        result.org = d.org || d.isp || null;
        result.country = d.country || null;
        result.country_code = d.countryCode || null;
        result.city = d.city || null;
        if (d.as) {
          const asParts = d.as.match(/^(AS\d+)\s+(.+)$/);
          if (asParts) { result.asn = asParts[1]; result.asn_name = asParts[2]; }
          else { result.asn = d.as; }
        }
      }
    } catch (e: any) { result.errors.push('ip-api: ' + e.message); }

    // ── 2. ipinfo.io — hostname ──────────────────────────────────────────────
    try {
      const r = await fetch(
        `https://ipinfo.io/${encodeURIComponent(clean)}/hostname`,
        { signal: AbortSignal.timeout(4000) }
      );
      if (r.ok) {
        const h = (await r.text()).trim();
        if (h && h !== clean && !h.startsWith('<') && !h.includes('Rate limit')) {
          result.hostname = h;
        }
      }
    } catch (e: any) { result.errors.push('ipinfo hostname: ' + e.message); }

    // ── 3. RDAP lookup — CIDR, network name, abuse contact ──────────────────
    const rdapBootstrap = ipv4 ? [
      `https://rdap.arin.net/registry/ip/${clean}`,
      `https://rdap.db.ripe.net/ip/${clean}`,
      `https://rdap.apnic.net/ip/${clean}`,
      `https://rdap.lacnic.net/rdap/ip/${clean}`,
      `https://rdap.afrinic.net/rdap/ip/${clean}`,
    ] : [
      `https://rdap.arin.net/registry/ip/${encodeURIComponent(clean)}`,
      `https://rdap.db.ripe.net/ip/${encodeURIComponent(clean)}`,
    ];

    for (const url of rdapBootstrap) {
      try {
        const r = await fetch(url, {
          headers: { Accept: 'application/rdap+json' },
          signal: AbortSignal.timeout(6000),
        });
        if (!r.ok) continue;
        const d = await r.json() as any;

        result.rdap_name = d.name || null;

        if (d.cidr0_cidrs && d.cidr0_cidrs.length > 0) {
          const c = d.cidr0_cidrs[0];
          result.cidr = `${c.v4prefix || c.v6prefix}/${c.length}`;
        } else if (d.startAddress && d.endAddress) {
          result.cidr = `${d.startAddress} – ${d.endAddress}`;
        }

        const extractEntities = (entities: any[]) => {
          for (const e of (entities || [])) {
            const roles = e.roles || [];
            const vcardArr = e.vcardArray ? e.vcardArray[1] : [];
            const name = vcardArr.find((v: any) => v[0] === 'fn')?.[3] || '';
            const email = vcardArr.find((v: any) => v[0] === 'email')?.[3] || '';
            if (roles.includes('abuse') && (name || email)) {
              result.abuse_contact = email || name;
            }
            if ((roles.includes('registrant') || roles.includes('administrative')) && name && !result.rdap_registrar) {
              result.rdap_registrar = name;
            }
            if (e.entities) extractEntities(e.entities);
          }
        };
        extractEntities(d.entities || []);
        break;
      } catch (_) {}
    }

    return Response.json(result, {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' }
    });

  } catch (err: any) {
    return Response.json({ error: err.message }, {
      status: 500,
      headers: { 'Access-Control-Allow-Origin': '*' }
    });
  }
});
