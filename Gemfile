source 'https://rubygems.org'

gem 'rails', '~>3.2.12'

gem 'mysql2'

gem 'oauth'

# Unicode Utils
gem 'unicode_utils'

# Latex tcc -> pdf
gem 'rails-latex', git: 'git@gitlab.setic.ufsc.br:tcc-unasus/rails-latex.git'
gem 'htmlentities'
gem 'faraday'
gem 'typhoeus'

# Moodle Web Service
gem 'rest-client'
gem 'nokogiri'

# State machine
gem 'aasm'

# Inherited Resources
gem 'inherited_resources'

# Twitter Bootstrap
gem 'bootstrap-datepicker-rails'
gem 'twitter-bootstrap-rails-confirm'

# Pagination
gem 'will_paginate'

# Tabs
gem 'tabs_on_rails'

# LTI for moodle integration
gem 'ims-lti'

# Formtastic (Formulários)
gem 'formtastic', '~> 2.2'
gem 'formtastic-bootstrap'#, :github => 'mjbellantoni/formtastic-bootstrap'
# Pegando do github, por causa desse PR: https://github.com/mjbellantoni/formtastic-bootstrap/pull/46

# ckeditor
gem 'ckeditor'

# Carrierwave (uploads)
gem 'carrierwave'
gem 'mini_magick'

# RABL
gem 'rabl'

# Rake e console
gem 'progress'
gem 'terminal-table'
gem 'whenever', require: false

# Model Utils
gem 'enumerize'
gem 'attribute_normalizer'

# Model versioning
gem 'paper_trail'

# Errbit (monitoração de falhas)
gem 'airbrake'

group :production do
  gem 'newrelic_rpm'
end

group :development do
  gem 'thin'
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
  gem 'json_spec'

end

group :development, :test do
  gem 'rspec-rails'
  gem 'metric_fu', :require => false
  gem 'pry-rails', '~>0.3.2'
  gem 'simplecov', require: false
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'bootstrap-sass', '~> 2.3.2.1'

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
