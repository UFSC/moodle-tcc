#!/bin/bash

cd ..
docker-compose -f docker-compose.yml -f docker-compose.staging.yml down
cd util
