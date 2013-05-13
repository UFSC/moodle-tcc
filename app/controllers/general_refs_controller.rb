class GeneralRefsController < ApplicationController
  def new
    @general_ref = GeneralRef.new
  end

  def create
    @general_ref = GeneralRef.new(params[:general_ref])
    @general_ref.save
    tcc = Tcc.first
    tcc.references.create(:element => @general_ref)
    if tcc.save!
      flash[:success] = t(:successfully_saved)
      redirect_to '/bibliographies'
    else
      flash[:error] = t(:unsuccessfully_saved)
      redirect_to '/bibliographies'
    end
  end

  def edit
    @general_ref = GeneralRef.find(params[:id])
  end

  def update
    @general_ref = GeneralRef.find(params[:id])
    if @general_ref.update_attributes(params[:general_ref])
      flash[:success] = t(:successfully_saved)
      redirect_to '/bibliographies'
    else
      redirect_to '/bibliographies'
    end

  end

  def destroy
    @general_ref = GeneralRef.find(params[:id])
    if @general_ref.destroy
      flash[:success] = t(:successfully_deleted)
      redirect_to '/bibliographies'
    else
      flash[:success] = t(:successfully_deleted)
      redirect_to '/bibliographies'
    end
  end

  def show
    @general_ref = Tcc.first.references.where(:id => params[:id], :element_type => 'GeneralRef').first

    if @general_ref.nil?
      flash[:error] = t(:could_not_find)
      nil
    else
      @general_ref = @general_ref.element
    end


  end
end
