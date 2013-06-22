module LtiTccFilters
  def self.included(base)
    base.before_filter :authorize
    base.before_filter :get_tcc
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

      @type = @tp.custom_params["type"]

      logger.debug "Recovering LTI TP for: '#{@tp.roles}' "
    end
  end

  def get_tcc
    unless @tcc = Tcc.find_by_moodle_user(@user_id)
      if @tp.student?
        user_name = MoodleUser.get_name(@user_id)
        group = TutorGroup.get_tutor_group(user_name)
        @tcc = Tcc.create( moodle_user: @user_id, name: @tp.lis_person_name_full, tutor_group: group )
      end
    else
      if @tp.student?
        if @tcc.name.blank?
          @tcc.name = @tp.lis_person_name_full
          if @tcc.valid?
            @tcc.save!
          end
        end
      end
    end
  end
end