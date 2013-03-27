source 'https://rubygems.org'

gem 'rails', '3.2.12'

gem 'mysql2'

# Compass + Twitter Bootstrap
gem 'compass_twitter_bootstrap'
gem 'bootstrap-datepicker-rails'

# Javascript
gem 'jquery-rails'

# Formtastic (Formulários)
gem 'formtastic', '~> 2.2'
gem 'formtastic-bootstrap', :github => 'mjbellantoni/formtastic-bootstrap'
# Pegando do github, por causa desse PR: https://github.com/mjbellantoni/formtastic-bootstrap/pull/46

group :production do
  gem 'newrelic_rpm'
end

group :development do
  gem 'thin'
  gem 'better_errors'
end

group :test do
  gem 'fabrication'
  gem 'shoulda-matchers'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# Deploy with Capistrano
group :deploy do
  gem 'capistrano'
  gem 'capistrano-db-tasks', :require => false
end
