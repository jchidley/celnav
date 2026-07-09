#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"
cargo build --release --target wasm32-unknown-unknown --lib
rm -rf pkg
wasm-bindgen \
  --target web \
  --out-dir pkg \
  --out-name celnav_rs \
  target/wasm32-unknown-unknown/release/celnav_rs.wasm
