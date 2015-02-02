Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0', namespace: 'unasus-tcc-production' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0', namespace: 'unasus-tcc-production' }
end