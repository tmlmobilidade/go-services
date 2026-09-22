# Map style preview

Use this workflow to preview changes to the light and dark map styles with a
small Lisbon extract. Generated data lives in `maps/data/` and is ignored by
Git.

## Prerequisites

- Docker Desktop running
- At least 4 GB of memory available to Docker for the tile-generation step

All commands below are run from the repository root.

## Generate Lisbon test tiles

Build the local Planetiler image:

```sh
docker build -t tml-go-planetiler -f maps/Dockerfile.planetiler maps
```

Download a compact Lisbon OpenStreetMap extract (rather than the full planet):

```sh
mkdir -p maps/data
curl -L -o maps/data/lisbon.osm.pbf \
  https://download.bbbike.org/osm/bbbike/Lisbon/Lisbon.osm.pbf
```

Generate vector tiles from that extract:

```sh
docker run --rm \
  -e JAVA_TOOL_OPTIONS="-Xms1g -Xmx2g" \
  -v "$PWD/maps/data:/output" \
  tml-go-planetiler \
  --force \
  --download \
  --osm-path=/output/lisbon.osm.pbf \
  --output=/output/current.mbtiles \
  --fetch-wikidata=false \
  --use-wikidata=false \
  --threads=4 \
  --building-merge-z13=false
```

The output is `maps/data/current.mbtiles`. Regenerate it only when changing
tile-generation inputs or when a newer OSM extract is useful; style-only edits
do not require regeneration.

## Run TileServer locally

Build the style-preview image:

```sh
docker build -t tml-go-maps-preview -f maps/Dockerfile.tileserver maps
```

Serve the generated tiles and open <http://localhost:8080>:

```sh
docker run --rm -p 8080:8080 \
  -v "$PWD/maps/data/current.mbtiles:/data/current.mbtiles:ro" \
  tml-go-maps-preview
```

The default style is light. Choose the dark style in the TileServer UI, or open
the configured dark style directly from the styles list.

After a style edit, rebuild the preview image and restart the container. The
MBTiles file can remain mounted as-is.

## Visual check

Check both themes at low, medium, and close zoom levels. In particular, verify
that transport remains prominent, non-transport POIs appear only at the
intended zoom, labels remain readable above buildings, and roads/buildings keep
a clear visual hierarchy.
