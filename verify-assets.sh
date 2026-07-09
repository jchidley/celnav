#!/bin/bash
set -euo pipefail

BASE="${1:-$HOME/src/celnav}"
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
require_file() { test -s "$BASE/$1" || fail "missing or empty: $1"; }

for path in \
  data/ephemeris/de440s.bsp \
  data/skyfield/finals2000A.all \
  data/stars/hip_main.dat \
  data/rust-kernels/earth_latest_high_prec.bpc \
  data/rust-kernels/naif0012.tls \
  data/rust-kernels/pck00011.tpc \
  data/rust-kernels/gm_de440.tpc; do
  require_file "$path"
done

for v in 1 2 3 4 5 6; do
  pdf="docs/ho229/pub229-vol${v}.pdf"
  require_file "$pdf"
  pdfinfo "$BASE/$pdf" | grep -q '^Pages:' || fail "unreadable PDF: $pdf"
  pdftotext -f 1 -l 1 "$BASE/$pdf" - | grep -Eq 'SIGHT REDUCTION TABLES|PUB. NO. 229' \
    || fail "unexpected PDF content: $pdf"
done

for path in \
  third_party/xaxero/cnavj.html \
  third_party/xaxero/cnavj-local.html \
  third_party/xaxero/cnavj-manifest.json \
  third_party/xaxero/icons/cnavj-192.png \
  third_party/xaxero/icons/cnavj-512.png \
  third_party/xaxero/assets/react.production.min.js \
  third_party/xaxero/assets/react-dom.production.min.js \
  third_party/xaxero/assets/babel.min.js \
  third_party/xaxero/assets/astronomy.browser.min.js \
  third_party/xaxero/assets/lucide.min.js; do
  require_file "$path"
done
if rg -q 'src="https?://' "$BASE/third_party/xaxero/cnavj-local.html"; then
  fail 'Xaxero local copy still has an external executable script'
fi

uv --directory "$BASE/reference-python" run ruff check .

CELNAV_DATA="$BASE/data" uv --directory "$BASE/reference-python" run python - <<'PY'
import os
from pathlib import Path
from skyfield.api import Loader
from skyfield.data import hipparcos

root = Path(os.environ['CELNAV_DATA'])
Loader(str(root / 'skyfield')).timescale(builtin=False)
with Loader(str(root / 'stars')).open(hipparcos.URL, filename='hip_main.dat') as f:
    assert len(hipparcos.load_dataframe(f)) == 118_218
Loader(str(root / 'ephemeris'))('de440s.bsp')
PY

(
  cd "$BASE/celnav-rs"
  cargo fmt --check
  cargo clippy -- -D warnings
  cargo run >/dev/null
)
(
  cd "$BASE/celnav-browser"
  npm run lint >/dev/null
  npm run build >/dev/null
  npm test >/dev/null
  npm run test:e2e >/dev/null
)

printf 'Asset and backend checks passed for %s\n' "$BASE"
