module MoodleGrade
  # Cria um item de nota para o curso especificado e com o nome determinado
  def self.populate_grade_items(courseid, itemname, lti_id, itemnumber)
    Rails.logger.debug "[WS Moodle] Acessando Web Service create_grade_item: itemname=#{itemname}, course_id=#{courseid}"
    RestClient.post(TCC_CONFIG['server'],
                    :wsfunction => 'local_wstcc_create_grade_item',
                    :courseid => courseid,
                    :itemname => itemname,
                    :lti_id => lti_id,
                    :itemnumber => itemnumber,
                    :wstoken => TCC_CONFIG['token']) do |response|
      MooddleWsClient.check_error(response)
      response
    end
  end

  # Seta a nota do usuário especificado no item especificado por 'itemname'
  def self.set_grade(userid, courseid, itemname, grade)
    Rails.logger.debug "[WS Moodle] Acessando Web Service set_grade: user_id=#{userid}, course_id=#{courseid}, itemname=#{itemname}, grade=#{grade.to_i.to_s}"
    RestClient.post(TCC_CONFIG['server'],
                    :wsfunction => 'local_wstcc_set_grade',
                    :courseid => courseid,
                    :itemname => itemname,
                    :userid => userid,
                    :grade => grade.to_i,
                    :wstoken => TCC_CONFIG['token']) do |response|
      MooddleWsClient.check_error(response)
      response
    end
  end

  class MooddleWsClient
    def self.check_error(response)
      if response.code != 200
        Rails.logger.error "Falha ao acessar o webservice do Moodle: HTTP_ERROR: #{response.code}"
        return "Falha ao acessar o Moodle: (HTTP_ERROR: #{response.code})"
      end
    end
  end
end