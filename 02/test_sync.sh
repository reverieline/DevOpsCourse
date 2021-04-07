#!/bin/bash

PASS=password
CNT=1000000
if [ ! -z "$1" ]; then CNT=$1 ; fi

cp $PWD/pg_main_sync.conf $PWD/pg_data_main/postgresql.conf
cp $PWD/pg_standby_sync.conf $PWD/pg_data_standby/postgresql.conf
docker exec -it pg_main su postgres -c "pg_ctl reload" 2>&1>/dev/null
docker exec -it pg_standby su postgres -c "pg_ctl reload" 2>&1>/dev/null

docker exec -i pg_main psql -t postgresql://postgres:$PASS@localhost/postgres <<EOF
	SELECT sync_state FROM pg_stat_replication;
EOF

docker exec -i pg_main psql -t postgresql://postgres:$PASS@localhost/postgres <<EOF
	EXPLAIN ANALYSE INSERT INTO test(value) SELECT generate_series(0,$CNT);
EOF


