#!/bin/bash

sudo docker stop docker_upload_stg_1; sudo docker rm docker_upload_stg_1

sudo docker run -it -v docker_upload_stg:/home/app/repo/shared/uploads \
--name docker_upload_stg_1 ubuntu:16.04 /bin/bash  -c \
'cd /home/app/repo/shared/uploads; exec "${SHELL:-bash}"'
