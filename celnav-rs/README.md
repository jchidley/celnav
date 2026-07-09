# Rust/ANISE experiment

This crate verifies that ANISE can open the local JPL DE440s SPK, Earth-orientation BPC, and NAIF planetary constants. It is not yet a celestial-navigation calculation engine.

```bash
cargo run
```

Native Rust support is verified. The WASM target is installed, but ANISE currently fails to compile for `wasm32-unknown-unknown` with its default dependency features; do not start a Rust browser implementation until that compatibility issue is resolved.

For the current boundary and data ownership, see [`../docs/development-status.md`](../docs/development-status.md) and [`../docs/reference-data.md`](../docs/reference-data.md).
