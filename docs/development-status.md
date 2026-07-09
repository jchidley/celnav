# Development status

This page states the current implementation boundary. It is deliberately conservative: downloaded data and a compiling scaffold do not constitute a validated celestial-navigation application.

## Skyfield reference: usable for test generation

`reference-python/skyfield_reference.py` loads DE440s and fresh IERS data, and produces apparent body positions, geometric topocentric altitude, azimuth, GHA, and declination.

Still needed before calling it a nautical-almanac oracle:

- an agreed output convention for GHA/declination and rounding;
- explicit observer elevation, refraction, dip, index error, limb, semi-diameter, and parallax policies;
- reference-star selection through Hipparcos rather than only solar-system body names;
- a versioned shared test corpus and tests against independently published values.

## TypeScript browser app: scaffold only

`celnav-browser/` builds and imports Astronomy Engine. Its unit test verifies that the dependency loads; a Playwright/Chromium end-to-end test also starts the saved local Xaxero app with external executable scripts blocked. It contains none of the project’s application calculation, form, correction, or comparison logic yet.

Astronomy Engine is appropriate for a compact training/browser calculator. Its stated angular target is about one arcminute, so it must be compared against Skyfield—not treated as a high-precision JPL/SPK implementation.

## Rust/ANISE: native kernel experiment only

`celnav-rs/` proves that ANISE can load the downloaded JPL SPK, Earth BPC, and converted planetary constants. No body-to-observer navigation calculation has been implemented.

The `wasm32-unknown-unknown` Rust target and `wasm-bindgen` CLI are installed. ANISE now builds for it because the project disables ANISE’s default native HTTP/TLS `metaload` feature. A Playwright test loads the generated WASM module in Chromium. The remaining browser design gap is deliberate: a browser cannot use the native filesystem/memory-mapped kernel path, so it needs a safe fetched-byte or user-file kernel-loading API before it can calculate navigation results.

## Xaxero: comparator, not a dependency

The saved Xaxero app is readable and can be served locally. It is useful to inspect its workflow and compare outputs, but its unresolved licence conflict prevents reuse in the project.

## Highest-priority work

1. Define the calculation contract and corrections policy.
2. Generate a versioned Skyfield test corpus covering Sun, Moon, planets, and navigational stars at varied dates and positions.
3. Implement pure sight-reduction logic in TypeScript and test it against that corpus.
4. Add end-to-end tests for the project browser calculator as its UI and calculations are implemented.
