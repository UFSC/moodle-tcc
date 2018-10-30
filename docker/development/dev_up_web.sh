#!/bin/bash

cd ..
export DB_HOST_IP=$(ip route get 8.8.8.8 | awk '{print $NF; exit}')
docker-compose -f docker-compose.yml up web
cd util