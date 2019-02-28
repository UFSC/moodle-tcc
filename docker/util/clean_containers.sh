#!/bin/bash

sudo docker rm $(sudo docker ps -qa --no-trunc --filter "status=exited")

