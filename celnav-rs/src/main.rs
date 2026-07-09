use anise::prelude::Almanac;

fn main() {
    let path = concat!(env!("CARGO_MANIFEST_DIR"), "/../data/ephemeris/de440s.bsp");
    let almanac = Almanac::new(path).expect("load JPL DE440s BSP");
    println!("Loaded DE440s BSP: {almanac}");
}
