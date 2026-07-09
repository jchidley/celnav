# Skyfield reference

This directory contains the Python/Skyfield reference calculator. It is the project’s numerical test generator, not an end-user celestial-navigation application.

From the repository root, download and verify its data first:

```bash
./download-assets.sh
./verify-assets.sh
```

Run a sample:

```bash
uv run python skyfield_reference.py --utc 2026-07-10T12:00:00Z --body sun --lat 20 --lon -30
```

The script uses JPL DE440s and the IERS `finals2000A.all` file. Its altitude output is geometric; nautical corrections are deliberately not silently applied.

For current boundaries and missing test coverage, see [`../docs/development-status.md`](../docs/development-status.md).
