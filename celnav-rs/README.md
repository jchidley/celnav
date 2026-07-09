# Rust/ANISE experiment

This crate verifies that ANISE can open the local JPL DE440s SPK, Earth-orientation BPC, and NAIF planetary constants. It is not yet a celestial-navigation calculation engine.

```bash
cargo run
```

Native Rust support and a minimal browser WASM wrapper are verified:

```bash
./build-wasm.sh
```

ANISE is deliberately configured without its default `metaload` feature, which pulls native HTTP/TLS dependencies. Browser code must load kernels itself from fetched bytes or user-provided files; the wrapper does not yet implement that or any navigation calculation.

For the current boundary and data ownership, see [`../docs/development-status.md`](../docs/development-status.md) and [`../docs/reference-data.md`](../docs/reference-data.md).
