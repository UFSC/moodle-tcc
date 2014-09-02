module MoodleAPI
  class MoodleUser < Base

    # Busca o username no Moodle com base no user_id informado
    # @param [String] user_id user id no Moodle
    def self.find_username_by_user_id(user_id)

      MoodleAPI::Base.remote_call('local_wstcc_get_username', :userid => user_id) do |response|

        # Utiliza Nokogiri como parser XML
        doc = Nokogiri.parse(response)

        # Verifica se ocorreu algum problema com o acesso
        if !doc.xpath('/EXCEPTION').blank?


          error_code = doc.xpath('/EXCEPTION/ERRORCODE').text
          error_message = doc.xpath('/EXCEPTION/MESSAGE').text
          debug_info = doc.xpath('/EXCEPTION/DEBUGINFO').text

          #logger.error "Falha ao acessar o webservice do Moodle: #{error_message} (ERROR_CODE: #{error_code}) - #{debug_info}"
          # TODO: quando não conseguir encontrar, salvar mensagem de erro em variavel de instancia e retornar false
          return "Falha ao acessar o Moodle: #{error_message} (ERROR_CODE: #{error_code})"
        end

        # Recupera o conteúdo do user_name (matrícula)
        user_name = doc.xpath('/RESPONSE/SINGLE/KEY[@name="username"]/VALUE').text

      end
    end
  end
end