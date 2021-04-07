#!/bin/bash

docker stop pg_main pg_standby pg_static 2>/dev/null
docker rm pg_main pg_standby pg_static 2>/dev/null
docker network rm pg_net 2>/dev/null
rm -rf pg_data_main/*
rm -rf pg_data_standby/*
