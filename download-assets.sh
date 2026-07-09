#!/bin/bash
set -euo pipefail

BASE="${1:-$HOME/src/celnav}"
mkdir -p "$BASE/data/ephemeris" "$BASE/docs/ho229" "$BASE/third_party/xaxero"

printf 'Downloading Skyfield/JPL ephemeris into %s/data/ephemeris\n' "$BASE"
cd "$BASE/reference-python"
uv run python - <<'PY'
from skyfield.api import Loader
load = Loader('/home/jack/src/celnav/data/ephemeris')
load('de440s.bsp')
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

printf 'Downloading Xaxero reference pages into %s/third_party/xaxero\n' "$BASE"
cd "$BASE/third_party/xaxero"
curl -fL --retry 2 --connect-timeout 20 -o ho229_info.html https://www.xaxero.com/ho229_info.html
curl -fL --retry 2 --connect-timeout 20 -o cnavj.html https://xaxero.com/tools/cnavj.html
curl -fL --retry 2 --connect-timeout 20 -o cnavjDoc.html https://www.xaxero.com/cnavjDoc.html

printf '\nDone. Local asset sizes:\n'
du -sh "$BASE/data/ephemeris" "$BASE/docs/ho229" "$BASE/third_party/xaxero"
