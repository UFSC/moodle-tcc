#!/bin/bash

sudo docker stop docker_config_stg_1; sudo docker rm docker_config_stg_1

sudo docker run -it --rm -v docker_config_stg:/home/app/repo/config \
--name docker_config_stg_1 ubuntu:16.04 /bin/bash -c \
'cd /home/app/repo/config; exec "${SHELL:-bash}"'
