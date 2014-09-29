# encoding: utf-8
class AbstractsController < ApplicationController
  def edit
    @current_user = current_user
    set_tab :abstract
    @abstract = @tcc.abstract || @tcc.build_abstract
  end

  def create
    @abstract = @tcc.build_abstract(params[:abstract])

    if @abstract.valid? && @abstract.save
      flash[:success] = t(:successfully_saved)
      redirect_to edit_abstracts_path(moodle_user: params[:moodle_user])
    else
      set_tab :abstract
      render :edit
    end
  end

  def update
    @abstract = @tcc.abstract
    @abstract.attributes=params[:abstract]

    if @abstract.valid? && @abstract.save
      flash[:success] = t(:successfully_saved)
      redirect_to edit_abstracts_path(moodle_user: params[:moodle_user])
    else
      set_tab :abstract
      render :edit
    end
  end
end
