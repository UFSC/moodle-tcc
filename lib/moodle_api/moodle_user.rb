module MoodleAPI
  class MoodleUser < Base

    # Busca o username no Moodle com base no user_id informado
    # @param [String] user_id user id no Moodle
    def self.find_username_by_user_id(user_id)
      MoodleAPI::Base.remote_call('local_wstcc_get_username', userid: user_id) do |response|
        # Utiliza Nokogiri como parser XML
        doc = Nokogiri.parse(response)

        # Verifica se ocorreu algum problema com o acesso
        if !doc.xpath('/EXCEPTION').blank?


          error_code = doc.xpath('/EXCEPTION/ERRORCODE').text
          error_message = doc.xpath('/EXCEPTION/MESSAGE').text
          debug_info = doc.xpath('/EXCEPTION/DEBUGINFO').text

          Rails.logger.error "Falha ao acessar o webservice do Moodle: #{error_message} (ERROR_CODE: #{error_code}) - #{debug_info}"
          # TODO: quando não conseguir encontrar, salvar mensagem de erro em variavel de instancia e retornar false
          return "Falha ao acessar o Moodle: #{error_message} (ERROR_CODE: #{error_code})"
        end

        # Recupera o conteúdo do user_name (matrícula)
        user_name = doc.xpath('/RESPONSE/SINGLE/KEY[@name="username"]/VALUE').text

      end
    end

    def self.find_users_by_field(field, values)
      MoodleAPI::Base.remote_json_call('local_wstcc_get_users_by_field', field: field, values: [values]) do |raw_response|
        response = JSON.parse(raw_response)

        # Verifica se ocorreu algum problema com o acesso
        if response.is_a? Hash and response.has_key? 'exception'
          error_code = response['errorcode']
          error_message = response['message']
          debug_info = response['debuginfo']

          Rails.logger.error "Falha ao acessar o webservice do Moodle: #{error_message} (ERROR_CODE: #{error_code}) - #{debug_info}"
          # TODO: quando não conseguir encontrar, salvar mensagem de erro em variavel de instancia e retornar false
          return "Falha ao acessar o Moodle: #{error_message} (ERROR_CODE: #{error_code})"
        end

        return OpenStruct.new(response.first)
      end
    end

    def self.find_tutor_by_studentid(userid, courseid)
      MoodleAPI::Base.remote_json_call('local_wstcc_get_tutor_responsavel', {userid: userid, courseid: courseid}) do |response|
        response = JSON.parse(response)

        # Verifica se ocorreu algum problema com o acesso
        if response.has_key? 'exception'
          error_code = response['errorcode']
          error_message = response['message']
          debug_info = response['debuginfo']

          Rails.logger.error "Falha ao acessar o webservice do Moodle: #{error_message} (ERROR_CODE: #{error_code}) - #{debug_info}"
          # TODO: quando não conseguir encontrar, salvar mensagem de erro em variavel de instancia e retornar false
          return "Falha ao acessar o Moodle: #{error_message} (ERROR_CODE: #{error_code})"
        end

        return response['id_tutor']
      end
    end

    def self.get_students_by_course(courseid)
      MoodleAPI::Base.remote_json_call('local_wstcc_get_students_by_course', courseid: courseid) do |response|
        response = JSON.parse(response)

        # Verifica se ocorreu algum problema com o acesso
        if response.is_a? Hash and response.has_key? 'exception'
          error_code = response['errorcode']
          error_message = response['message']
          debug_info = response['debuginfo']

          Rails.logger.error "Falha ao acessar o webservice do Moodle: #{error_message} (ERROR_CODE: #{error_code}) - #{debug_info}"
          # TODO: quando não conseguir encontrar, salvar mensagem de erro em variavel de instancia e retornar false
          return "Falha ao acessar o Moodle: #{error_message} (ERROR_CODE: #{error_code})"
        end

        return response.collect { |item| item['id'] }
      end
    end

    def self.find_orientador_responsavel(userid, courseid)
      MoodleAPI::Base.remote_json_call('local_wstcc_get_orientador_responsavel', {userid: userid, courseid: courseid}) do |response|
        response = JSON.parse(response)

        # Verifica se ocorreu algum problema com o acesso
        if response.has_key? 'exception'
          error_code = response['errorcode']
          error_message = response['message']
          debug_info = response['debuginfo']

          Rails.logger.error "Falha ao acessar o webservice do Moodle: #{error_message} (ERROR_CODE: #{error_code}) - #{debug_info}"
          # TODO: quando não conseguir encontrar, salvar mensagem de erro em variavel de instancia e retornar false
          return "Falha ao acessar o Moodle: #{error_message} (ERROR_CODE: #{error_code})"
        end

        return response['id_orientador']
      end
    end

  end
end