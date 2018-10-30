#!/bin/bash

cd ..
#docker-compose -f docker-compose.yml run --user "$(id -u)" web
docker-compose -f docker-compose.staging.yml run web_stg
cd util