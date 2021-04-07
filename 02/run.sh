#!/bin/bash

PASS=password

docker network create -d bridge pg_net

docker run --name pg_main \
--network pg_net \
-v "$PWD/pg_main.conf":/etc/postgres/postgres.sql \
-v "$PWD/pg_main_init.sh":/docker-entrypoint-initdb.d/init.sh \
-v "$PWD/pg_data_main":/var/lib/postgresql/data \
-v "$PWD/pg_data_standby":/base_backup \
-e POSTGRES_PASSWORD=$PASS -d postgres

docker exec -it pg_main /bin/bash -c "pg_basebackup -h localhost -U postgres -D /base_backup"
echo "host replication postgres 0.0.0.0/0 md5" >> $PWD/pg_data_main/pg_hba.conf
docker exec -it pg_main /bin/bash -c "pg_ctl reload"

docker run --name pg_standby \
--network pg_net \
-v "$PWD/pg_standby.conf":/etc/postgres/postgres.sql \
-v "$PWD/pg_standby_init.sh":/docker-entrypoint-initdb.d/init.sh \
-v "$PWD/pg_data_standby":/var/lib/postgresql/data \
-e POSTGRES_PASSWORD=$PASS postgres

#docker run -i --link pg_main:pg postgres psql postgresql://postgres:$PASS@pg/postgres <<EOF
#	create table test(value BIGINT);
#	insert into test select generate_series(0,100);
#EOF
