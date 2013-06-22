module MoodleUser
   def self.get_name(user_id)
     #logger.debug "[WS Moodle] Acessando Web Service: user_id=#{user_id}"
     RestClient.post(TCC_CONFIG["server"],
                     :wsfunction => "local_wstcc_get_username",
                     :userid => user_id,
                     :wstoken => TCC_CONFIG["token"]) do |response|

       #logger.debug "[WS Moodle] resposta: #{response.code} #{response.inspect}"

       if response.code != 200
         #logger.error "Falha ao acessar o webservice do Moodle: HTTP_ERROR: #{response.code}"
         return "Falha ao acessar o Moodle: (HTTP_ERROR: #{response.code})"
       end

       # Utiliza Nokogiri como parser XML
       doc = Nokogiri.parse(response)

       # Verifica se ocorreu algum problema com o acesso
       if !doc.xpath('/EXCEPTION').blank?


         error_code = doc.xpath('/EXCEPTION/ERRORCODE').text
         error_message = doc.xpath('/EXCEPTION/MESSAGE').text
         debug_info = doc.xpath('/EXCEPTION/DEBUGINFO').text

         #logger.error "Falha ao acessar o webservice do Moodle: #{error_message} (ERROR_CODE: #{error_code}) - #{debug_info}"
         return "Falha ao acessar o Moodle: #{error_message} (ERROR_CODE: #{error_code})"
       end

       # Recupera o conteúdo do user_name (matrícula)
       user_name = doc.xpath('/RESPONSE/SINGLE/KEY[@name="username"]/VALUE').text

     end
   end
end