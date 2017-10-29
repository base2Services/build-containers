#!/bin/bash
# wait-for-pg.sh

set -e

export PATH="$PG_BIN:$PATH"

pg_ctl init
pg_ctl start -l logfile -D /usr/local/pgsql/data

until psql -c '\l' postgres; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"

exec $@
