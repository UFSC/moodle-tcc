#!/bin/bash

cd ..
docker-compose -f docker-compose.staging.yml build web_stg
cd util
