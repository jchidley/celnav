use anise::{
    naif::kpl::parser::convert_tpc,
    prelude::Almanac,
};

fn main() {
    let root = concat!(env!("CARGO_MANIFEST_DIR"), "/../data/");
    let constants = convert_tpc(
        &format!("{root}rust-kernels/pck00011.tpc"),
        &format!("{root}rust-kernels/gm_de440.tpc"),
    )
    .expect("convert NAIF text planetary kernels");

    let bsp = format!("{root}ephemeris/de440s.bsp");
    let earth_orientation = format!("{root}rust-kernels/earth_latest_high_prec.bpc");
    let almanac = Almanac::new(&bsp)
        .expect("load JPL DE440s BSP")
        .load(&earth_orientation)
        .expect("load Earth orientation BPC")
        .with_planetary_data(constants);

    println!("Loaded ANISE kernels: {almanac}");
}
