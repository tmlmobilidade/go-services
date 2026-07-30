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

EXPOSE 8002
