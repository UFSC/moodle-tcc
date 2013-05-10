class InstructorAdminController < ApplicationController
  before_filter :authorize, :only => :index

  def index
    @tccs = Tcc.paginate(:page => params[:page], :per_page => 1)
  end

  private

  def authorize
    lti_params = session['lti_launch_params']

    if lti_params.nil?
      logger.error 'Access Denied: LTI not initialized'

      redirect_to access_denied_path
    else
      @tp = IMS::LTI::ToolProvider.new(TCC_CONFIG["consumer_key"], TCC_CONFIG["consumer_secret"], lti_params)
      @user_id = @tp.user_id

      logger.debug "Recovering LTI TP for: '#{@tp.roles}' "
    end
  end
end
