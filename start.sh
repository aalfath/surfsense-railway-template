#!/bin/sh
# Railway mounts volumes owned by root; SurfSense runs as uid 1000.
set -e
DATA="${SURFSENSE_LOCAL_DATA_DIR:-/data}"
mkdir -p "$DATA"
if [ "$(id -u)" = "0" ]; then
  if [ "$(stat -c %u "$DATA")" != "1000" ]; then
    echo "[railway] giving $DATA to uid 1000"
    chown -R 1000:1000 "$DATA"
  fi
  exec setpriv --reuid=1000 --regid=1000 --init-groups "$@"
fi
exec "$@"
