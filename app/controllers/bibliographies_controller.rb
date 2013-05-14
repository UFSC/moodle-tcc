class BibliographiesController < ApplicationController

  before_filter :authorize

  def index
    @tcc = Tcc.find_by_moodle_user(@user_id)
    @references = @tcc.references.collect { |r| r.element }
    @general_refs = @tcc.general_refs
  end

  def authorize
    lti_params = session['lti_launch_params']

    if lti_params.nil?
      logger.error 'Access Denied: LTI not initialized'
      redirect_to access_denied_path
    else
      @tp = IMS::LTI::ToolProvider.new(TCC_CONFIG["consumer_key"], TCC_CONFIG["consumer_secret"], lti_params)
      if @tp.instructor?
        redirect_to access_denied_path
      else
        @user_id = @tp.user_id
      end

      logger.debug "Recovering LTI TP for: '#{@tp.roles}' "
    end
  end

end
