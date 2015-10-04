source 'https://rubygems.org'

gem 'rails', '~> 4.1.9'
gem 'mysql2'
gem 'protected_attributes', '~>1.0.1'
gem 'activerecord-session_store', github: 'rails/activerecord-session_store'
gem 'eventmachine', '~>1.0.7'
gem 'passenger'
gem 'execjs'
gem 'therubyracer'

# Teste de geração de pdf no worker
#gem 'wicked_pdf'

# Asset Pipeline
gem 'sass-rails', '~> 4.0.5'
gem 'coffee-rails', '~> 4.1'
gem 'uglifier', '>= 1.3.0'

# Assets
gem 'autoprefixer-rails'
gem 'bootstrap-sass', '~> 3.3.1'
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 4.1.1'
gem 'bootstrap-datepicker-rails'
gem 'twitter-bootstrap-rails-confirm'
gem 'font-awesome-sass'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

# Pundit provides a set of helpers which guide you in leveraging regular Ruby classes
# and object oriented design patterns to build a simple, robust and scaleable
# authorization system.
gem 'pundit'

# Unicode Utils
gem 'unicode_utils'

# geração do tcc em bloco
gem 'redis', '3.1.0'
gem 'metalink', :github => 'robertosilvino/metalink-ruby', :branch => 'add-binary-structure'

# sidekiq - processamento paralelo
gem 'sidekiq'
gem 'sidekiq-superworker'
#gem 'sidekiq_monitor'

# sidekiq monitor
gem 'sinatra', require: false
gem 'slim'

# Latex tcc -> pdf
gem 'rails-latex', git: 'git@gitlab.setic.ufsc.br:tcc-unasus/rails-latex.git'
gem 'htmlentities', '~> 4.3.3'
gem 'faraday', '0.8.9'
gem 'typhoeus'
gem 'addressable', require: 'addressable/uri'

# Moodle Web Service
gem 'rest-client'
gem 'nokogiri'

# Inherited Resources
gem 'inherited_resources'

# Pagination
gem 'kaminari'

# Tabs
gem 'tabs_on_rails'

# LTI for moodle integration
gem 'ims-lti', git: 'https://github.com/instructure/ims-lti'
gem 'oauth-instructure'

# Formulários e views
gem 'formtastic', '3.0'
gem 'formtastic-bootstrap', github: 'mjbellantoni/formtastic-bootstrap'
gem 'rails3-jquery-autocomplete' # Autocomplete no search
gem 'ckeditor'
gem 'rabl'

# image on database
# gem 'paperclip', git: 'git://github.com/thoughtbot/paperclip.git'

# Carrierwave (uploads)
gem 'carrierwave', github: 'carrierwaveuploader/carrierwave'
gem 'mini_magick'

# Rake e console
gem 'progress'
gem 'terminal-table'
gem 'whenever', require: false

# Model Utils
gem 'enumerize'
gem 'attribute_normalizer'
gem 'settingslogic' # Configurações
gem 'scoped_search'
gem 'state_machine', github: 'seuros/state_machine'

# Decorator pattern
gem 'draper', '~> 1.3'

# Errbit (monitoração de falhas)
gem 'airbrake'

# OpenStack Swift
gem 'fog'

group :production do
  gem 'newrelic_rpm'
  gem 'redis-rails'
end

group :development do
  gem 'thin'
  # gem 'ruby-graphviz', '~> 1.2.2', :require => 'graphviz' # usado pela state_machine
  gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq'

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
  gem 'vcr'
  gem 'webmock'
  gem 'pdf-inspector', :require => "pdf/inspector"

  # Request tests
  gem 'capybara'
  gem 'capybara-puma'
  gem 'rack_session_access'
  gem 'poltergeist'
  gem 'json_spec'
  gem 'database_cleaner'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'metric_fu', :require => false
  gem 'pry-rails', '~>0.3.2'
  gem 'simplecov', require: false

  # Application pre-loader:
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Deploy with Capistrano
group :deploy do
  gem 'capistrano', '~> 3.4'
  gem 'capistrano-rails'
  gem 'capistrano-upload-config'
  gem 'capistrano-db-tasks', :require => false
  gem 'capistrano-newrelic'
  gem 'capistrano-git-submodule-strategy', '0.1.3'
  gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq'
end
