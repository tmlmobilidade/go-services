FROM ghcr.io/onthegomap/planetiler:latest

ENV JAVA_TOOL_OPTIONS="-Xms6g -Xmx14g"

COPY tileserver /output

CMD [ \
  "--force", \
  "--download", \
  "--osm_url=https://download.geofabrik.de/europe-latest.osm.pbf", \
  "--fetch-wikidata=false", \
  "--use_wikidata=false", \
  "--refresh-sources", \
  "--free_osm_after_read", \
  "--threads=9", \
  "--output=/output/next.mbtiles" \
]
