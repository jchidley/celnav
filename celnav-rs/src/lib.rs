//! Browser-facing boundary for the Rust/ANISE experiment.
//!
//! It intentionally exposes only a capability probe until the celestial-navigation
//! calculation contract and browser-side kernel-loading design are specified.

use wasm_bindgen::prelude::*;

/// Confirms that the minimal ANISE dependency configuration was compiled for WebAssembly.
#[wasm_bindgen]
pub fn backend_status() -> String {
    "celnav-rs WebAssembly backend is available; navigation calculations are not implemented yet."
        .into()
}
