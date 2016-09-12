require 'sidekiq/web'

module Configuration
  def self.load!
    filename = File.join(Rails.root, 'config', 'sidekiq.yml')

    if File.file?(filename)

    begin
      sidekiq_config = YAML::load_file(filename)[Rails.env]
    rescue ArgumentError

    end

    return if sidekiq_config.nil? # Não existe configurações definidas para este environment, então não vamos continuar

    Sidekiq::Logging.logger.level = sidekiq_config[:log_level] if sidekiq_config[:log_level]
    end
  end
end

Configuration.load!

# https://github.com/mperham/sidekiq/issues/2730
# Rails + Sidekiq::Web + wildcard domain session = confliciting cookies
Sidekiq::Web.set :sessions, domain: 'all'

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{Settings.redis_host}:#{Settings.redis_port}/0", namespace: 'tcc' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{Settings.redis_host}:#{Settings.redis_port}/0", namespace: 'tcc' }
end
