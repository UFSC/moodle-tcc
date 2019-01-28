#!/bin/bash

export RAILS_ENV=production

/bin/bash -l -c "source /usr/local/rvm/scripts/rvm"

./docker/setup_dev.sh

###git submodule update
###git submodule --init --recursive

/bin/bash -l -c "rm -f tmp/pids/sidekiq-0.pid && RAILS_ENV=${RAILS_ENV} \
bundle exec sidekiq -d \
--environment ${RAILS_ENV} \
--pidfile tmp/pids/sidekiq-0.pid \
-L log/sidekiq.log \
-C config/sidekiq.yml"

###bundle exec sidekiq --index 0  \
### --pidfile tmp/pids/sidekiq-0.pid
### --environment production
### --logfile /home/deploy/homologacao-github-tcc.moodle.ufsc.br/shared/log/sidekiq.log
### --config /home/deploy/homologacao-github-tcc.moodle.ufsc.br/shared/config/sidekiq.yml
### --daemon
#
###/bin/bash -l -c "RAILS_ENV=${RAILS_ENV} bundle exec whenever --user app" # set a user as which to install the crontab
###/bin/bash -l -c "RAILS_ENV=${RAILS_ENV} bundle exec whenever --load-file config/my_schedule.rb" # set the schedule file
###/bin/bash -l -c "RAILS_ENV=${RAILS_ENV} bundle exec whenever --crontab-command 'sudo crontab'" # override the crontab command
#/bin/bash -l -c "RAILS_ENV=${RAILS_ENV} bundle exec whenever --update-crontab"
#
###errbit (ON DEPLOY)
###airbrake:deploy
###Example:
###bundle exec rake airbrake:deploy TO=production REVISION=af8cfc4f0e426ea282e7dd5771a8c066c824d99f REPO=https://github.com/UFSC/moodle-tcc.git USER=rsc
###bundle exec rake airbrake:deploy TO=${RAILS_ENV} REVISION=af8cfc4f0e426ea282e7dd5771a8c066c824d99f REPO=https://github.com/UFSC/moodle-tcc.git USER=rsc

#/bin/bash -l -c "rm -f tmp/pids/server.pid && RAILS_ENV=$RAILS_ENV bundle exec rails s -p $RACK_PORT -b 0.0.0.0"

###vim
###irb
#vim

/sbin/my_init