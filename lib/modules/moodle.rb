module Moodle
  def self.fetch_hub_diaries(hub, user_id)
    m = MoodleHub.new
    m.fetch_hub_diaries(hub, user_id)
  end

  class MoodleHub
    def fetch_hub_diaries(hub, user_id)
      hub.diaries.each{|diary|
        online_text =  fetch_online_text(user_id, diary.diary_definition.external_id)
        diary.content = online_text unless online_text.nil?
      }
    end

    def fetch_online_text(user_id, coursemodule_id)
      Rails.logger.debug "[WS Moodle] Acessando Web Service: user_id=#{user_id}, coursemodule_id=#{coursemodule_id}"
      RestClient.post(TCC_CONFIG["server"],
                      :wsfunction => "local_wstcc_get_user_online_text_submission",
                      :userid => user_id, :coursemoduleid => coursemodule_id,
                      :wstoken => TCC_CONFIG["token"]) do |response|

        Rails.logger.debug "[WS Moodle] resposta: #{response.code} #{response.inspect}"

        if response.code != 200
          Rails.logger.error "Falha ao acessar o webservice do Moodle: HTTP_ERROR: #{response.code}"
          return "Falha ao acessar o Moodle: (HTTP_ERROR: #{response.code})"
        end

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