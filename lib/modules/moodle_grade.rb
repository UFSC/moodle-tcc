module MoodleGrade
  def self.populate_grade_items(courseid, itemname)
    RestClient.post(TCC_CONFIG['server'],
                    :wsfunction => 'local_wstcc_create_grade_item',
                    :courseid => courseid,
                    :itemname => itemname,
                    :grademin => 0,
                    :grademax => 100,
                    :wstoken => TCC_CONFIG['token']) do |response|
    end
  end

  def self.set_grade(userid, courseid, itemname, grade)
    RestClient.post(TCC_CONFIG['server'],
                    :wsfunction => 'local_wstcc_set_grade',
                    :courseid => courseid,
                    :itemname => itemname,
                    :grademin => 10,
                    :grademax => 100,
                    :userid => userid,
                    :grade => grade,
                    :wstoken => TCC_CONFIG['token']) do |response|

      # Recupera o conteúdo do user_name (matrícula)
      response#.xpath('/RESPONSE/SINGLE/KEY[@name="username"]/VALUE').text

    end
  end
end