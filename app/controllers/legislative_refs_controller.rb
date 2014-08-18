# encoding: utf-8
class LegislativeRefsController < ApplicationController
  inherit_resources

  before_action :set_current_tab

  def index
    @legislative_refs = @tcc.legislative_refs
  end

  def show
    @legislative_ref = LegislativeRef.find(params[:id])
  end

  def create
    @legislative_ref = LegislativeRef.new(params[:legislative_ref])

    if @legislative_ref.valid?
      @tcc.transaction do
        @legislative_ref.save!
        @tcc.references.create!(:element => @legislative_ref)
        flash[:success] = t(:successfully_saved)
        redirect_to bibliographies_path(:anchor => 'legs', :moodle_user => params[:moodle_user])
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
      success.html { redirect_to bibliographies_path(:anchor => 'legs', :moodle_user => params[:moodle_user]), flash: {:success => t(:successfully_saved)} }
    end
  end

  def destroy
    @legislative_ref = LegislativeRef.find(params[:id])
    if @legislative_ref.destroy
      flash[:success] = t(:successfully_deleted)
    else
      flash[:error] = @legislative_ref.errors.full_messages.to_sentence
    end
    redirect_to bibliographies_path(:moodle_user => params[:moodle_user])
  end


  private

  def set_current_tab
    set_tab :bibliographies
  end
end
