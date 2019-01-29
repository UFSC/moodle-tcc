#!/bin/bash

sudo docker stop docker_assets_stg_1; sudo docker rm docker_assets_stg_1

sudo docker run -it --rm -v docker_assets_stg:/home/app/repo/shared/assets \
--name docker_assets_stg_1 ubuntu:16.04 /bin/bash  -c \
'cd /home/app/repo/shared/assets; exec "${SHELL:-bash}"'
