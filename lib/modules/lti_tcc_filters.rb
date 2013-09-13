module LtiTccFilters
  unloadable

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
      @tp = IMS::LTI::ToolProvider.new(TCC_CONFIG['consumer_key'], TCC_CONFIG['consumer_secret'], lti_params)
      if (current_user.instructor? || current_user.view_all?) && params['moodle_user']
        @user_id = params['moodle_user']
      else
        @user_id = @tp.user_id
      end
      @type = @tp.custom_params['type']

      logger.debug "Recovering LTI TP for: '#{@tp.roles}' "
    end
  end

  def get_tcc
    if @tcc = Tcc.find_by_moodle_user(@user_id)
      if current_user.student? && @tcc.name.blank?
        @tcc.name = @tp.lis_person_name_full
        @tcc.save! if @tcc.valid?
      end

    else
      if current_user.student?
        username = MoodleUser.find_username_by_user_id(@user_id)
        group = TutorGroup.get_tutor_group(username)
        tcc_definition = TccDefinition.find(@tp.custom_params['tcc_definition'])

        @tcc = Tcc.create(moodle_user: @user_id, name: @tp.lis_person_name_full,
                          tutor_group: group, tcc_definition: tcc_definition)
      end
    end
  end
end