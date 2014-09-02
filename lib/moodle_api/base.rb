module MoodleAPI
  class Base
    # Executa uma chamada remota a um webservice do Moodle
    # @param [String] remote_method_name
    # @param [Hash] params
    # @param [Proc] block
    def self.remote_call(remote_method_name, params={}, &block)
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
  end
end