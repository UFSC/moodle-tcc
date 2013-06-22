class InstructorAdminController < ApplicationController
  before_filter :authorize, :only => :index

  def index
    user_name = MoodleUser.get_name(@user_id)
    group = TutorGroup.get_tutor_group(user_name)
    @group_name = TutorGroup.get_tutor_group_name(group)
    @tccs = Tcc.where(tutor_group: group).paginate(:page => params[:page], :per_page => 30)
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
      @type = @tp.custom_params["type"]

      logger.debug "Recovering LTI TP for: '#{@tp.roles}' "
    end
  end
end
