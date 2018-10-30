#!/bin/bash

docker stop docker_uploads_dev_1; docker rm docker_uploads_dev_1

docker run -it -v docker_upload_dev:/home/app/repo/shared/uploads \
--name docker_uploads_dev_1 ubuntu:16.04 /bin/bash -c \
'cd /home/app/repo/shared/uploads; exec "${SHELL:-bash}"'

docker stop docker_uploads_dev_1; docker rm docker_uploads_dev_1
