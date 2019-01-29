#!/bin/bash

/bin/bash -l -c "export RAILS_ENV=production"

/bin/bash -l -c "source /usr/local/rvm/scripts/rvm"

./docker/setup_dev.sh

if [ "${RAILS_ENV}" == "development" ]; then \
  /bin/bash -l -c "rm -f tmp/pids/sidekiq-0.pid && RAILS_ENV=${RAILS_ENV} \
bundle exec sidekiq -d \
--environment ${RAILS_ENV} \
--pidfile tmp/pids/sidekiq-0.pid \
-L log/sidekiq.log \
-C config/sidekiq.yml";
elif [ "${RAILS_ENV}" == "production" ]; then \
  /bin/bash -l -c "rm -f tmp/pids/sidekiq-0.pid";
  su app -c "source /usr/local/rvm/scripts/rvm && RAILS_ENV=${RAILS_ENV} \
bundle exec sidekiq -d \
--environment ${RAILS_ENV} \
--pidfile tmp/pids/sidekiq-0.pid \
-L log/sidekiq.log \
-C config/sidekiq.yml";
fi

#RAILS_ENV=${RAILS_ENV} bundle exec sidekiq -d --environment ${RAILS_ENV} --pidfile tmp/pids/sidekiq-0.pid -L log/sidekiq.log -C config/sidekiq.yml

#
###/bin/bash -l -c "RAILS_ENV=${RAILS_ENV} bundle exec whenever --user app" # set a user as which to install the crontab
###/bin/bash -l -c "RAILS_ENV=${RAILS_ENV} bundle exec whenever --load-file config/my_schedule.rb" # set the schedule file
###/bin/bash -l -c "RAILS_ENV=${RAILS_ENV} bundle exec whenever --crontab-command 'sudo crontab'" # override the crontab command
#/bin/bash -l -c "RAILS_ENV=${RAILS_ENV} bundle exec whenever --update-crontab"
#

/bin/bash -l -c "rm -f home/app/repo/tmp/pids/server.pid && /sbin/my_init"

#/bin/bash -l -c "/sbin/my_init"

