# Deployed backend source snapshots — D14 Phase 1 (partial)

Purpose: keep a byte-identical record, inside the repository, of the exact source
submitted for the two production deployments authorised on 2026-11-07.

Base44 deploys a single file per function and offers **no read-back of deployed
source**. These snapshots are therefore the *submitted* artefacts, not artefacts
recovered from the platform. Verification that they are what is running is
behavioural, and is documented per function below.

| Function | Source file | SHA-256 | Size | Deployed |
|---|---|---|---|---|
| `ipWhois` | `ipWhois.deployed-2026-11-07.ts` | `aacf114f3140740dcda1c20518101dc252bfaa9c5ea67af0a2bc1270ca52c0ac` | 27,812 B | 2026-11-07 |
| `geoIp` | `geoIp.deployed-2026-11-07.ts` | `6c2e7098ea3640229fc4e0affa555e481f957a68b6f4754c78b4d3ca5331b34b` | 25,616 B | 2026-11-07 |

Both artefacts are byte-identical to `NetWatchAPK/security/phase1/patched/<name>.ts`
at commit `0553d54deb20cd29714a1f45c624fb9ceb4cb172` (branch
`d14/phase1-cors-json-deadline`), which is the reviewed and tested source.

## ipWhois

- Function name: `ipWhois` — `GET /ipWhois?ip=...`, `POST` with JSON body
- Source file: `ipWhois.deployed-2026-11-07.ts`
- SHA-256: `aacf114f3140740dcda1c20518101dc252bfaa9c5ea67af0a2bc1270ca52c0ac`
- Size: 27,812 bytes, 697 lines
- Deployment date: 2026-11-07, during the authorised partial Phase 1 deployment
- Patch reference: commit `0553d54d`, `NetWatchAPK/security/phase1/patched/ipWhois.ts`
- Pre-deploy rollback source: `NetWatchAPK/security/phase1/baseline/ipWhois.ts`
  (15,105 B, `46357618a67fa9ca0763597125c8a5e2a835f28b260c43cffd532e0826b529cf`)

Deployment evidence, captured 2026-11-07 around 17:40 MSK:

- response key set identical to the pre-deploy capture, with no value differences
  other than `timestamp` (`/app/rollback/pre-deploy/ipWhois_v4.json`, `_v6`, `_junk`)
- patch-only control absent from the previous build: `DELETE` returns 405 with
  `Allow: GET, POST, OPTIONS`
- `POST` with `Content-Type: text/plain` returns 415; `POST` with JSON returns 200
- blocked inputs return 400: `127.0.0.1`, `10.0.0.1`, `169.254.169.254`,
  `100.64.0.1`, `::1`, `fe80::1`, `192.168.1.1`, `fd00::1`, `not-an-ip`
- re-checked 2026-11-09: `AS15169`, `US (registry)`, 17 keys, `DELETE` 405

## geoIp

- Function name: `geoIp` — `POST` with JSON `{"ips": [...]}`
- Source file: `geoIp.deployed-2026-11-07.ts`
- SHA-256: `6c2e7098ea3640229fc4e0affa555e481f957a68b6f4754c78b4d3ca5331b34b`
- Size: 25,616 bytes, 629 lines
- Deployment date: 2026-11-07, during the authorised partial Phase 1 deployment
- Patch reference: commit `0553d54d`, `NetWatchAPK/security/phase1/patched/geoIp.ts`
- Pre-deploy rollback source: `NetWatchAPK/security/phase1/baseline/geoIp.ts`
  (13,256 B, `c37942154c0b05e83b4167fc19e4d10141b21ed2cd833e5c2e8483932f62ccfd`)

Deployment evidence, captured 2026-11-07 around 17:40 MSK:

- payload compared to the pre-deploy capture reported `identical payload: True`
  (`/app/rollback/pre-deploy/geoIp.json` vs `/app/rollback/post-geoIp.json`)
- patch-only controls: `GET` and `PUT` return 405; `text/plain` returns 415;
  Windows-style `application/json; charset=utf-8` is accepted
- private and junk inputs map to empty geo fields rather than failing the batch
- re-checked 2026-11-09: `US (registry)`, `Google LLC`, neutral globe flag, `GET` 405

## Known limitations of this verification

1. **No read-back exists.** Base44 cannot return deployed source. Nothing here
   proves byte equality with what the platform runs; it proves which bytes were
   submitted and that live behaviour matches them.
2. **Behavioural identification, not hashing.** The evidence is patch-unique
   signals plus pre/post payload equality. A change preserving all observable
   behaviour would go undetected.
3. **Upstream-dependent values vary.** `ipWhois` changes with RDAP availability:
   on 2026-11-07 ARIN returned HTTP 525, so `rdap_name` was null, `cidr` was
   `8.8.8.0/24` and `errors` contained the 525. On 2026-11-09 RDAP succeeded,
   giving `rdap_name: GOGL`, `cidr: 8.8.8.0 - 8.8.8.255` and empty `errors`. Key
   sets were unchanged, so this is data variance, not a code difference.
4. **Deployment timestamps are approximate.** They come from capture-file mtimes
   in this workspace, not from a platform deployment log.

## Integrity chain

1. `apply_patch.py` regenerates `patched/<name>.ts` from `baseline/<name>.ts`
   deterministically; re-running reproduces the committed blob byte for byte.
2. `patched/<name>.ts` at `0553d54d` hashes to the values above.
3. These snapshot files are byte-identical copies of that blob.
4. The deploy calls submitted exactly this text and the platform reported success.
5. Live behaviour matches the patch-unique signals listed above.

Steps 1 to 4 are cryptographic. Step 5 is behavioural. No step closes the gap
between 4 and 5, because the platform cannot echo its stored copy.
