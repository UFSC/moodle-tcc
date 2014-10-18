# encoding: utf-8
class CompoundNamesController < ApplicationController

  autocomplete :compound_name, :name

  before_filter :set_current_tab

  def create
    authorize(@tcc, :show_compound_names?)
    compound_name = CompoundName.new(params[:compound_name])
    if compound_name.save
      flash[:success] = t(:successfully_saved)
    end

    redirect_to bibliographies_path(moodle_user: params[:moodle_user], anchor: 'compound_names')
  end

  def update
    authorize(@tcc, :show_compound_names?)
    compound_name = CompoundName.find(params[:id])
    if compound_name.update_attributes(params[:compound_name])
      flash[:success] = t(:successfully_saved)
    end
    redirect_to bibliographies_path(moodle_user: params[:moodle_user], anchor: 'compound_names')
  end

  def destroy
    authorize(@tcc, :show_compound_names?)
    @compound_name = CompoundName.find(params[:id])
    @compound_name.destroy
    redirect_to bibliographies_path(moodle_user: params[:moodle_user], anchor: 'compound_names'),
                notice: "Nome composto \"#{@compound_name.name}\" removido."
  end

  private

  def set_current_tab
    set_tab :compound_names
  end
end