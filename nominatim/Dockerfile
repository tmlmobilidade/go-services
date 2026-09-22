FROM mediagis/nominatim:5.3

ENV PBF_URL=https://download.geofabrik.de/europe/portugal-latest.osm.pbf \
    REPLICATION_URL=https://download.geofabrik.de/europe/portugal-updates/ \
    UPDATE_MODE=catch-up \
    IMPORT_WIKIPEDIA=false \
    IMPORT_STYLE=full \
    FREEZE=false \
    TZ=Europe/Lisbon

EXPOSE 8080