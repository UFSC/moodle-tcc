# encoding: utf-8

module Errbit
  def self.load!
    filename = File.join(Rails.root, 'config', 'errbit.yml')

    unless File.file?(filename)
      # Caso o arquivo não exista, não vamos configurar nada.
      return
    end

    begin
      errbit_config = YAML::load_file(filename)[Rails.env]
    rescue ArgumentError
      $stderr.puts "Seu arquivo de configuração do errbit, localizado em #{filename} não é um arquivo YAML válido."
      exit 1
    end

    return if errbit_config.nil? # Não existe configurações definidas para este environment, então não vamos continuar

    Airbrake.configure do |config|
      errbit_config.each do |k, v|
        v.symbolize_keys! if v.respond_to?(:symbolize_keys!)
        config.send("#{k}=", v)
      end

      config.secure = config.port == 443
    end

  end
end

Errbit.load!