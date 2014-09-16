# encoding: utf-8
class OrientadorController < ApplicationController
  autocomplete :tcc, :name, :full => true

  skip_before_action :get_tcc
  before_action :check_permission

  def index
    tcc_definition_id = @tp.custom_params['tcc_definition']
    username = MoodleAPI::MoodleUser.find_username_by_user_id(current_moodle_user)

    # Problema no webservice
    render 'public/404.html' unless username

    search_options = {eager_load: [:abstract, :presentation, :tcc_definition, :final_considerations]}

    @tccs = Tcc.where(orientador: username, tcc_definition_id: tcc_definition_id).search(
        params[:search], params[:page], search_options)

    @chapters = Tcc.hub_names
  end

  protected

  def check_permission
    unless current_user.orientador?
      flash[:error] = t(:cannot_access_page_without_enough_permission)
      redirect_user_to_start_page
    end
  end
end
