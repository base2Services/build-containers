#!/bin/sh
if [ -f /tmp/clair.lock ]; then
  echo "clair is already running"
  exit 0;
fi
/usr/local/bin/docker-entrypoint.sh postgres &

while true; do
  pg_isready -h localhost
  if [ $? -eq 0 ]; then
    break
  fi
  echo "Waiting for Postgres to be ready..."
  sleep 2
done

echo "Starting Clair..."
/bin/clair > /var/log/clair &
touch /tmp/clair.lock
