#!/bin/bash

#### Install production
# RAILS_ENV=production bundle install --without test development --with production

#### Install development
# RAILS_ENV=development bundle install --without production --with test development

RAILS_ENV=production bundle exec rake assets:clobber
RAILS_ENV=production bundle exec rake tmp:clear
RAILS_ENV=production bundle exec rake assets:precompile
touch tmp/restart.txt