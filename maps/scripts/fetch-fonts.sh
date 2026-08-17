#!/bin/sh

# Restores the pinned, pre-generated Noto Sans MapLibre glyph ranges.

set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
FONT_ROOT="$ROOT_DIR/tileserver/fonts"
ARCHIVE_URL=https://github.com/openmaptiles/fonts/releases/download/v2.0/noto-sans.zip
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

curl -fL "$ARCHIVE_URL" -o "$TEMP_DIR/noto-sans.zip"
unzip -q "$TEMP_DIR/noto-sans.zip" -d "$TEMP_DIR/unpacked"
mkdir -p "$FONT_ROOT"

for FAMILY in "Noto Sans Regular" "Noto Sans Bold" "Noto Sans Italic"; do
  SOURCE=$(find "$TEMP_DIR/unpacked" -type d -name "$FAMILY" -print -quit)
  if [ -z "$SOURCE" ]; then
    echo "Font family not found in archive: $FAMILY" >&2
    exit 1
  fi
  rm -rf "$FONT_ROOT/$FAMILY"
  cp -R "$SOURCE" "$FONT_ROOT/$FAMILY"
done

echo "Installed the three glyph families used by the styles in $FONT_ROOT"
