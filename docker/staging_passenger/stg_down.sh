#!/bin/bash

cd ..
sudo docker update --restart=no docker_web_stg_passenger_1
sudo docker-compose -f docker-compose.yml -f docker-compose.staging.yml down --remove-orphans
cd staging_passenger
