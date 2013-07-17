class LtiController < ApplicationController

  # Responsável por realizar a troca de mensagens e validação do LTI como um Tool Provider
  # De acordo com o papel informado pelo LTI Consumer, redireciona o usuário
  def establish_connection
    if authorize_lti!
      @type = @tp.custom_params['type']
      if current_user.student?
        logger.debug 'LTI user identified as a student'
        if @type == 'tcc'
          redirect_to show_tcc_path
        else
          redirect_to show_hubs_path(position: '1')
        end
      elsif current_user.instructor?
        logger.debug 'LTI user identified as a instructor'
        redirect_to instructor_admin_tccs_path
      else
        logger.error "LTI user identified as an unsupported role: '#{@tp.roles}'"
        redirect_to access_denied_path
      end
    end
  end

  def access_denied

  end

end
