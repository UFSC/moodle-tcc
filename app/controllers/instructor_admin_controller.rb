class InstructorAdminController < ApplicationController
  before_filter :authorize, :only => :index

  def index
    user_name = MoodleUser.get_name(@user_id)
    group = TutorGroup.get_tutor_group(user_name)
    @group_name = TutorGroup.get_tutor_group_name(group)

    if current_user.view_all?
      # usuário com permissão de visualização de todos estudantes de um determinado template de tcc
      tcc_definition_id = @tp.custom_params['tcc_definition']
      @tccs = Tcc.where(tcc_definition_id: tcc_definition_id).paginate(:page => params[:page], :per_page => 30)
    else
      @tccs = Tcc.where(tutor_group: group).paginate(:page => params[:page], :per_page => 30)
    end

    @hubs = Tcc.hub_names
  end

end
