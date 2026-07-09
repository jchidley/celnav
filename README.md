# celnav

Celestial navigation calculation workspace for building and checking browser/CLI apps.

This repository is organised around three independent references:

- **Skyfield/JPL** in `reference-python/` as the high-precision truth generator.
- **TypeScript + Astronomy Engine** in `celnav-browser/` as the practical browser app route.
- **Rust** in `celnav-rs/` as an optional later experiment.

Large data files are downloaded locally and are intentionally not committed. See [environment setup](docs/development-environment.md), [reference data](docs/reference-data.md), and [development status](docs/development-status.md).

## Layout

```text
data/ephemeris/       JPL BSP file (`de440s.bsp`); ignored by git
data/skyfield/        IERS `finals2000A.all` time/Earth-rotation data; ignored by git
data/stars/            Hipparcos star catalogue; ignored by git
data/rust-kernels/     ANISE/SPICE Earth-orientation, time, and frame kernels; ignored by git
docs/ho229/           Local Pub. 229 / HO 229 PDFs; ignored by git
reference-python/     Skyfield reference scripts and uv environment
celnav-browser/       Vite/React/TypeScript browser app
celnav-rs/            Optional Rust prototype
third_party/xaxero/   Local Xaxero HTML snapshots; ignored pending licence/source review
```

## Download local reference assets

From WSL/Debian:

```bash
cd ~/src/celnav
./download-assets.sh
./verify-assets.sh
```

This downloads:

- `de440s.bsp` to `data/ephemeris/` for Skyfield; about 32 MB.
- IERS `finals2000A.all` to `data/skyfield/`, for UTC/UT1/TT handling; it is refreshed after 30 days.
- Hipparcos `hip_main.dat` to `data/stars/`, for proper-motion-aware reference-star work; about 51 MB.
- Pub. 229 / HO 229 PDF volumes 1–6 to `docs/ho229/`; about 39 MB total.
- Xaxero reference HTML, its executable browser dependencies, manifest, icons, and logo to `third_party/xaxero/`. `cnavj-local.html` is rewritten to use the saved JavaScript and works without network access (with system-font fallbacks).
- NAIF/ANISE Rust support kernels to `data/rust-kernels/`: Earth orientation (`.bpc`), leap seconds (`.tls`), and DE440-aligned frame/GM text kernels (`.tpc`).

The Xaxero capture is a readable reference snapshot, not a dependency or a redistributable part of this MIT/Apache-licensed project. Its page claims GPLv3 but its footer says “All rights reserved” and no standalone source repository or licence file was found. Do not copy its code into this project without resolving that conflict with Xaxero.

## Skyfield reference

```bash
cd reference-python
uv run python skyfield_reference.py \
  --utc 2026-07-10T12:00:00Z \
  --body sun \
  --lat 20 \
  --lon -30
```

Output includes GHA, declination, **geometric** computed altitude, and true azimuth `Zn`. Apply refraction and the other chosen nautical correction convention explicitly when comparing an observed sextant altitude.

## Browser app

```bash
cd celnav-browser
npm install
npm run check
npm run dev
```

The browser app uses `astronomy-engine` and should be validated against Skyfield-generated test cases. It is currently only a compiling scaffold; see [development status](docs/development-status.md).

## Rust prototype

```bash
cd celnav-rs
cargo check
```

Rust is a later route. `anise` is installed and its local DE440s BSP load has been smoke-tested. The support kernels needed to develop the next stages are present, but the Rust solution is not yet a celestial-navigation engine: it still needs a documented time-scale, apparent-place, topocentric, and refraction pipeline. Do not treat it as a Skyfield replacement yet.

## About This Code

Almost all of this code is AI/LLM-generated. It's best used as a source of
inspiration for your own AI/LLM efforts rather than as a traditional library.

**This is personal alpha software.** All my GitHub projects should be considered
experimental. If you want to use them:

- **Pin to a specific commit** — don't track `main`, it changes without warning
- **Use AI/LLM to adapt** — without AI assistance, these projects are hard to use
- **Treat as inspiration** — build your own version rather than depending on mine

**Suggestions welcome** — If you have ideas for improvements or changes, I'd be
delighted to read them and use them as inspiration for my own efforts.

## License

This project source is dual-licensed under the terms of both the MIT license and
the Apache License (Version 2.0), at your option.

See [LICENSE-APACHE](LICENSE-APACHE) and [LICENSE-MIT](LICENSE-MIT) for details.

Downloaded reference data, PDFs, and third-party HTML/apps retain their own licences/terms and are not committed here by default.

### Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in this project by you, as defined in the Apache-2.0 license,
shall be dual licensed as above, without any additional terms or conditions.
