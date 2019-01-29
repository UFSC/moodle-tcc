#!/bin/bash

sudo docker stop docker_ssl_stg_1; sudo docker rm docker_ssl_ssl_1

sudo docker run -it -v docker_ssl_stg:/etc/ssl/certs_app \
--name docker_ssl_stg_1 ubuntu:16.04 /bin/bash -c \
'cd /etc/ssl/certs_app; exec "${SHELL:-bash}"'
