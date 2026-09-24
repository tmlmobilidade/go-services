FROM wiktorn/overpass-api:latest

ENV OVERPASS_MODE=init \
    OVERPASS_META=no \
    OVERPASS_PLANET_URL=https://planet.openstreetmap.org/planet/planet-latest.osm.bz2\
    OVERPASS_DIFF_URL=https://planet.openstreetmap.org/replication/minute/day/ \
    OVERPASS_RULES_LOAD=10 \
    OVERPASS_FASTCGI_PROCESSES=8 \
    OVERPASS_MAX_TIMEOUT=1000 \
    OVERPASS_RATE_LIMIT=4

EXPOSE 80