# encoding: utf-8
# FIX-ME: transformar em concern
module LtiTccFilters

  class TccNotFoundError < RuntimeError;
  end

  def self.included(base)
    base.before_action :authorize_lti
    base.before_action :get_tcc
  end

  def authorize_lti
    lti_params = session['lti_launch_params']

    if lti_params.nil?
      logger.error 'Access Denied: LTI not initialized'

      raise Authentication::UnauthorizedError, 'Você precisa acessar essa aplicação a partir do Moodle'
    else
      @tp = IMS::LTI::ToolProvider.new(Settings.consumer_key, Settings.consumer_secret, lti_params)
      logger.debug "Recovering LTI TP for: '#{@tp.roles}' "
    end

    if current_user.student? && (!params[:moodle_user].nil? && !params[:moodle_user].empty?)
      if params[:moodle_user].to_i != (current_user.person.moodle_id)
        raise Authentication::UnauthorizedError, 'Você não pode acessar dados de outro usuário'
      end
    end
  end

  def get_tcc
    student = Person.where(moodle_id: current_moodle_user).first
    @tcc = Tcc.includes(chapters: [:chapter_definition]).where(student_id: student.id).first

    raise TccNotFoundError unless @tcc
  end
end
