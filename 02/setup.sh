#!/bin/bash

PASS=password

echo "Creating docker network"
docker network create -d bridge pg_net

# Primary

echo "Starting main db server"
docker run --name pg_main \
--network pg_net \
-v "$PWD/pg_data_main":/var/lib/postgresql/data \
-v "$PWD/pg_data_standby":/backup \
-e POSTGRES_PASSWORD=$PASS -d postgres

echo "Tuning db server configuration"
while [ ! -f $PWD/pg_data_main/pg_hba.conf ]; do sleep 1; done
	echo "host replication all 0.0.0.0/0 trust" >> $PWD/pg_data_main/pg_hba.conf
cp $PWD/pg_main_async.conf $PWD/pg_data_main/postgresql.conf
docker restart pg_main

echo "Cloning data for standby server"
docker exec -it pg_main pg_basebackup -h pg_main -D /backup -P -R -U postgres --wal-method=stream 2>&1>/dev/null
while [ $? -ne 0 ]; do
	docker exec -it pg_main pg_basebackup -h pg_main -D /backup -P -R -U postgres --wal-method=stream 2>&1>/dev/null
done;

docker exec -it pg_main su postgres -c "pg_ctl reload"

# Standby

cp $PWD/pg_standby_async.conf $PWD/pg_data_standby/postgresql.conf

echo "Starting standby server"
docker run --name pg_standby \
--network pg_net \
-v "$PWD/pg_data_standby":/var/lib/postgresql/data \
-e POSTGRES_PASSWORD=$PASS -d postgres


echo "Creating test table"
docker exec -i pg_main psql postgresql://postgres:$PASS@localhost/postgres 2>&1>/dev/null <<EOF
	CREATE TABLE test(value BIGINT);
EOF

echo "Done"


