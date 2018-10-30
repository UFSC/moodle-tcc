#!/bin/bash

docker stop docker_assets_stg_1; docker rm docker_assets_stg_1

docker run -it -v docker_assets_stg:/home/app/repo/shared/assets \
--name docker_assets_stg_1 ubuntu:16.04 /bin/bash -c \
'cd /home/app/repo/shared/uploads; exec "${SHELL:-bash}"'

docker stop docker_assets_stg_1; docker rm docker_assets_stg_1
