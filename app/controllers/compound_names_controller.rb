# encoding: utf-8
class CompoundNamesController < ApplicationController

  autocomplete :compound_name, :name

  skip_before_action :get_tcc
  before_action :check_permission

  def index
    @compound_names = CompoundName.search(params[:search], params[:page], { per: 12 })
  end

  def new
    authorize(Tcc, :show_compound_names?)

    @modal_title = t(:add_compound_name)
    @compound_name = CompoundName.new(type_name: 'suffix')

    respond_to do |format|
      format.js
    end
  end

  def edit
    @modal_title = t(:edit_compound_name)
    @compound_name = CompoundName.find(params[:id])

     respond_to do |format|
       format.js
     end
  end

  def create
    authorize(Tcc, :show_compound_names?)
    compound_name = CompoundName.new(params[:compound_name])

    if compound_name.save
      flash[:success] = t(:successfully_saved)
    end

    redirect_to compound_names_path(moodle_user: params[:moodle_user], anchor: 'compound_names')
  end

  def update
    authorize(Tcc, :show_compound_names?)
    compound_name = CompoundName.find(params[:id])

    if compound_name.update_attributes(params[:compound_name])
      flash[:success] = t(:successfully_saved)
    end

    redirect_to compound_names_path(moodle_user: params[:moodle_user])
  end

  def destroy
    authorize(Tcc, :show_compound_names?)
    @compound_name = CompoundName.find(params[:id])
    @compound_name.destroy
    flash[:success] = "Nome composto \"#{@compound_name.name}\" removido."
    redirect_to compound_names_path(moodle_user: params[:moodle_user], anchor: 'compound_names')
  end

  protected

  def check_permission
    unless current_user.view_all? || current_user.instructor?
      raise Authentication::UnauthorizedError, t('cannot_access_page_without_enough_permission')
      redirect_user_to_start_page
    end
  end

end