from __future__ import annotations

import argparse
import json
import os
from pathlib import Path

from skyfield.api import E, N, S, W, Loader, wgs84

PROJECT_ROOT = Path(__file__).resolve().parents[1]
DATA_ROOT = Path(os.environ.get("CELNAV_DATA", PROJECT_ROOT / "data"))
EPHEMERIS_DIR = DATA_ROOT / "ephemeris"
IERS_DIR = DATA_ROOT / "skyfield"


def longitude(value: float):
    return abs(value) * (E if value >= 0 else W)


def latitude(value: float):
    return abs(value) * (N if value >= 0 else S)


def angle_0_360(deg: float) -> float:
    return deg % 360.0


def gha_from_ra_and_gast(ra_hours: float, gast_hours: float) -> float:
    """Greenwich hour angle in degrees from right ascension and GAST."""
    return angle_0_360((gast_hours - ra_hours) * 15.0)


def sample(utc: str, body: str, lat: float, lon: float) -> dict:
    ephemeris = Loader(str(EPHEMERIS_DIR))
    iers = Loader(str(IERS_DIR))
    # Do not silently fall back to Skyfield's static, built-in historic table.
    # `download-assets.sh` refreshes finals2000A.all when it is over 30 days old.
    ts = iers.timescale(builtin=False)
    eph = ephemeris("de440s.bsp")

    # Expected UTC form: YYYY-MM-DDTHH:MM:SSZ.
    date, time = utc.rstrip("Z").split("T")
    year, month, day = map(int, date.split("-"))
    hour, minute, second = map(int, time.split(":"))
    t = ts.utc(year, month, day, hour, minute, second)

    earth = eph["earth"]
    target = eph[body]
    observer = earth + wgs84.latlon(latitude(lat), longitude(lon))

    apparent = observer.at(t).observe(target).apparent()
    alt, az, distance = apparent.altaz()
    ra, dec, _ = earth.at(t).observe(target).apparent().radec(epoch="date")

    return {
        "utc": utc,
        "body": body,
        "lat_deg": lat,
        "lon_deg_east_positive": lon,
        "gha_deg": gha_from_ra_and_gast(ra.hours, t.gast),
        "dec_deg": dec.degrees,
        "hc_geometric_deg": alt.degrees,
        "zn_deg": az.degrees,
        "distance_au": distance.au,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate Skyfield celestial-navigation reference values.")
    parser.add_argument("--utc", default="2026-07-10T12:00:00Z")
    parser.add_argument("--body", default="sun", help="Skyfield body name, e.g. sun, moon, venus")
    parser.add_argument("--lat", type=float, default=20.0)
    parser.add_argument("--lon", type=float, default=-30.0, help="Observer longitude, east positive")
    args = parser.parse_args()

    print(json.dumps(sample(args.utc, args.body, args.lat, args.lon), indent=2))


if __name__ == "__main__":
    main()
