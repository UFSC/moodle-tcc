#!/bin/bash

cd ..
sudo docker-compose -f docker-compose.yml -f docker-compose.staging.yml down --remove-orphans
cd staging_passenger
