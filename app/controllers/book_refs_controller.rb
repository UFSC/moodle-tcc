class BookRefsController < ApplicationController
  def new
    @book_ref = BookRef.new
  end

  def show
  end

  def update
  end

  def edit
  end

  def create
    @book_ref = GeneralRef.new(params[:book_ref])
    @book_ref.save
    tcc = Tcc.first
    tcc.references.create(:element => @book_ref)
    if tcc.save!
      flash[:success] = t(:successfully_saved)
      redirect_to '/bibliographies'
    else
      flash[:error] = t(:unsuccessfully_saved)
      redirect_to '/bibliographies'
    end
  end
end
