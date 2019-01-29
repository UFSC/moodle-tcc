#!/bin/bash

cd ..
#docker-compose -f docker-compose.yml run --user "$(id -u)" web
sudo docker-compose -f docker-compose.staging_passenger.yml run web_stg_passenger
cd staging_passenger