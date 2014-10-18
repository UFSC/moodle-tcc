# encoding: utf-8
class ArticleRefsController < ApplicationController
  inherit_resources

  before_action :set_current_tab

  def index
    @article_refs = @tcc.article_refs.decorate
  end

  def edit
    @article_ref = @tcc.article_refs.find(params[:id])
  end

  def show
    @article_ref = @tcc.article_refs.find(params[:id]).decorate
  end

  def create
    @article_ref = ArticleRef.new(params[:article_ref])

    if @article_ref.valid?
      @tcc.transaction do
        @article_ref.save!
        @tcc.references.create!(:element => @article_ref)
        flash[:success] = t(:successfully_saved)
        redirect_to bibliographies_path(:anchor => 'article', :moodle_user => params[:moodle_user])
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
      success.html { redirect_to bibliographies_path(:anchor => 'article', :moodle_user => params[:moodle_user]), flash: {:success => t(:successfully_saved)} }
    end
  end

  def destroy
    @article_ref = @tcc.article_refs.find(params[:id])
    if @article_ref.destroy
      flash[:success] = t(:successfully_deleted)
    else
      flash[:error] = @article_ref.errors.full_messages.to_sentence
    end
    redirect_to bibliographies_path(:moodle_user => params[:moodle_user])
  end


  private

  def set_current_tab
    set_tab :bibliographies
  end
end
