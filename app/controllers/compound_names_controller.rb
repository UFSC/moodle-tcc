# encoding: utf-8
class CompoundNamesController < ApplicationController

  autocomplete :compound_name, :name

  before_filter :set_current_tab
  skip_before_action :get_tcc
  #before_action :check_permission

  def index
    @compound_names = CompoundName.search(params[:search], params[:page], { per: 60 })
  end

  def new
    authorize(Tcc, :show_compound_names?)

    @modal_title = t(:add_compound_name)
    @compound_name = CompoundName.new(type_name: 'simple')

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

    redirect_to bibliographies_path(moodle_user: params[:moodle_user], anchor: 'compound_names')
  end

  def update
    authorize(Tcc, :show_compound_names?)
    compound_name = CompoundName.find(params[:id])

    if compound_name.update_attributes(params[:compound_name])
      flash[:success] = t(:successfully_saved)
    end

    redirect_to compound_names_path(moodle_user: params[:moodle_user], anchor: 'compound_names')
  end

  def destroy
    authorize(Tcc, :show_compound_names?)
    @compound_name = CompoundName.find(params[:id])
    @compound_name.destroy
    redirect_to compound_names_path(moodle_user: params[:moodle_user], anchor: 'compound_names'),
                success: "Nome composto \"#{@compound_name.name}\" removido."
  end

  private

  def set_current_tab
    #set_tab :compound_names
  end
end