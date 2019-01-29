#!/bin/bash

./docker/change_owner_user.sh

##/bin/bash -l -c 'echo \"${APP_NAME}\" > .ruby-gemset'

if [ "${RAILS_ENV}" == "development" ]; then \
  /bin/bash -l -c "git submodule update";
  /bin/bash -l -c "git submodule --init --recursive";
  /bin/bash -l -c "RAILS_ENV=${RAILS_ENV} gem install bundler --version 1.17.1 --no-rdoc --no-ri";
  /bin/bash -l -c "RAILS_ENV=${RAILS_ENV} bundle install --without production --with test development";
elif [ "${RAILS_ENV}" == "production" ]; then \
  su app -c "source /usr/local/rvm/scripts/rvm && RAILS_ENV=${RAILS_ENV} gem install bundler --version 1.17.1 --no-rdoc --no-ri";
  su app -c "source /usr/local/rvm/scripts/rvm && rvm --default use ruby-2.2.10@sistema-tcc";
  su app -c "source /usr/local/rvm/scripts/rvm && RAILS_ENV=${RAILS_ENV} bundle install --with production --without test development";
  echo "Precompiling assets...";
  su app -c "source /usr/local/rvm/scripts/rvm && RAILS_ENV=${RAILS_ENV} bundle exec rake assets:precompile";
  echo "Precompiled assets.";
else #"${ENV}" == test
  /bin/bash -l -c "RAILS_ENV=${RAILS_ENV} bundle install --with production test --without development";
fi

/bin/sh -c "./docker/start_db.sh"
##vim
