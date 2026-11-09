# Drift between the tracked `functions/` files and what production runs

`functions/*.ts` is a workspace staging area, not a mirror of the platform. Two
distinct problems show up in this audit: stale tracked files, and a divergence
between GitHub's `main` and the workspace.

## Three-way comparison, 2026-11-09

| Function | GitHub `main` `functions/` | Workspace `functions/` (local `main`) | Deployed / production | Verdict |
|---|---|---|---|---|
| `ipWhois` | 5,550 B `ac14db18…` | 5,550 B `ac14db18…` | 27,812 B `aacf114f…` | tracked file is the retired ipwho.is build; 22,262 B behind production |
| `geoIp` | 3,411 B `01831e4f…` | 3,411 B `01831e4f…` | 25,616 B `6c2e7098…` | tracked file predates Cymru; `geoIp.deploy.ts` (13,256 B) is the rollback build, also superseded |
| `domainIntel` | 5,911 B `0c773a6d…` | 35,001 B `616da0e0…` | 35,001 B `616da0e0…` | GitHub is badly stale; the workspace copy matches production |

## What this means

1. **No tracked `functions/` file describes production for any of the three.**
   `ipWhois` and `geoIp` are stale everywhere; `domainIntel` is correct only in
   the workspace, not on GitHub.
2. **Deploying a tracked file would regress production.** `functions/ipWhois.ts`,
   `functions/geoIp.ts` and GitHub's `functions/domainIntel.ts` all describe
   implementations that are no longer live.
3. **The workspace `functions/domainIntel.ts` is also the rollback source.**
   Overwriting it during a deployment attempt destroys the convenient copy, which
   is why `NetWatchAPK/security/phase1/baseline/` and
   `deployed-snapshots/domainIntel.production-current-616da0e0.ts` now both hold
   it.
4. **GitHub `main` and workspace `main` have diverged.** `main` on GitHub is
   `89855bc7`; the workspace `main` is `a4bb227b`, a separate lineage that GitHub
   rejects on push (large binaries, `GH001`). This audit branch is therefore based
   on GitHub's `main`, and its `functions/` files are GitHub's stale copies.

Recommended follow-up, not performed here: replace the tracked `functions/`
files with pointers to the snapshots in this directory, so the repository stops
advertising retired code. That is a separate, reviewable change.
