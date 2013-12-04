# encoding: utf-8
class InstructorAdminController < ApplicationController
  skip_before_filter :get_tcc
  before_filter :check_permission

  def index
    tcc_definition_id = @tp.custom_params['tcc_definition']
    @tccs = Tcc.where(tcc_definition_id: tcc_definition_id).paginate(:page => params[:page], :per_page => 30)
    @hubs = Tcc.hub_names

    if @type == 'portfolio'
      render 'portfolio'
    else
      render 'tcc'
    end
  end

  private

  def check_permission
    unless current_user.view_all?
      flash[:error] = t(:cannot_access_page_without_enough_permission)
      redirect_user_to_start_page
    end
  end


end
