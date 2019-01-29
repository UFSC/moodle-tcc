#!/bin/bash

cd ..
sudo docker-compose -f docker-compose.staging_passenger.yml build web_stg_passenger_base
cd staging_passenger
