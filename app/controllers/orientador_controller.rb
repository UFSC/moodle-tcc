# encoding: utf-8
class OrientadorController < ApplicationController
  skip_before_filter :get_tcc
  before_filter :check_permission

  def index
    tcc_definition_id = @tp.custom_params['tcc_definition']
    username = MoodleUser.find_username_by_user_id(@user_id)

    # Problema no webservice
    render 'public/404.html' unless username

    @tccs = Tcc.where(tcc_definition_id: tcc_definition_id,
                      orientador: username).paginate(:page => params[:page], :per_page => 30)
    @hubs = Tcc.hub_names
  end

  private

  def check_permission
    unless current_user.orientador?
      flash[:error] = t(:cannot_access_page_without_enough_permission)
      redirect_user_to_start_page
    end
  end
end
