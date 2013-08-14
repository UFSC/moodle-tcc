source 'https://rubygems.org'

gem 'rails', '~>3.2.12'

gem 'mysql2'

gem 'oauth'

# Moodle Web Service
gem 'rest-client'

# XML Parser
gem 'nokogiri'

# State machine
gem 'aasm'

# Tabs
gem 'tabs_on_rails'

# Inherited Resources
gem 'inherited_resources'

# Model versioning
gem 'paper_trail'

# Compass + Twitter Bootstrap
gem 'compass_twitter_bootstrap'
gem 'bootstrap-datepicker-rails'

# Confirm dialog with twitter boostrap layout
gem 'twitter-bootstrap-rails-confirm'

# Javascript
gem 'jquery-rails'

# LTI for moodle integration
gem 'ims-lti'

# Formtastic (Formulários)
gem 'formtastic', '~> 2.2'
gem 'formtastic-bootstrap'#, :github => 'mjbellantoni/formtastic-bootstrap'
# Pegando do github, por causa desse PR: https://github.com/mjbellantoni/formtastic-bootstrap/pull/46

# ckeditor
gem 'ckeditor'

# Pagination
gem 'will_paginate'

# RABL
gem 'rabl'

# Rake e console
gem 'progress'
gem 'terminal-table'

# Enumerize
gem 'enumerize'

group :production do
  gem 'newrelic_rpm'
end

group :development do
  gem 'thin'
  gem 'simplecov', require: false
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'quiet_assets'
end

group :test do
  gem 'fabrication'
  gem 'shoulda-matchers'
  gem 'faker'

  # Request tests
  gem 'capybara'
  gem 'rack_session_access'
  gem 'capybara-webkit'

end

group :development, :test do
  gem 'rspec-rails'
  gem 'metric_fu', :require => false
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'compass-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'turbo-sprockets-rails3'
end

gem 'jquery-rails'

# Deploy with Capistrano
group :deploy do
  gem 'capistrano', '~> 2.15.5'
  gem 'capistrano-db-tasks', :require => false
end
