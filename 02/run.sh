#!/bin/bash

PASS=password

docker network create -d bridge pg_net

docker run --name pg_main \
--network pg_net \
-v "$PWD/pg_main.conf":/etc/postgres/postgres.sql \
-v "$PWD/pg_data_main":/var/lib/postgresql/data \
-v "$PWD/pg_data_standby":/backup \
-e POSTGRES_PASSWORD=$PASS -d postgres

while [ ! -f $PWD/pg_data_main/pg_hba.conf ]; do sleep 1; done
echo "host replication all 0.0.0.0/0 trust" >> $PWD/pg_data_main/pg_hba.conf
docker restart pg_main

docker exec -it pg_main pg_basebackup -h pg_main -D /backup -P -R -U postgres --wal-method=stream
while [ $? -ne 0 ]; do
	docker exec -it pg_main pg_basebackup -h pg_main -D /backup -P -R -U postgres --wal-method=stream
done;

docker exec -it pg_main su postgres -c "pg_ctl reload"


docker run --name pg_standby \
--network pg_net \
-v "$PWD/pg_standby.conf":/etc/postgres/postgres.sql \
-v "$PWD/pg_data_standby":/var/lib/postgresql/data \
-e POSTGRES_PASSWORD=$PASS postgres

#docker run -i --link pg_main:pg postgres psql postgresql://postgres:$PASS@pg/postgres <<EOF
#	create table test(value BIGINT);
#	insert into test select generate_series(0,100);
#EOF
