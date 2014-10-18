# encoding: utf-8
class BookCapRefsController < ApplicationController
  inherit_resources

  before_action :set_current_tab

  def index
    @book_cap_refs = @tcc.book_cap_refs.decorate
  end

  def edit
    @book_cap_ref = @tcc.book_cap_refs.find(params[:id])
  end

  def show
    @book_cap_ref = @tcc.book_cap_refs.find(params[:id]).decorate
  end

  def create
    @book_cap_ref = BookCapRef.new(params[:book_cap_ref])

    if @book_cap_ref.valid?
      @tcc.transaction do
        @book_cap_ref.save!
        @tcc.references.create!(:element => @book_cap_ref)
        flash[:success] = t(:successfully_saved)
        redirect_to bibliographies_path(:anchor => 'book_cap', :moodle_user => params[:moodle_user])
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
      success.html { redirect_to bibliographies_path(:anchor => 'book_cap', :moodle_user => params[:moodle_user]), flash: {:success => t(:successfully_saved)} }
    end
  end

  def destroy
    @book_cap_ref = @tcc.book_cap_refs.find(params[:id])
    if @book_cap_ref.destroy
      flash[:success] = t(:successfully_deleted)
    else
      flash[:error] = @book_cap_ref.errors.full_messages.to_sentence
    end
    redirect_to bibliographies_path(:moodle_user => params[:moodle_user])
  end

  private

  def set_current_tab
    set_tab :bibliographies
  end

end
