# encoding: utf-8
class GeneralRefsController < ApplicationController
  inherit_resources
  include LtiTccFilters

  before_filter :set_current_tab

  def index
    @general_refs = @tcc.general_refs
  end

  def show
    @general_ref = GeneralRef.find(params[:id])
  end

  def create
    @general_ref = GeneralRef.new(params[:general_ref])

    if @general_ref.valid?
      @tcc.transaction do
        @general_ref.save!
        @tcc.references.create!(:element => @general_ref)
        flash[:success] = t(:successfully_saved)
        redirect_to bibliographies_path(:anchor => 'geral')
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
      success.html { redirect_to bibliographies_path(:anchor => 'geral'), flash: {:success => t(:successfully_saved)} }
    end
  end

  def destroy
    @general_ref = GeneralRef.find(params[:id])
    if @general_ref.destroy
      flash[:success] = t(:successfully_deleted)
    else
      flash[:success] = t(:successfully_deleted)
    end
    redirect_to bibliographies_path
  end

  private

  def set_current_tab
    set_tab :bibliographies
  end
end
