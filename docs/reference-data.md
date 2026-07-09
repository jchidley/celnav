# Reference data

This reference describes the local data used by the project. It does not describe celestial-navigation reduction rules; those will be specified alongside the shared calculation tests.

Run `./download-assets.sh` from the repository root to obtain or refresh the assets. They remain ignored by Git because they are large, third-party, or both. Run `./verify-assets.sh` to validate the local installation.

## Skyfield reference data

| File | Local path | Purpose | Source/update policy |
|---|---|---|---|
| JPL DE440s SPK | `data/ephemeris/de440s.bsp` | Solar-system body vectors, 1849-12-25 through 2150-01-21 | Skyfield managed download; immutable file |
| IERS finals | `data/skyfield/finals2000A.all` | UTC/UT1 and Earth-orientation values for Skyfield time scales | Skyfield/IERS; downloader refreshes after 30 days |
| Hipparcos catalogue | `data/stars/hip_main.dat` | Reference-star coordinates and proper motion | CDS/VizieR via Skyfield |

Skyfield is the numerical reference for the project. Its current script reports a **geometric** topocentric altitude, not a complete simulated sextant reduction. Refraction and every nautical correction must be requested and tested explicitly.

## HO 229/Pub. 229 reference PDFs

`docs/ho229/pub229-vol1.pdf` through `pub229-vol6.pdf` are locally downloaded reference copies of the six latitude-band volumes. They are used to inspect and validate the human table workflow; the project must not treat them as a machine-readable source or redistribute them.

Source: `https://maritimesafetyinnovationlab.org/wp-content/uploads/2015/01/229-vol-N.pdf`.

## Rust/ANISE support kernels

| File | Purpose | Source |
|---|---|---|
| `earth_latest_high_prec.bpc` | Earth orientation | NAIF generic kernels |
| `naif0012.tls` | Leap-second kernel | NAIF generic kernels |
| `pck00011.tpc` | Planetary constants/frame text kernel | NAIF generic kernels |
| `gm_de440.tpc` | DE440-aligned gravitational parameters | NAIF generic kernels |

The native Rust smoke test loads the DE440s BSP, the Earth BPC, and planetary constants converted from the two TPC files. This proves the assets can be read; it does not prove a nautical calculation pipeline.

## Xaxero local reference capture

`third_party/xaxero/` is an ignored local snapshot of the Xaxero HO-229 web app. `cnavj.html` is the unmodified capture. `cnavj-local.html` rewrites executable script paths to locally saved copies so it can run without network access.

It must not be copied into this repository's MIT/Apache source. Xaxero's page asserts GPLv3, but its footer asserts “All rights reserved”; no public repository or licence file was found. This is unresolved.
