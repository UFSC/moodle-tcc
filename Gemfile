source 'https://rubygems.org'

gem 'rails', '~> 4.2'
#gem 'rails', '~> 4.2.7'

gem 'mysql2', '~> 0.3.18'
gem 'protected_attributes'
gem 'activerecord-session_store', github: 'rails/activerecord-session_store'
gem 'eventmachine'#, '~>1.0.7'
gem 'passenger', '~> 5.1.0'
gem 'execjs'
gem 'therubyracer'

# Rails 4.2
gem 'responders', '~> 2.0'

# Teste de geração de pdf no worker
#gem 'wicked_pdf'

# Asset Pipeline
gem 'sass-rails', '~> 5.0.6'
gem 'coffee-rails', '~> 4.2.1'
gem 'uglifier'

# Assets
gem 'autoprefixer-rails'
gem 'bootstrap-sass'#, ">= 3.4.1" #, '~> 3.3.1'
# gem 'jquery-rails', '~> 4.2.1'
gem 'jquery-rails', '~> 3.1.4'
gem 'jquery-ui-rails', '< 5.0.0'#, '~> 4.1.1'
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
gem 'redis'#, '3.1.0'
gem 'redis-namespace'
gem 'metalink', :github => 'robertosilvino/metalink-ruby', :branch => 'add-binary-structure'

# sidekiq - processamento paralelo
# gem 'sidekiq', '~> 4.2.2'
gem 'sidekiq', '~> 4.1.4'
gem 'sidekiq-superworker'
# gem 'sidekiq_monitor'
# gem 'rack-protection'

# sidekiq monitor
# gem 'sinatra', require: false
# gem 'slim'

# Latex tcc -> pdf
gem 'rails-latex',:github => 'UFSC/moodle-tcc-rails-latex'
gem 'htmlentities', '~> 4.3.3'
gem 'faraday'#, '0.8.9'
gem 'typhoeus'
gem 'addressable', require: 'addressable/uri'

# Moodle Web Service
gem 'rest-client'
gem 'nokogiri', ">= 1.8.5"

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
gem 'formtastic'#, '3.0'
gem 'formtastic-bootstrap', github: 'mjbellantoni/formtastic-bootstrap'
gem 'rails3-jquery-autocomplete' # Autocomplete no search
# gem 'ckeditor', github: 'galetahub/ckeditor', :tag => 'v4.2.0' # inteface antiga
gem 'ckeditor', github: 'galetahub/ckeditor', :tag => 'v4.2.1' # inteface nova
# gem 'ckeditor', github: 'galetahub/ckeditor', :branch => 'master'
    # :commit_id => 'd0194ccd3f181be603f419c233ca....'
gem 'rabl'
gem 'active_hash', github: 'zilkey/active_hash'

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
gem 'draper'#, '~> 1.3'

# Errbit (monitoração de falhas)
gem 'airbrake', '~> 4.3.8'

# OpenStack Swift
gem 'fog'

# group :production do
  gem'non-stupid-digest-assets', '~> 1.0', '>= 1.0.9'
  gem 'newrelic_rpm'
  gem 'redis-rails', '~>5.0'
# end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'thin'
  # gem 'ruby-graphviz', '~> 1.2.2', :require => 'graphviz' # usado pela state_machine
  gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq'

  # Auxilia depuração da aplicação: http://railscasts.com/episodes/402-better-errors-railspanel
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'quiet_assets'
  gem 'brakeman', :require => false

  # previne N+1 queries
  gem 'bullet'
end

group :test do
  gem 'fabrication'
  gem 'shoulda-matchers', :require => false
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
  gem 'rspec-wait'
end

group :development, :test do
  gem 'rspec-rails'# , '~> 3.0'
  gem 'metric_fu', :require => false
  gem 'pry-rails', '~>0.3.2'
  gem 'simplecov', require: false

  # Application pre-loader:
  # gem 'spring'
  # gem 'spring-watcher-listen'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Deploy with Capistrano
group :deploy, :development do
  gem 'capistrano', '~> 3.4'
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'capistrano-upload-config'
  gem 'capistrano-db-tasks', :require => false
  gem 'capistrano-newrelic'
  gem 'capistrano-git-submodule-strategy'#, '0.1.3'
  gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq'
end

gem 'rack-protection',  '~> 1.5.5'
gem 'ffi', '~> 1.9.24'
gem "rack", ">= 1.6.11"