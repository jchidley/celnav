# Set up the development environment

Use this how-to to prepare a WSL/Debian machine for this repository. Work under Linux home storage such as `~/src/celnav`, not `/mnt/c`.

## Required command-line tools

Install or make available:

- `uv` for the Skyfield reference environment;
- Node.js and npm for the browser app;
- Rust, Cargo, and rustup for ANISE;
- Poppler utilities (`pdfinfo` and `pdftotext`) for validating the local HO 229 PDFs.

On Debian, the only system package normally needed for the final item is:

```bash
sudo apt install poppler-utils
```

## Install project dependencies and data

```bash
cd ~/src/celnav

cd reference-python && uv sync && cd ..
cd celnav-browser && npm install && npx playwright install chromium && cd ..
cd celnav-rs && cargo fetch && cd ..

./download-assets.sh
./verify-assets.sh
```

Playwright Chromium is a local Linux browser runtime used by the end-to-end test. It is needed even if you normally browse with a Windows browser.

## Optional Rust/WASM experiment

The Rust WebAssembly target is installed with:

```bash
rustup target add wasm32-unknown-unknown
```

The repository also requires `wasm-bindgen` CLI at the Rust dependency version. Build the browser wrapper with:

```bash
cd celnav-rs
./build-wasm.sh
```

The wrapper builds and loads in Chromium, but it does not yet load BSP kernels in the browser or perform navigation calculations.
