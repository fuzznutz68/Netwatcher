# Pre-existing defect: CNAME answers are validated as if they were IP addresses

Status: **confirmed, pre-existing, NOT fixed by this patch.** Recorded here so it is
not lost and not mistaken for a Phase 1 regression.

## Symptom

Domain Intel's page phase can fail for any site whose name is behind a CNAME, which
includes most CDN-fronted sites. The scan returns `pageHosts: []` and records

```
page fetch: blocked_resolution: resolved to blocked address dyna.wikimedia.org.
```

`wikipedia.org` reproduces it reliably.

## Cause

The resolver handed to the guarded GET collects every answer record of the DoH
response without checking its type:

```js
const nwResolve = async (h: string): Promise<string[]> => {
  const out: string[] = [];
  for (const t of ['A', 'AAAA']) {
    const rs = await fetchDns(h, t);
    for (const r of rs) out.push(r.data as string);   // <-- no type filter
  }
  return out;
};
```

A DoH answer for a CNAME'd name contains both the `CNAME` record (`type: 5`,
`data: "dyna.wikimedia.org."`) and the resulting `A`/`AAAA` record. The hostname is
pushed into the address list, `isBlockedAddress()` cannot parse it as an IP, and the
"unparseable means blocked" rule refuses the whole fetch.

The same code exists in the deployed baseline (`baseline/domainIntel.ts:636`), so
production behaves identically. It is a correctness bug in the validator's input, not
in the validation rule.

## Blast radius

- `pageHosts` (JS/analytics host extraction) is silently empty for CNAME'd sites.
- `certNames`, `subdomains`, `ipv4`, `ipv6`, `cdn` are unaffected.
- No security impact: the guard is stricter than it needs to be, never looser.

## Fix, when it is authorized

Filter by record type before validating, in `nwResolve` and in the sibling resolver
at the subdomain phase:

```js
for (const r of rs) if (r.type === (t === 'A' ? 1 : 28)) out.push(r.data as string);
```

Roughly a two-line change plus one test asserting a CNAME answer does not produce a
`blocked_resolution` error. Deliberately excluded from D14 Phase 1: the authorization
covers the unbounded-read and CORS/JSON controls, and this changes scan results.
