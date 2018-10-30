#!/bin/bash

cd ..
#export DOCKERGID=$(cut -d: -f3 < <(getent group docker))
export DB_HOST_IP=$(ip route get 8.8.8.8 | awk '{print $NF; exit}')
docker-compose -f docker-compose.staging.yml up web_stg
cd util
