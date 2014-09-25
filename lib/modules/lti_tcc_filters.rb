# encoding: utf-8
# FIX-ME: transformar em concern
module LtiTccFilters

  class TccNotFoundError < RuntimeError;
  end

  def self.included(base)
    base.before_action :authorize
    base.before_action :get_tcc
  end

  def authorize
    lti_params = session['lti_launch_params']

    if lti_params.nil?
      logger.error 'Access Denied: LTI not initialized'

      raise Authentication::UnauthorizedError.new('Você precisa acessar essa aplicação a partir do Moodle')
    else
      @tp = IMS::LTI::ToolProvider.new(Settings.consumer_key, Settings.consumer_secret, lti_params)
      logger.debug "Recovering LTI TP for: '#{@tp.roles}' "
    end

    if current_user.student? && (!params[:moodle_user].nil? && !params[:moodle_user].empty?)
      raise Authentication::UnauthorizedError.new('Você não pode acessar dados de outro usuário')
    end
  end

  def get_tcc
    @tcc = Tcc.includes(chapters: [:chapter_definition]).joins(:student).where(people: {moodle_id: current_moodle_user}).first

    raise TccNotFoundError unless @tcc
  end
end