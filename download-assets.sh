#!/bin/bash
set -euo pipefail

BASE="${1:-$HOME/src/celnav}"
mkdir -p "$BASE/data"/{ephemeris,skyfield,stars,rust-kernels} "$BASE/docs/ho229" "$BASE/third_party/xaxero"/{assets,icons}

printf 'Downloading Skyfield/JPL and time-scale data into %s/data\n' "$BASE"
CELNAV_DATA="$BASE/data" uv --directory "$BASE/reference-python" run python - <<'PY'
import os
from pathlib import Path
from skyfield.api import Loader
from skyfield.data import hipparcos

root = Path(os.environ['CELNAV_DATA'])
ephemeris = Loader(str(root / 'ephemeris'))
ephemeris('de440s.bsp')

# UTC-to-UT1/TT work needs current IERS data, unlike the built-in historic table.
iers = Loader(str(root / 'skyfield'))
if not (root / 'skyfield' / 'finals2000A.all').exists() or iers.days_old('finals2000A.all') > 30:
    iers.download('finals2000A.all')
iers.timescale(builtin=False)

# Full reference-star catalogue, including proper motion. Requires pandas (a project dependency).
stars = Loader(str(root / 'stars'))
with stars.open(hipparcos.URL, filename='hip_main.dat'):
    pass
PY

printf 'Downloading HO 229 / Pub. 229 PDF volumes into %s/docs/ho229\n' "$BASE"
cd "$BASE/docs/ho229"
for v in 1 2 3 4 5 6; do
  out="pub229-vol${v}.pdf"
  if [ ! -s "$out" ]; then
    curl -fL --retry 3 --connect-timeout 20 \
      -o "$out" \
      "https://maritimesafetyinnovationlab.org/wp-content/uploads/2015/01/229-vol-${v}.pdf"
  fi
done

printf 'Downloading Xaxero reference app and its executable browser dependencies\n'
cd "$BASE/third_party/xaxero"
curl -fL --retry 2 --connect-timeout 20 -o ho229_info.html https://www.xaxero.com/ho229_info.html
curl -fL --retry 2 --connect-timeout 20 -o cnavj.html https://xaxero.com/tools/cnavj.html
curl -fL --retry 2 --connect-timeout 20 -o cnavjDoc.html https://www.xaxero.com/cnavjDoc.html
curl -fL --retry 2 --connect-timeout 20 -o cnavj-manifest.json https://xaxero.com/tools/cnavj-manifest.json
curl -fL --retry 2 --connect-timeout 20 -o icons/cnavj-192.png https://xaxero.com/tools/icons/cnavj-192.png
curl -fL --retry 2 --connect-timeout 20 -o icons/cnavj-512.png https://xaxero.com/tools/icons/cnavj-512.png
curl -fL --retry 2 --connect-timeout 20 -o assets/react.production.min.js https://cdnjs.cloudflare.com/ajax/libs/react/18.2.0/umd/react.production.min.js
curl -fL --retry 2 --connect-timeout 20 -o assets/react-dom.production.min.js https://cdnjs.cloudflare.com/ajax/libs/react-dom/18.2.0/umd/react-dom.production.min.js
curl -fL --retry 2 --connect-timeout 20 -o assets/babel.min.js https://cdnjs.cloudflare.com/ajax/libs/babel-standalone/7.24.0/babel.min.js
curl -fL --retry 2 --connect-timeout 20 -o assets/astronomy.browser.min.js https://cdn.jsdelivr.net/npm/astronomy-engine@2.1.19/astronomy.browser.min.js
curl -fL --retry 2 --connect-timeout 20 -o assets/lucide.min.js https://cdn.jsdelivr.net/npm/lucide@1.21.0/dist/umd/lucide.min.js
curl -fL --retry 2 --connect-timeout 20 -o assets/logoim.png https://xaxero.com/tools/logoim.png
cp cnavj.html cnavj-local.html
perl -0pi -e 's#https://cdnjs\.cloudflare\.com/ajax/libs/react/18\.2\.0/umd/react\.production\.min\.js#assets/react.production.min.js#g; s#https://cdnjs\.cloudflare\.com/ajax/libs/react-dom/18\.2\.0/umd/react-dom\.production\.min\.js#assets/react-dom.production.min.js#g; s#https://cdnjs\.cloudflare\.com/ajax/libs/babel-standalone/7\.24\.0/babel\.min\.js#assets/babel.min.js#g; s#https://cdn\.jsdelivr\.net/npm/astronomy-engine\@2\.1\.19/astronomy\.browser\.min\.js#assets/astronomy.browser.min.js#g; s#https://cdn\.jsdelivr\.net/npm/lucide\@1\.21\.0/dist/umd/lucide\.min\.js#assets/lucide.min.js#g; s#https://xaxero\.com/tools/logoim\.png#assets/logoim.png#g' cnavj-local.html

printf 'Downloading Rust/ANISE support kernels into %s/data/rust-kernels\n' "$BASE"
cd "$BASE/data/rust-kernels"
curl -fL --retry 3 --connect-timeout 20 -o earth_latest_high_prec.bpc https://naif.jpl.nasa.gov/pub/naif/generic_kernels/pck/earth_latest_high_prec.bpc
curl -fL --retry 3 --connect-timeout 20 -o naif0012.tls https://naif.jpl.nasa.gov/pub/naif/generic_kernels/lsk/naif0012.tls
curl -fL --retry 3 --connect-timeout 20 -o pck00011.tpc https://naif.jpl.nasa.gov/pub/naif/generic_kernels/pck/pck00011.tpc
curl -fL --retry 3 --connect-timeout 20 -o gm_de440.tpc https://naif.jpl.nasa.gov/pub/naif/generic_kernels/pck/gm_de440.tpc

printf '\nDone. Local asset sizes:\n'
du -sh "$BASE/data" "$BASE/docs/ho229" "$BASE/third_party/xaxero"
