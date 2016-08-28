# encoding: utf-8
class BookRefsController < ApplicationController
  #inherit_resources

  before_action :set_current_tab

  def new
    @book_ref = BookRef.new()
  end

  def index
    @book_refs = @tcc.book_refs.decorate
  end

  def edit
    @book_ref = @tcc.book_refs.find(params[:id])
  end

  def show
    @book_ref = @tcc.book_refs.find(params[:id]).decorate
  end

  def create
    @book_ref = BookRef.new(params[:book_ref])

    if @book_ref.valid?
      @tcc.transaction do
        @book_ref.save!
        @tcc.references.create!(:element => @book_ref)
        flash[:success] = t(:successfully_saved)
        redirect_to bibliographies_path(:anchor => 'book',:moodle_user => params[:moodle_user])
      end
    else
      flash[:error] = t(:please_fix_invalid_data)
      render :new
    end
  end

  def update
    @book_ref = @tcc.book_refs.find(params[:id])
    @book_ref.attributes = params[:book_ref]
    @book_ref.num_quantity = '' if @book_ref.type_quantity.empty?
    update! do |success, failure|
      failure.html do
        flash[:error] = t(:please_fix_invalid_data)
        render :edit
      end
      success.html { redirect_to bibliographies_path(:anchor => 'book', :moodle_user => params[:moodle_user]), flash: {:success => t(:successfully_saved)} }
    end
  end

  def destroy
    # FIXME: somente o estudante pode remover
    @book_ref = @tcc.book_refs.find(params[:id])
    if @book_ref.destroy
      flash[:success] = t(:successfully_deleted)
    else
      flash[:error] = @book_ref.errors.full_messages.to_sentence
    end
    redirect_to bibliographies_path(:anchor => 'book', :moodle_user => params[:moodle_user])
  end

  private

  def set_current_tab
    set_tab :bibliographies
  end
end
