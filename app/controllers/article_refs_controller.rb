class ArticleRefsController < ApplicationController
  inherit_resources
  include LtiTccFilters

  before_filter :set_current_tab

  def index
    @article_refs = @tcc.article_refs
  end

  def create
    @article_ref = ArticleRef.new(params[:article_ref])

    if @article_ref.valid?
      @tcc.transaction do
        @article_ref.save!
        @tcc.references.create!(:element => @article_ref)
        flash[:success] = t(:successfully_saved)
        redirect_to bibliographies_path
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
      success.html { redirect_to bibliographies_path, flash: {:success => t(:successfully_saved)} }
    end
  end

  def destroy
    @article_ref = ArticleRef.find(params[:id])
    if @article_ref.destroy
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
