module MoodleAPI
  class Base

    def initialize
      @error = {}
    end

    # Executa uma chamada remota a um webservice do Moodle retornando XML
    # @param [String] remote_method_name
    # @param [Hash] params
    # @param [Proc] block
    def remote_call(remote_method_name, params={}, &block)
      Rails.logger.debug "[Moodle WS] Chamada remota: #{remote_method_name}, parametros: #{params}"

      default = {:wstoken => Settings.moodle_token, :wsfunction => remote_method_name}

      post_params = default
      post_params.merge!(params) unless params.empty?

      RestClient.post(Settings.moodle_rest_url, post_params) do |response|
        Rails.logger.debug "[WS Moodle] resposta: #{response.code} #{response.inspect}"

        if response.code != 200
          Rails.logger.error "Falha ao acessar o webservice do Moodle: HTTP_ERROR: #{response.code}"

          return false
        end

        block.call(response) if block_given?
      end
    end

    # Executa uma chamada remota a um webservice do Moodle retornando JSON
    # @param [String] remote_method_name
    # @param [Hash] params
    # @param [Proc] block
    def remote_json_call(remote_method_name, params={}, &block)
      default = {:wstoken => Settings.moodle_token, :wsfunction => remote_method_name, :moodlewsrestformat => 'json'}

      post_params = default
      post_params.merge!(params) unless params.empty?
      @error = {}

      Rails.logger.debug "[Moodle WS] Chamada remota: #{remote_method_name}, parametros: #{params}"

      RestClient.post(Settings.moodle_rest_url, post_params) do |response|
        Rails.logger.debug "[WS Moodle] resposta: #{response.code} #{response.inspect}"

        if response.code != 200
          Rails.logger.error "Falha ao conectar com o webservice do Moodle: HTTP_ERROR: #{response.code}"

          return false
        end

        data = JSON.parse(response)

        if data.is_a?(Hash) && data.has_key?('exception')
          @error = HashWithIndifferentAccess.new(data)

          Rails.logger.error "Webservice do Moodle informou uma falha: #{data['message']} (ERROR_CODE: #{data['errorcode']}) - #{data['debuginfo']}"
          return false
        end

        block.call(response) if block_given?

        return data
      end
    end


    # A ultima requisição ocorreu com sucesso?
    #
    # @return [Boolean] retorna se houve sucesso na ultima requisição
    def success?
      @error.empty?
    end

    # Informações de falha da ultima requisição
    #
    # @return [HashWithIndifferentAccess] hash contendo as chaves: 'errorcode', 'message', 'debuginfo' (Moodle)
    def errors
      @error
    end
  end
end