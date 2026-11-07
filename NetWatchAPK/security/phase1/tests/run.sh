#!/usr/bin/env bash
# Phase 1 test runner: transpile the patched handlers, then run every suite.
set -euo pipefail
cd "$(dirname "$0")/.."
echo "── 1/3 transpile patched handlers (tsc 5.4)"
rm -rf build && mkdir -p build
npx --yes -p typescript@5.4 tsc --target es2022 --module esnext \
  --moduleResolution bundler --skipLibCheck --outDir build \
  patched/domainIntel.ts patched/geoIp.ts patched/ipWhois.ts
for f in build/*.js; do mv "$f" "${f%.js}.mjs"; done
echo "   built: $(ls build | tr '\n' ' ')"
echo "── 2/3 syntax + generator reproducibility"
python3 apply_patch.py > /dev/null
echo "   apply_patch.py OK"
echo "── 3/3 node --test"
node --test tests/
