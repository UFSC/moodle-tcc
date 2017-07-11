#!/bin/bash

RAILS_ENV=production bundle exec rake assets:clobber
RAILS_ENV=production bundle exec rake tmp:clear
RAILS_ENV=production bundle exec rake assets:precompile
sudo service nginx restart