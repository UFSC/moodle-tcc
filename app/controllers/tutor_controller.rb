# encoding: utf-8
class TutorController < ApplicationController
  include LtiTccFilters
  before_filter :check_permission

  def index
    username = MoodleUser.find_username_by_user_id(@user_id)

    # Problema no webservice
    render 'public/404.html' unless username

    group = TutorGroup.get_tutor_group(username)
    @group_name = TutorGroup.get_tutor_group_name(group)

    @tccs = Tcc.where(tutor_group: group).paginate(:page => params[:page], :per_page => 30) unless group.nil?
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
