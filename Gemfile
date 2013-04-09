source 'https://rubygems.org'

gem 'rails', '3.2.12'

gem 'mysql2'

gem 'oauth'

# Compass + Twitter Bootstrap
gem 'compass_twitter_bootstrap'

# Javascript
gem 'jquery-rails'

# LTI for moodle integration
gem 'ims-lti'

# Formtastic (Formulários)
gem 'formtastic', '~> 2.2'
gem 'formtastic-bootstrap'#, :github => 'mjbellantoni/formtastic-bootstrap'
# Pegando do github, por causa desse PR: https://github.com/mjbellantoni/formtastic-bootstrap/pull/46

# ckeditor
#gem 'ckeditor'

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

group :development, :test do
  gem 'rspec-rails'
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
end

gem 'jquery-rails'

# Deploy with Capistrano
group :deploy do
  gem 'capistrano'
  gem 'capistrano-db-tasks', :require => false
end
