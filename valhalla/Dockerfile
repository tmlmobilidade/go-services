FROM ghcr.io/nilsnolde/docker-valhalla/valhalla:latest

USER root

# Runtime defaults (compose no longer sets these)
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
ARG DOWNLOAD_PBF=true

RUN apt-get update \
 && apt-get install -y --no-install-recommends wget ca-certificates tzdata \
 && ln -snf /usr/share/zoneinfo/Europe/Lisbon /etc/localtime \
 && echo Europe/Lisbon > /etc/timezone \
 && mkdir -p /seed /custom_files/backups \
 && if [ "$DOWNLOAD_PBF" = "true" ]; then \
      echo "Downloading Portugal OSM extract..." \
      && wget -q -O /seed/portugal-latest.osm.pbf "$PBF_URL" \
      && test -s /seed/portugal-latest.osm.pbf; \
    fi \
 && chown -R valhalla:valhalla /seed /custom_files \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown valhalla:valhalla /entrypoint.sh

USER valhalla
WORKDIR /custom_files

EXPOSE 8002

ENTRYPOINT ["/entrypoint.sh"]
CMD ["build_tiles"]
