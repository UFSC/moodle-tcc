module MoodleAPI
  class MoodleHub < Base
    def self.fetch_hub_diaries(hub, user_id)
      hub.diaries.each { |diary|
        online_text = fetch_online_text(user_id, diary.diary_definition.external_id)
        diary.content = online_text unless online_text.nil?
      }
    end

    def self.fetch_hub_diaries_for_printing(hub, user_id)
      hub.diaries.each { |diary|
        online_text = fetch_online_text_for_printing(user_id, diary.diary_definition.external_id)
        diary.content = online_text unless online_text.nil?
      }
    end

    private

    def fetch_online_text(user_id, coursemodule_id)
      MoodleAPI::Base.remote_call('local_wstcc_get_user_online_text_submission',
                                  :userid => user_id, :coursemoduleid => coursemodule_id) do |response|

        # Utiliza Nokogiri como parser XML
        doc = Nokogiri.parse(response)

        # Verifica se ocorreu algum problema com o acesso
        if !doc.xpath('/EXCEPTION').blank?


          error_code = doc.xpath('/EXCEPTION/ERRORCODE').text
          error_message = doc.xpath('/EXCEPTION/MESSAGE').text
          debug_info = doc.xpath('/EXCEPTION/DEBUGINFO').text

          Rails.logger.error "Falha ao acessar o webservice do Moodle: #{error_message} (ERROR_CODE: #{error_code}) - #{debug_info}"
          return "Falha ao acessar o Moodle: #{error_message} (ERROR_CODE: #{error_code})"
        end

        # Recupera o conteúdo do texto online
        online_text = doc.xpath('/RESPONSE/SINGLE/KEY[@name="onlinetext"]/VALUE').text

      end
    end

    def fetch_online_text_for_printing(user_id, coursemodule_id)
      MoodleAPI::Base.remote_call('local_wstcc_get_user_text_for_generate_doc',
                                  :userid => user_id, :coursemoduleid => coursemodule_id) do |response|

        # Utiliza Nokogiri como parser XML
        doc = Nokogiri.parse(response)

        # Verifica se ocorreu algum problema com o acesso
        if !doc.xpath('/EXCEPTION').blank?


          error_code = doc.xpath('/EXCEPTION/ERRORCODE').text
          error_message = doc.xpath('/EXCEPTION/MESSAGE').text
          debug_info = doc.xpath('/EXCEPTION/DEBUGINFO').text

          Rails.logger.error "Falha ao acessar o webservice do Moodle: #{error_message} (ERROR_CODE: #{error_code}) - #{debug_info}"
          return "Falha ao acessar o Moodle: #{error_message} (ERROR_CODE: #{error_code})"
        end

        # Recupera o conteúdo do texto online
        online_text = doc.xpath('/RESPONSE/SINGLE/KEY[@name="onlinetext"]/VALUE').text
      end
    end
  end

end