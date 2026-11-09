# Drift between the tracked `functions/` files and what production runs

The repository tracks `functions/*.ts`, but those files are a *workspace staging
area*, not a mirror of the platform. For two of the three functions they describe
code that production no longer executes.

| Function | Tracked `functions/` file | Deployed artifact | Verdict |
|---|---|---|---|
| `ipWhois` | `ipWhois.ts` — 5,550 B, `ac14db18…` | 27,812 B, `aacf114f…` | **STALE** — the tracked file is the retired ipwho.is implementation, 22,262 B smaller than what runs |
| `geoIp` | `geoIp.ts` — 3,411 B, `01831e4f…` | 25,616 B, `6c2e7098…` | **STALE** — the tracked file predates the Cymru rewrite |
| `geoIp` (staging copy) | `geoIp.deploy.ts` — 13,256 B, `c3794215…` | 25,616 B, `6c2e7098…` | **STALE** — this is the pre-deploy Cymru build, i.e. the rollback source, not what runs |
| `domainIntel` | `domainIntel.ts` — 35,001 B, `616da0e0…` | `616da0e0…` (Phase 2, unchanged) | **CURRENT** — matches the production baseline and the rollback copy |

Consequences:

- Anyone reading `functions/ipWhois.ts` or `functions/geoIp.ts` would conclude the
  backend is far simpler than it is, and would not see any Phase 1 hardening.
- A future deploy of either tracked file would silently regress production to a
  pre-Cymru implementation.
- `functions/domainIntel.ts` is correct today, but it is also the rollback source.
  Overwriting it during a deployment attempt destroys that copy unless the
  snapshot in `NetWatchAPK/security/phase1/baseline/` is used instead.

Recommended follow-up, not performed here because these snapshots are the
authoritative record and `functions/` was out of scope: point the tracked
`functions/` files at the deployed artifacts (or replace them with a one-line
pointer plus the checksum), so the repository stops advertising retired code.

Verification date: 2026-11-09. `functions/` files were read only; none were
modified.
