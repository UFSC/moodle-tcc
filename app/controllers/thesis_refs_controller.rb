# encoding: utf-8

class ThesisRefsController < ApplicationController
  inherit_resources

  before_filter :set_current_tab

  def index
    @thesis_refs = @tcc.thesis_refs
  end

  def show
    @thesis_ref = ThesisRef.find(params[:id])
  end

  def create
    @thesis_ref = ThesisRef.new(params[:thesis_ref])

    if @thesis_ref.valid?
      @tcc.transaction do
        @thesis_ref.save!
        @tcc.references.create!(:element => @thesis_ref)
        flash[:success] = t(:successfully_saved)
        redirect_to bibliographies_path(:anchor => 'thesis', :moodle_user => params[:moodle_user])
      end
    else
      flash[:error] = t(:please_fix_invalid_data)
      render :new
    end
  end

  def update
    update! do |success, failure|
      failure.html do
        flash[:error] = t(:please_fix_invalid_data)
        render :edit
      end
      success.html { redirect_to bibliographies_path(:anchor => 'thesis', :moodle_user => params[:moodle_user]),
                                 flash: {:success => t(:successfully_saved)} }
    end
  end

  def destroy
    @thesis_ref = ThesisRef.find(params[:id])
    if @thesis_ref.destroy
      flash[:success] = t(:successfully_deleted)
    else
      flash[:error] = @thesis_ref.errors.full_messages.to_sentence
    end
    redirect_to bibliographies_path(:moodle_user => params[:moodle_user])
  end

  private

  def set_current_tab
    set_tab :bibliographies
  end
end
