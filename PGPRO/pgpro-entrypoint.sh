#!/usr/bin/env bash

set -e

if [ ! -s "$PGDATA/PG_VERSION" ]; then
    pg_ctl initdb -D $PGDATA -o "--locale=$LANG"
    printf "host    all             all             all                     md5\n" >> $PGDATA/pg_hba.conf
    printf "password_encryption = md5\n" >> /_data/pg_data/postgresql.conf
fi

exec "$@"
