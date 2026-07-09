from __future__ import annotations

import argparse
import json
from math import atan2, degrees

from skyfield.api import Loader, N, S, E, W, wgs84

EPHEMERIS_DIR = "/home/jack/src/celnav/data/ephemeris"


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
    load = Loader(EPHEMERIS_DIR)
    ts = load.timescale()
    eph = load("de440s.bsp")

    # Skyfield accepts separate components more robustly than arbitrary strings.
    # Expected form here: YYYY-MM-DDTHH:MM:SSZ
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
        "hc_deg": alt.degrees,
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
