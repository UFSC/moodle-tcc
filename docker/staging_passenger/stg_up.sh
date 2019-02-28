#!/bin/bash

cd ..
sudo docker-compose -f docker-compose.staging_passenger.yml up web_stg_passenger
cd staging_passenger
