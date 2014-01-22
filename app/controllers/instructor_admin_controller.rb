# encoding: utf-8

class InstructorAdminController < ApplicationController
  autocomplete :tcc, :name, :full => true
  skip_before_filter :get_tcc
  before_filter :check_permission

  def index
    tcc_definition_id = @tp.custom_params['tcc_definition']

    if @type == 'portfolio'
      search_options = {eager_load: [:tcc_definition]}
      @tccs = Tcc.search(params[:search], params[:page], tcc_definition_id, search_options)
      @hubs = Tcc.hub_names
      render 'portfolio'
    else
      search_options = {eager_load: [:abstract, :presentation, :tcc_definition, :final_considerations]}
      @tccs = Tcc.search(params[:search], params[:page], tcc_definition_id, search_options)
      @hubs = Tcc.hub_names
      render 'tcc'
    end
  end

  protected

  def check_permission
    unless current_user.view_all?
      flash[:error] = t(:cannot_access_page_without_enough_permission)
      redirect_user_to_start_page
    end
  end


end
