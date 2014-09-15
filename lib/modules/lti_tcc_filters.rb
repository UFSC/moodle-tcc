# encoding: utf-8
# FIX-ME: transformar em concern
module LtiTccFilters

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
      if (current_user.instructor? || current_user.orientador? || current_user.view_all?) && params['moodle_user']
        @user_id = params['moodle_user']
      else
        @user_id = @tp.user_id
      end
      @type = @tp.custom_params['type']

      logger.debug "Recovering LTI TP for: '#{@tp.roles}' "
    end
  end

  def get_tcc
    unless @tcc = Tcc.includes(chapters: [:chapter_definition]).joins(:student).where(people: {moodle_id: @user_id}).first
      if current_user.student?
        #FIX-ME: migrar informações para sistema de relacionamentos e usar o MoodleAPI.
        username = MoodleAPI::MoodleUser.find_username_by_user_id(@user_id)
        group = TutorGroup.get_tutor_group(username)
        tcc_definition = TccDefinition.find(@tp.custom_params['tcc_definition'])

        @tcc = Tcc.create(moodle_user: @user_id,
                          tutor_group: group, tcc_definition: tcc_definition)
        @tcc.name = @tp.lis_person_name_full
        @tcc.save!
      else
        if @tcc.nil?
          # FIX-ME: redirecionar para uma página avisando o usuário que o TCC dele não existe na aplicação
          flash[:error] = t(:empty_tcc)
          redirect_user_to_start_page
        end
      end
    end

  end
end