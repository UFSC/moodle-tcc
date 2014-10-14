module MoodleAPI
  class MoodleGrade < Base

    # Cria um item de nota para o curso especificado e com o nome determinado
    def populate_grade_items(courseid, itemname, lti_id, itemnumber)
      remote_call('local_wstcc_create_grade_item',
                  courseid: courseid,
                  itemname: itemname,
                  lti_id: lti_id,
                  itemnumber: itemnumber,
                  grademin: 0,
                  grademax: 100
      ) do |response|
        self.check_error(response)
        response
      end
    end

    # Seta nota do usuário especificado no item especificado por 'itemname'
    def set_grade(userid, courseid, itemname, grade)
      remote_call('local_wstcc_set_grade',
                  courseid: courseid,
                  itemname: itemname,
                  userid: userid,
                  grade: grade.to_i
      ) do |response|
        self.check_error(response)
        response
      end
    end

    private

    def check_error(response)
      if response.code != 200
        Rails.logger.error "Falha ao acessar o webservice do Moodle: HTTP_ERROR: #{response.code}"
        return "Falha ao acessar o Moodle: (HTTP_ERROR: #{response.code})"
      end
    end
  end
end