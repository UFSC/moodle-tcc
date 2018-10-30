#!/bin/bash

cd ..
docker-compose -f docker-compose.yml up -d mysql
cd util