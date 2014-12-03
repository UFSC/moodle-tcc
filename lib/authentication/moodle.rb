module Authentication
  module Moodle

    def current_user
      @current_user ||= User.new(@tp) unless @tp.nil?
    end

    # ID do Moodle User atual ou o ID personificado quando o acesso for por não-estudantes.
    #
    # @return [Integer] ID do Moodle User
    def current_moodle_user
      @moodle_user ||=
          if (current_user.instructor? || current_user.view_all?) && params['moodle_user']
            params['moodle_user']
          else
            current_user.id
          end
    end

    # Redireciona o usuário atual para a página de início relativa as permissões de acesso dele
    #
    def redirect_user_to_start_page
      if current_user.view_all?
        logger.debug 'LTI user is part of a view_all role'
        redirect_to instructor_admin_path
      elsif current_user.orientador?
        logger.debug 'LTI user identified as a leader'
        redirect_to instructor_admin_path
      elsif current_user.tutor?
        logger.debug 'LTI user identified as a tutor'
        redirect_to instructor_admin_path
      elsif current_user.student?
        logger.debug 'LTI user identified as a student'
        redirect_to tcc_path
      else
        logger.error "LTI user identified as an unsupported role: '#{@tp.roles}'"
        redirect_to access_denied_path
      end
    end
  end
end