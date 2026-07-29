FROM ghcr.io/valhalla/valhalla-scripted:latest

USER root

ENV server_threads=4 \
    serve_tiles=True \
    use_tiles_ignore_pbf=False \
    tileset_name=valhalla_tiles \
    build_elevation=False \
    build_admins=False \
    build_time_zones=False \
    build_transit=False \
    build_tar=True \
    force_rebuild=False \
    update_existing_config=True \
    TZ=Europe/Lisbon

ARG PBF_URL=https://download.geofabrik.de/europe/portugal-latest.osm.pbf

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      wget ca-certificates \
 && wget -q -O /custom_files/portugal-latest.osm.pbf "$PBF_URL" \
 && test -s /custom_files/portugal-latest.osm.pbf \
 && chown valhalla:valhalla /custom_files/portugal-latest.osm.pbf \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

USER valhalla
WORKDIR /custom_files

EXPOSE 8002
