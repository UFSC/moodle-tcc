module MoodleAPI
  class MoodleOnlineText < MoodleAPI::Base

    def fetch_online_text_status(user_id, coursemodule_id)
      data = remote_json_call('local_wstcc_get_user_online_text_submission',
                              userid: user_id, coursemoduleid: coursemodule_id)

      success? ? data['status'] : false
    end

    def fetch_online_text(user_id, coursemodule_id)
      data = remote_json_call('local_wstcc_get_user_online_text_submission',
                              userid: user_id, coursemoduleid: coursemodule_id)

      if success?
        data['onlinetext']
      else
        "Falha ao acessar o Moodle: #{self.errors[:error_message]} (ERROR_CODE: #{self.errors[:error_code]})"
      end

    end

    def fetch_online_text_for_printing(user_id, coursemodule_id)
      data = remote_json_call('local_wstcc_get_user_text_for_generate_doc',
                              userid: user_id, coursemoduleid: coursemodule_id)

      if success?
        data['onlinetext']
      else
        "Falha ao acessar o Moodle: #{self.errors[:error_message]} (ERROR_CODE: #{self.errors[:error_code]})"
      end
    end
  end
end