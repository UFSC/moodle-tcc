source 'https://rubygems.org'

gem 'rails', '~> 4.0.8'
gem 'mysql2'
gem 'protected_attributes', '~>1.0.1'

# Asset Pipeline
gem 'sass-rails', '~> 4.0.2'
gem 'coffee-rails', '~> 4.0.0'
gem 'bootstrap-sass', '~> 2.3.2.1'
gem 'uglifier', '>= 1.3.0'

# Assets
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 4.1.1'
gem 'bootstrap-datepicker-rails'
gem 'twitter-bootstrap-rails-confirm'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

# Auxilia a migração para Rails 4
gem 'rails4_upgrade'

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

# State machine
gem 'aasm'

# Inherited Resources
gem 'inherited_resources'

# Pagination
gem 'kaminari'

# Tabs
gem 'tabs_on_rails'

# LTI for moodle integration
gem 'ims-lti'
gem 'oauth'

# Formulários e views
gem 'formtastic', '~> 2.3'
gem 'formtastic-bootstrap', '~> 2.1.3'
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
gem 'paper_trail', '~> 3.0.5' # Versionamento
gem 'settingslogic' # Configurações
gem 'scoped_search'

# Decorator pattern
gem 'draper', '~> 1.3'

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
  gem 'rspec-rails', '~> 3.0'
  gem 'metric_fu', :require => false
  gem 'pry-rails', '~>0.3.2'
  gem 'simplecov', require: false
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Deploy with Capistrano
group :deploy do
  gem 'capistrano', '~> 3.2'
  gem 'capistrano-rails'
  gem 'capistrano-upload-config'
  gem 'capistrano-db-tasks', :require => false
  gem 'capistrano-newrelic'
  gem 'capistrano-git-submodule-strategy', '0.1.3'
end
