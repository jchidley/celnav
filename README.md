# celnav

Celestial navigation calculation workspace for building and checking browser/CLI apps.

This repository is organised around three independent references:

- **Skyfield/JPL** in `reference-python/` as the high-precision truth generator.
- **TypeScript + Astronomy Engine** in `celnav-browser/` as the practical browser app route.
- **Rust** in `celnav-rs/` as an optional later experiment.

Large data files are downloaded locally and are intentionally not committed.

## Layout

```text
data/ephemeris/       Local JPL BSP files, e.g. de440s.bsp; ignored by git
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
```

This downloads:

- `de440s.bsp` to `data/ephemeris/` for Skyfield; about 32 MB.
- Pub. 229 / HO 229 PDF volumes 1–6 to `docs/ho229/`; about 39 MB total.
- Xaxero reference HTML pages to `third_party/xaxero/`.

## Skyfield reference

```bash
cd reference-python
uv run python skyfield_reference.py \
  --utc 2026-07-10T12:00:00Z \
  --body sun \
  --lat 20 \
  --lon -30
```

Output includes GHA, declination, computed altitude `Hc`, and true azimuth `Zn`.

## Browser app

```bash
cd celnav-browser
npm install
npm run check
npm run dev
```

The browser app uses `astronomy-engine` and should be validated against Skyfield-generated test cases.

## Rust prototype

```bash
cd celnav-rs
cargo check
```

Rust is a later route for an owned calculation core and/or WebAssembly build.

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
