#!/bin/bash

sudo docker stop docker_assets_cache_stg_1; sudo docker rm docker_assets_cache_stg_1

sudo docker run -it --rm -v docker_assets_cache_stg:/home/app/repo/tmp/cahce/assets \
--name docker_assets_cache_stg_1 ubuntu:16.04 /bin/bash  -c \
'cd /home/app/repo/tmp/cache/assets; exec "${SHELL:-bash}"'
