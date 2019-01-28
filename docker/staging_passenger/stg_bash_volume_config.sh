#!/bin/bash

docker stop docker_config_stg_1; docker rm docker_config_stg_1

docker run -it -v docker_config_stg:/home/app/repo/config \
--name docker_config_stg_1 ubuntu:16.04 /bin/bash -c \
'cd /home/app/repo/config; exec "${SHELL:-bash}"'

docker stop docker_config_stg_1; docker rm docker_config_stg_1
