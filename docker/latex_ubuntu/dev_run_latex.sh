#!/bin/bash

cd ..
docker-compose -f docker-compose.yml run latex_ubuntu_base
cd util