# encoding: utf-8
class OrientadorController < ApplicationController
  include LtiTccFilters
  before_filter :check_permission

  def index
    user_name = MoodleUser.get_name(@user_id)

    # Problema no webservice
    render 'public/404.html' unless user_name

    orientador = OrientadorGroup.get_orientador(user_name)

    @tccs = Tcc.where(orientador: orientador).paginate(:page => params[:page], :per_page => 30) unless orientador.nil?

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
