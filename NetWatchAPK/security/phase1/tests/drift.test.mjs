// Drift guard: each patched function must inline nwhttp.mjs verbatim, so the
// unit tests above really do cover the code that would ship.
import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const module_ = fs.readFileSync(path.join(ROOT, 'nwhttp.mjs'), 'utf8');
const inlined = module_.replace(/^export /gm, '');

test('the inlined block matches nwhttp.mjs byte for byte in all three functions', () => {
  for (const name of ['domainIntel', 'geoIp', 'ipWhois']) {
    const src = fs.readFileSync(path.join(ROOT, 'patched', `${name}.ts`), 'utf8');
    assert.ok(src.includes(inlined), `${name}.ts has drifted from nwhttp.mjs — re-run apply_patch.py`);
  }
});

test('the transported module has no imports and no runtime dependencies', () => {
  assert.ok(!/^import\s/m.test(module_), 'module must stay dependency-free');
  assert.ok(!/require\(/.test(module_));
  assert.ok(!/Deno\.|process\./.test(module_), 'module must not touch runtime globals directly');
});

test('generator output is deterministic', async () => {
  // Re-running the generator must not change the files (idempotent).
  const before = {};
  for (const name of ['domainIntel', 'geoIp', 'ipWhois']) {
    before[name] = fs.readFileSync(path.join(ROOT, 'patched', `${name}.ts`), 'utf8');
  }
  const { execFileSync } = await import('node:child_process');
  execFileSync('python3', [path.join(ROOT, 'apply_patch.py')], { stdio: 'pipe' });
  for (const name of ['domainIntel', 'geoIp', 'ipWhois']) {
    const after = fs.readFileSync(path.join(ROOT, 'patched', `${name}.ts`), 'utf8');
    assert.equal(after, before[name], `${name}.ts is not reproducible`);
  }
});
