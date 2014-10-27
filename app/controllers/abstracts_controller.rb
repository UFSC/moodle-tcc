# encoding: utf-8
class AbstractsController < ApplicationController
  def edit
    set_tab :abstract
    @abstract = @tcc.abstract || @tcc.build_abstract

    authorize @abstract

    @chapter_comment = @tcc.abstract.chapter_comment || @tcc.abstract.build_chapter_comment
    @comment = @chapter_comment.comment
  end

  def create
    @abstract = @tcc.build_abstract(params[:abstract])

    authorize @abstract

    @chapter_comment = @tcc.abstract.build_chapter_comment(params[:chapter_comment])

    if @abstract.valid? && @abstract.save
      @chapter_comment.save!
      flash[:success] = t(:successfully_saved)
      redirect_to edit_abstracts_path(moodle_user: params[:moodle_user])
    else
      set_tab :abstract
      render :edit
    end
  end

  def update
    @abstract = @tcc.abstract

    authorize @abstract

    @abstract.attributes=params[:abstract]
    @chapter_comment = @tcc.abstract.chapter_comment || @tcc.abstract.build_chapter_comment
    @chapter_comment.attributes = params[:chapter_comment]

    if @abstract.valid? && @abstract.save
      @chapter_comment.save!
      flash[:success] = t(:successfully_saved)
      redirect_to edit_abstracts_path(moodle_user: params[:moodle_user])
    else
      set_tab :abstract
      render :edit
    end
  end
end
