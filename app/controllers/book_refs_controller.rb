class BookRefsController < ApplicationController
  inherit_resources
  include LtiTccFilters

  before_filter :set_current_tab

  def index
    @book_refs = @tcc.book_refs
  end

  def create
    @book_ref = BookRef.new(params[:book_ref])

    if @book_ref.valid?
      @tcc.transaction do
        @book_ref.save!
        @tcc.references.create!(:element => @book_ref)
        flash[:success] = t(:successfully_saved)
        redirect_to bibliographies_path(:anchor => 'book')
      end
    else
      flash[:error] = t(:please_fix_invalid_data)
      render :new
    end
  end

  def update
    @book_ref = BookRef.find(params[:id])
    @book_ref.attributes = params[:book_ref]
    @book_ref.num_quantity = '' if @book_ref.type_quantity.empty?
    update! do |success, failure|
      failure.html do
        flash[:error] = t(:please_fix_invalid_data)
        render :edit
      end
      success.html { redirect_to bibliographies_path(:anchor => 'book'), flash: {:success => t(:successfully_saved)} }
    end
  end

  def destroy
    @book_ref = BookRef.find(params[:id])
    if @book_ref.destroy
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
