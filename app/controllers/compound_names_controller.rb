# encoding: utf-8
class CompoundNamesController < ApplicationController
  inherit_resources

  before_filter :set_current_tab

  def index

  end

  def show

  end

  def create

  end

  def update

  end

  def destroy

  end


  private

  def set_current_tab
    set_tab :compound_names
  end
end
