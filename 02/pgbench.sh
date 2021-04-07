#!/bin/bash
PASS=password

docker run --rm --network=pg_net \
 xridge/pgbench -i -s 5 postgresql://postgres:$PASS@pg_main/postgres

