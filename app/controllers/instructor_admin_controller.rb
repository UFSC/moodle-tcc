class InstructorAdminController < ApplicationController
  include LtiTccFilters

  before_filter :check_permission

  def index
    tcc_definition_id = @tp.custom_params['tcc_definition']
    @tccs = Tcc.where(tcc_definition_id: tcc_definition_id).paginate(:page => params[:page], :per_page => 30)
    @hubs = Tcc.hub_names
  end

  private

  def check_permission
    unless current_user.view_all?
      flash[:error] = 'Você não possui permissão para acessar esta página'
      redirect_user_to_start_page
    end
  end


end
