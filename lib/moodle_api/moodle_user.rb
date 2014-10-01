module MoodleAPI
  class MoodleUser < Base

    # Busca o username no Moodle com base no user_id informado
    # @param [String] user_id user id no Moodle
    def find_username_by_user_id(user_id)
      data = remote_json_call('local_wstcc_get_username', userid: user_id)

      return success? ? data['username'] : false
    end

    def find_users_by_field(field, values)
      data = remote_json_call('local_wstcc_get_users_by_field', field: field, values: [values])

      return success? ? OpenStruct.new(data.first) : false
    end

    def find_tutor_by_studentid(userid, courseid)
      data = remote_json_call('local_wstcc_get_tutor_responsavel', {userid: userid, courseid: courseid})

      return success? ? data['id_tutor'] : false
    end

    def get_students_by_course(courseid)
      data = remote_json_call('local_wstcc_get_students_by_course', courseid: courseid)

      return success? ? data.collect { |item| item['id'] } : false
    end

    def find_orientador_responsavel(userid, courseid)
      data = remote_json_call('local_wstcc_get_orientador_responsavel', {userid: userid, courseid: courseid})

      return success? ? data['id_orientador'] : false
    end

  end
end