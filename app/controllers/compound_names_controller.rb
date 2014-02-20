# encoding: utf-8
class CompoundNamesController < ApplicationController

  autocomplete :compound_name, :name

  before_filter :set_current_tab

  def create
    compound_name = CompoundName.new(params[:compound_name])
    compound_name.save
    redirect_to bibliographies_path(moodle_user: params[:moodle_user], anchor: 'compound_names'),
                :notice => "Nome composto \"#{compound_name.name}\" salvo."
  end

  def update

  end

  def destroy
    @compound_name = CompoundName.find(params[:id])
    @compound_name.destroy
    redirect_to bibliographies_path(moodle_user: params[:moodle_user], anchor: 'compound_names'),
                :notice => "Nome composto \"#{@compound_name.name}\" removido."
  end

  private

  def set_current_tab
    set_tab :compound_names
  end
end