#!/bin/bash

cd ..
#export DOCKERGID=$(cut -d: -f3 < <(getent group docker))
docker-compose -f docker-compose.yml build latex_ubuntu_base
cd util
