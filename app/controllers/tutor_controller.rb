# encoding: utf-8
class TutorController < ApplicationController
  autocomplete :tcc, :name, :full => true
  skip_before_filter :get_tcc
  before_filter :check_permission

  def index
    username = MoodleUser.find_username_by_user_id(@user_id)
    tcc_definition_id = @tp.custom_params['tcc_definition']

    # Problema no webservice
    render 'public/404.html' unless username

    group = TutorGroup.get_tutor_groups(username)
    @groups = TutorGroup.get_tutor_group_names(group)

    @tccs = Tcc.search(params[:search], params[:page], tcc_definition_id, group) unless group.nil?
    @hubs = Tcc.hub_names
  end

  private

  def check_permission
    unless current_user.tutor?
      flash[:error] = t(:cannot_access_page_without_enough_permission)
      redirect_user_to_start_page
    end
  end
end
