#!/bin/bash

sudo docker stop docker_log_stg_1; sudo docker rm docker_log_stg_1

sudo docker run -it --rm -v docker_log_stg:/home/app/repo/shared/log \
--name docker_log_stg_1 ubuntu:16.04 /bin/bash -c \
'cd /home/app/repo/shared/log; exec "${SHELL:-bash}"'
