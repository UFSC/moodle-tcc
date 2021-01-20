#!/bin/bash

/bin/bash -l -c "RAILS_ENV=production bundle exec sidekiqctl stop tmp/pids/sidekiq-0.pid 10"

/bin/bash -l -c "RAILS_ENV=production bundle exec sidekiq --index 0 --pidfile tmp/pids/sidekiq-0.pid --environment production --logfile log/sidekiq.log --config config/sidekiq.yml" &
