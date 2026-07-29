#!/usr/bin/env bash
# Bootstrap Valhalla (Portugal) on a fresh instance.
# Run as root or with sudo: sudo ./install.sh
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VALHALLA_DIR="/opt/valhalla"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_USER="${SUDO_USER:-${USER}}"

echo "[valhalla-install] Target: $VALHALLA_DIR (owner: $INSTALL_USER)"

if ! command -v docker >/dev/null 2>&1; then
  echo "[valhalla-install] ERROR: docker not found. Install Docker first."
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "[valhalla-install] ERROR: docker compose not found."
  exit 1
fi

if command -v timedatectl >/dev/null 2>&1; then
  timedatectl set-timezone Europe/Lisbon || true
fi

mkdir -p "$VALHALLA_DIR/custom_files/backups"
cp "$SCRIPT_DIR/Dockerfile" "$VALHALLA_DIR/Dockerfile"
cp "$SCRIPT_DIR/entrypoint.sh" "$VALHALLA_DIR/entrypoint.sh"
cp "$SCRIPT_DIR/docker-compose.yml" "$VALHALLA_DIR/docker-compose.yml"
cp "$SCRIPT_DIR/update-portugal-osm.sh" "$VALHALLA_DIR/update-portugal-osm.sh"
chmod +x "$VALHALLA_DIR/entrypoint.sh" "$VALHALLA_DIR/update-portugal-osm.sh"
chown -R "$INSTALL_USER:$INSTALL_USER" "$VALHALLA_DIR"

CRON_LINE="0 4 * * * $VALHALLA_DIR/update-portugal-osm.sh >> $VALHALLA_DIR/update.log 2>&1"
EXISTING_CRON="$(crontab -u "$INSTALL_USER" -l 2>/dev/null || true)"
if ! echo "$EXISTING_CRON" | grep -Fq "update-portugal-osm.sh"; then
  (echo "$EXISTING_CRON"; echo "$CRON_LINE") | crontab -u "$INSTALL_USER" -
  echo "[valhalla-install] Cron installed (04:00 Europe/Lisbon)."
else
  echo "[valhalla-install] Cron already present. Skip."
fi

if getent group docker >/dev/null 2>&1; then
  usermod -aG docker "$INSTALL_USER" || true
fi

cd "$VALHALLA_DIR"
echo "[valhalla-install] Building image (downloads Portugal PBF)..."
sudo -u "$INSTALL_USER" docker compose build
sudo -u "$INSTALL_USER" docker compose up -d

echo "[valhalla-install] Done."
