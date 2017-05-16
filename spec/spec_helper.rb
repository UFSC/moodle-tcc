# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

# Simple Coverage
if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start 'rails'
end

require 'rake' # Workaround for Fabrication gem bug
require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'vcr'
require 'capybara/rspec'
require 'rack_session_access/capybara'
require 'database_cleaner'
require 'shoulda/matchers'

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {timeout: 10})
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock, :faraday
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = false
  c.default_cassette_options = {:record => :new_episodes, :match_requests_on => [:query, :method]}

  # VCR vai ignorar request para 127.0.0.1, para que o #set_rack_session funcione
  c.ignore_hosts '127.0.0.1'
end

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # AttributeNormalizer
  config.include AttributeNormalizer::RSpecMatcher, :type => :model

  # Capybara Domain Specific language
  config.include Capybara::DSL

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.infer_spec_type_from_file_location!

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # Json specs helpers
  config.include JsonSpec::Helpers

  # Database cleaner
  # É essencial usar truncation para testes que usem javascript,
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Desligar as transações via RSpec, já que estamos usando elas via DatabaseCleaner
  config.use_transactional_fixtures = false
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

ActiveRecord::Migration.maintain_test_schema!