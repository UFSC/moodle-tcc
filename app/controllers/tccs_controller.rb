# encoding: utf-8
class TccsController < ApplicationController
  include LtiTccFilters
  before_filter :check_permission, :only => :evaluate

  def show
    set_tab :data
  end

  def evaluate
    @tcc = Tcc.find(params[:tcc_id])
    @tcc.grade = params[:tcc][:grade]
    if @tcc.valid?
      @tcc.save!
      flash[:success] = t(:successfully_saved)
      redirect_user_to_start_page
    else
      flash[:error] = t(:unsuccessfully_saved)
      redirect_user_to_start_page
    end
  end

  def save
    if params[:moodle_user]
      @tcc = Tcc.find_by_moodle_user(params[:moodle_user])
    else
      @tcc = Tcc.find_by_moodle_user(@user_id)
    end

    if @tcc.update_attributes(params[:tcc])
      flash[:success] = t(:successfully_saved)
    end
    redirect_to show_tcc_path(:moodle_user => params[:moodle_user])
  end

  private
  def check_permission
    unless current_user.orientador?
      flash[:error] = t(:cannot_access_page_without_enough_permission)
      redirect_user_to_start_page
    end
  end
end
