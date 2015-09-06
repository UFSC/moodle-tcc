module Configuration
  def self.load!
    filename = File.join(Rails.root, 'config', 'sidekiq.yml')

    unless File.file?(filename)
      $stderr.puts 'Você precisa configurar corretamente os dados do sidekiq. Verifique o arquivo sidekiq.yml.example'
      exit 1
    end

    begin
      sidekiq_config = YAML::load_file(filename)[Rails.env]
    rescue ArgumentError
      $stderr.puts "Seu arquivo de configuração do sidekiq, localizado em #{filename} não é um arquivo YAML válido."
      exit 1
    end

    return if sidekiq_config.nil? # Não existe configurações definidas para este environment, então não vamos continuar

    Sidekiq::Logging.logger.level = sidekiq_config[:log_level] if sidekiq_config[:log_level]
  end
end

Configuration.load!

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0', namespace: 'unasus-tcc-production' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0', namespace: 'unasus-tcc-production' }
end
