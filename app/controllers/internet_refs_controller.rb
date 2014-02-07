# encoding: utf-8
class InternetRefsController < ApplicationController
  inherit_resources

  before_filter :set_current_tab

  def index
    @internet_refs = @tcc.internet_refs
  end

  def show
    @internet_ref = InternetRef.find(params[:id])
  end

  def create
    @internet_ref = InternetRef.new(params[:internet_ref])

    if @internet_ref.valid?
      @tcc.transaction do
        @internet_ref.save!
        @tcc.references.create!(:element => @internet_ref)
        flash[:success] = t(:successfully_saved)
        redirect_to bibliographies_path(:anchor => 'internet', :moodle_user => params[:moodle_user])
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
      success.html { redirect_to bibliographies_path(:anchor => 'internet', :moodle_user => params[:moodle_user]), flash: {:success => t(:successfully_saved)} }
    end
  end

  def destroy
    @internet_ref = InternetRef.find(params[:id])
    if @internet_ref.destroy
      flash[:success] = t(:successfully_deleted)
    else
      flash[:error] = @internet_ref.errors.full_messages.to_sentence
    end
    redirect_to bibliographies_path(:moodle_user => params[:moodle_user])
  end


  private

  def set_current_tab
    set_tab :bibliographies
  end

end
