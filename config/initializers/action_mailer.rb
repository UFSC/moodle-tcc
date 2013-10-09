# encoding: utf-8
module Configuration
  def self.load!
    filename = File.join(Rails.root, 'config', 'email.yml')

    unless File.file?(filename)
      $stderr.puts 'Você precisa configurar corretamente os dados de e-mail. Verifique o arquivo email.yml.example'
      exit 1
    end

    begin
      email_config = YAML::load_file(filename)[Rails.env]
    rescue ArgumentError
      $stderr.puts "Seu arquivo de configuração de e-mail, localizado em #{filename} não é um arquivo YAML válido."
      exit 1
    end

    ActionMailer::Base.perform_deliveries = true if email_config['delivery_method']

    email_config.each do |k, v|
      v.symbolize_keys! if v.respond_to?(:symbolize_keys!)
      ActionMailer::Base.send("#{k}=", v)
    end

  end
end

Configuration.load!