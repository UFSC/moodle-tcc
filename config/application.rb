require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
#Bundler.require(*Rails.groups)
Bundler.require(:default, Rails.env)

# IMS-LTI
OAUTH_10_SUPPORT = true
require 'oauth/request_proxy/action_dispatch_request'

module SistemaTcc
  class Application < Rails::Application
    #config.active_record.raise_in_transactional_callbacks = true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/lib/modules)
    config.autoload_paths += %W(#{config.root}/app/models/ckeditor)
    config.autoload_paths += %W(#{config.root}/app/models/concerns)
    config.autoload_paths += %W(#{config.root}/app/controllers/concerns)
    config.autoload_paths += %W(#{config.root}/app/validations)
    # config.autoload_paths += %W(#{config.root}/lib/workers)
    # config.eager_load_paths += ["#{config.root}/lib/workers"]

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.available_locales = [:en, :"pt-BR"]
    config.i18n.enforce_available_locales = false
    # config.i18n.enforce_available_locales = true
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :'pt-BR'

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Configura os paths para os partials dos workwers do sidekiq para a impressão em bloco
    config.paths['app/views'].unshift("#{Rails.root}/app/views/tccs")

    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :fabrication
    end

    # config/application.rb
    # => Markdown (for CKEditor)
    # => https://github.com/rails/sprockets/blob/99444c0a280cc93e33ddf7acfe961522dec3dcf5/guides/extending_sprockets.md#register-mime-types
    config.before_initialize do |app|
      Sprockets.register_mime_type 'text/markdown', extensions: ['.md']
    end

    config.after_initialize do
      Rails.application.config.version=Version.read_version_hash(7)
    end
  end
end

ActiveRecord::SessionStore::Session.serializer = :marshal
