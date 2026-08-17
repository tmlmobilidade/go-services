#!/bin/sh
set -eu

cp -r --update=none /tmp/. /data/

# Run the original entrypoint script from the tileserver image
exec /usr/src/app/docker-entrypoint.sh
