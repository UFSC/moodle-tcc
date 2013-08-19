module MoodleGrade
  # Cria um item de nota para o curso especificado e com o nome determinado
  def self.populate_grade_items(courseid, itemname)
    Rails.logger.debug "[WS Moodle] Acessando Web Service create_grade_item: itemname=#{itemname}, course_id=#{courseid}"
    RestClient.post(TCC_CONFIG['server'],
                    :wsfunction => 'local_wstcc_create_grade_item',
                    :courseid => courseid,
                    :itemname => itemname,
                    :grademin => 0,
                    :grademax => 100,
                    :wstoken => TCC_CONFIG['token']) do |response|
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
                    :grademin => 0,
                    :grademax => 100,
                    :userid => userid,
                    :grade => grade.to_i,
                    :wstoken => TCC_CONFIG['token']) do |response|
      response
    end
  end
end