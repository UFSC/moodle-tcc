#!/bin/bash

cd ..
sudo docker-compose -f docker-compose.staging_passenger.yml build web_stg_passenger
cd staging_passenger
