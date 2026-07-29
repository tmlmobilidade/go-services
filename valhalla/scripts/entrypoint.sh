#!/usr/bin/env bash
set -euo pipefail

sudo mkdir -p /custom_files/backups

# Seed PBF into volume on first boot (bind mount may hide image /custom_files)
if [ ! -s /custom_files/portugal-latest.osm.pbf ]; then
  if [ -s /seed/portugal-latest.osm.pbf ]; then
    echo "[valhalla] Seeding portugal-latest.osm.pbf into /custom_files"
    sudo cp /seed/portugal-latest.osm.pbf /custom_files/portugal-latest.osm.pbf
    sudo chown valhalla:valhalla /custom_files/portugal-latest.osm.pbf
  else
    echo "[valhalla] ERROR: no PBF in /custom_files and no /seed copy. Abort."
    exit 1
  fi
fi

# Upstream docker-valhalla entrypoint
exec /valhalla/scripts/run.sh "$@"
