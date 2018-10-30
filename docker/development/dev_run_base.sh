#!/bin/bash

cd ..
docker-compose -f docker-compose.yml run ruby_base
cd util