# Valhalla

Docker image `valhalla-tml` — Portugal OSM routing + daily Geofabrik update.

```bash
docker compose build
docker compose up -d
docker logs -f valhalla

# or on instance:
sudo ./scripts/install.sh
```

- Local: `http://127.0.0.1:8002`
- Cron `04:00`: `scripts/update-portugal-osm.sh`
