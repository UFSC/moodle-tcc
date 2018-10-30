#!/bin/bash

#sudo docker exec -it docker_web_1 /bin/bash -l
docker exec -it docker_web_1 bundle exec rake test:all RAILS_ENV=test
