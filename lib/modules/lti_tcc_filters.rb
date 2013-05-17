module LtiTccFilters
  def self.included(base)
    base.before_filter :authorize, :only => [:show, :save]
    base.before_filter :get_tcc, :only => :show
  end

  def authorize
    lti_params = session['lti_launch_params']

    if lti_params.nil?
      logger.error 'Access Denied: LTI not initialized'
      redirect_to access_denied_path
    else
      @tp = IMS::LTI::ToolProvider.new(TCC_CONFIG["consumer_key"], TCC_CONFIG["consumer_secret"], lti_params)
      if @tp.instructor?
        @user_id = params["moodle_user"]
      else
        @user_id = @tp.user_id
      end

      logger.debug "Recovering LTI TP for: '#{@tp.roles}' "
    end
  end

  def get_tcc
    unless @tcc = Tcc.find_by_moodle_user(@user_id)
      @tcc = Tcc.create( :moodle_user => @user_id )
    end
  end
end