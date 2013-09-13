# encoding: utf-8
class OrientadorController < ApplicationController
  include LtiTccFilters
  before_filter :check_permission

  def index
    username = MoodleUser.find_username_by_user_id(@user_id)

    # Problema no webservice
    render 'public/404.html' unless username

    @tccs = Tcc.where(orientador: username).paginate(:page => params[:page], :per_page => 30)
    @hubs = Tcc.hub_names
  end

  private

  def check_permission
    unless current_user.orientador?
      flash[:error] = 'Você não possui permissão para acessar esta página'
      redirect_user_to_start_page
    end
  end
end
