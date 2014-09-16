# encoding: utf-8
# FIX-ME: transformar em concern
module LtiTccFilters

  class TccNotFoundError < RuntimeError; end

  def self.included(base)
    base.before_action :authorize
    base.before_action :get_tcc
  end

  def authorize
    lti_params = session['lti_launch_params']

    if lti_params.nil?
      logger.error 'Access Denied: LTI not initialized'
      redirect_to access_denied_path

    else
      @tp = IMS::LTI::ToolProvider.new(Settings.consumer_key, Settings.consumer_secret, lti_params)
      logger.debug "Recovering LTI TP for: '#{@tp.roles}' "
    end
  end

  def get_tcc
    @tcc = Tcc.includes(chapters: [:chapter_definition]).joins(:student).where(people: {moodle_id: current_moodle_user}).first

    raise TccNotFoundError unless @tcc
  end
end