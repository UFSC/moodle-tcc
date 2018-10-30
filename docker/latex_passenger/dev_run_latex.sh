#!/bin/bash

cd ..
docker-compose -f docker-compose.yml run latex_passenger_base
cd util

#docker run --rm -t -i phusion/passenger-full bash -l