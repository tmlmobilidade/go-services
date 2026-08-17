# Map sprite sources

- `maki/`: selected unmodified SVGs from Maki 8.2.0 (CC0-1.0)
- `custom/`: the one-way arrow and variable-width road shields retained by the TML style

Run `node scripts/build-sprites.mjs` from the repository root after changing these files. The script requires Spreet 0.13.1 or newer and writes standard and Retina atlases for both styles.

Do not edit the generated `tileserver/styles/*/sprite.{json,png}` files directly.
