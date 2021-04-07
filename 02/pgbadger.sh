#!/bin/bash

docker run --rm \
-v "$PWD/pg_data_main/logs/pgbadger/":/data \
-v "$PWD/pg_data_main/logs/postgresql.log":/logfile.log \
uphold/pgbadger /logfile.log -o /data/postgresql.html

docker run -d --rm --name=pg_static \
-v "$PWD/pg_data_main/logs/pgbadger":/web \
    -p 8080:8080 \
    halverneus/static-file-server:latest 2>/dev/null

echo
echo "To view pgBadger report go to http://$HOSTNAME:8080/postgresql.html"
