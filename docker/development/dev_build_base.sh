#!/bin/bash

cd ..
docker-compose -f docker-compose.yml build ruby_base
cd util
