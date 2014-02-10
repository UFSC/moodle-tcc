source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '~>3.2.12'

gem 'mysql2'

# Unicode Utils
gem 'unicode_utils'

# Latex tcc -> pdf
gem 'rails-latex', git: 'git@gitlab.setic.ufsc.br:tcc-unasus/rails-latex.git'
gem 'htmlentities'
gem 'faraday', '0.8.9'
gem 'typhoeus'

# Moodle Web Service
gem 'rest-client'
gem 'nokogiri'

# Jquery UI
gem 'jquery-ui-rails'

# State machine
gem 'aasm'

# Inherited Resources
gem 'inherited_resources'

# Twitter Bootstrap
gem 'bootstrap-datepicker-rails'
gem 'twitter-bootstrap-rails-confirm'

# Pagination
gem 'kaminari'

# Tabs
gem 'tabs_on_rails'

# LTI for moodle integration
gem 'ims-lti'
gem 'oauth'

# Formulários e views
gem 'formtastic', '~> 2.2'
gem 'formtastic-bootstrap'
gem 'rails3-jquery-autocomplete' # Autocomplete no search
gem 'ckeditor'
gem 'rabl'

# Carrierwave (uploads)
gem 'carrierwave'
gem 'mini_magick'

# Rake e console
gem 'progress'
gem 'terminal-table'
gem 'whenever', require: false

# Model Utils
gem 'enumerize'
gem 'attribute_normalizer'
gem 'paper_trail', '2.7.2' # Versionamento
gem 'settingslogic' # Configurações
gem 'scoped_search'

# Errbit (monitoração de falhas)
gem 'airbrake'

group :production do
  gem 'newrelic_rpm'
end

group :development do
  gem 'thin'

  # Auxilia depuração da aplicação: http://railscasts.com/episodes/402-better-errors-railspanel
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'quiet_assets'

  # previne N+1 queries
  gem 'bullet'
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