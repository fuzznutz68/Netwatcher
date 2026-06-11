// NetWatch - Geo-IP lookup (public, no auth required)
// Accepts: { "ips": ["1.2.3.4", "5.6.7.8"] }
// Returns: { "results": { "1.2.3.4": { country, countryCode, city, org, flag } } }

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type',
      }
    });
  }

  try {
    const body = await req.json().catch(() => ({}));
    const { ips } = body as { ips: string[] };

    if (!ips || !Array.isArray(ips) || ips.length === 0) {
      return Response.json({ error: 'ips array is required' }, { status: 400 });
    }

    // Deduplicate and cap at 50
    const unique = [...new Set(ips)].slice(0, 50);

    // ip-api.com batch endpoint — free, no key needed, up to 100 per call
    const batchPayload = unique.map(q => ({ query: q, fields: 'query,status,country,countryCode,city,org,isp' }));

    const resp = await fetch('http://ip-api.com/batch?fields=query,status,country,countryCode,city,org,isp', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(batchPayload),
      signal: AbortSignal.timeout(10000),
    });

    if (!resp.ok) throw new Error('ip-api.com returned ' + resp.status);

    const raw = await resp.json() as any[];

    const countryFlags: Record<string, string> = {
      US:'🇺🇸',GB:'🇬🇧',DE:'🇩🇪',FR:'🇫🇷',NL:'🇳🇱',SE:'🇸🇪',NO:'🇳🇴',FI:'🇫🇮',
      DK:'🇩🇰',CH:'🇨🇭',AT:'🇦🇹',BE:'🇧🇪',ES:'🇪🇸',IT:'🇮🇹',PL:'🇵🇱',CZ:'🇨🇿',
      RU:'🇷🇺',UA:'🇺🇦',TR:'🇹🇷',IL:'🇮🇱',AE:'🇦🇪',SA:'🇸🇦',IN:'🇮🇳',CN:'🇨🇳',
      JP:'🇯🇵',KR:'🇰🇷',SG:'🇸🇬',AU:'🇦🇺',NZ:'🇳🇿',CA:'🇨🇦',BR:'🇧🇷',MX:'🇲🇽',
      AR:'🇦🇷',ZA:'🇿🇦',NG:'🇳🇬',EG:'🇪🇬',HK:'🇭🇰',TW:'🇹🇼',MY:'🇲🇾',TH:'🇹🇭',
      ID:'🇮🇩',PH:'🇵🇭',VN:'🇻🇳',PT:'🇵🇹',RO:'🇷🇴',HU:'🇭🇺',BG:'🇧🇬',HR:'🇭🇷',
      SK:'🇸🇰',SI:'🇸🇮',LT:'🇱🇹',LV:'🇱🇻',EE:'🇪🇪',GR:'🇬🇷',CY:'🇨🇾',LU:'🇱🇺',
      IE:'🇮🇪',IS:'🇮🇸',MT:'🇲🇹',RS:'🇷🇸',BA:'🇧🇦',MK:'🇲🇰',AL:'🇦🇱',MD:'🇲🇩',
      GE:'🇬🇪',AM:'🇦🇲',AZ:'🇦🇿',KZ:'🇰🇿',UZ:'🇺🇿',PK:'🇵🇰',BD:'🇧🇩',LK:'🇱🇰',
      IR:'🇮🇷',IQ:'🇮🇶',JO:'🇯🇴',KW:'🇰🇼',QA:'🇶🇦',BH:'🇧🇭',OM:'🇴🇲',YE:'🇾🇪',
    };

    const results: Record<string, any> = {};
    for (const item of raw) {
      const cc = (item.countryCode || '').toUpperCase();
      results[item.query] = {
        country:     item.status === 'success' ? (item.country  || 'Unknown') : 'Unknown',
        countryCode: cc,
        city:        item.status === 'success' ? (item.city     || '')        : '',
        org:         item.status === 'success' ? (item.org      || item.isp || '') : '',
        flag:        countryFlags[cc] || '🌐',
      };
    }

    return Response.json({ results }, {
      headers: { 'Access-Control-Allow-Origin': '*', 'Content-Type': 'application/json' }
    });

  } catch (err: any) {
    return Response.json({ error: err.message }, { status: 500 });
  }
});
