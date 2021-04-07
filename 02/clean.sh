#!/bin/bash

docker stop pg_main pg_standby
docker rm pg_main pg_standby
rm -rf pg_data_main/*
rm -rf pg_data_standby/*
