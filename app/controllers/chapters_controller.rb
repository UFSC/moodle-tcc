# encoding: utf-8
class ChaptersController < ApplicationController

  def edit
    set_tab ('chapter'+params[:position]).to_sym
    @chapter = @tcc.chapters.find_by(position: params[:position])
    authorize @chapter

    if policy(@chapter).must_import?
      if policy(@tcc).import_chapters?
        redirect_to import_chapters_path(params[:moodle_user], params[:position])
      else
        redirect_to empty_chapters_path(params[:moodle_user], params[:position])
      end
    end
  end

  def save
    @chapter = @tcc.chapters.find_by(position: params[:position])
    authorize @chapter

    @chapter.attributes = params[:chapter]
    if @chapter.valid? && @chapter.save
      flash[:success] = t(:successfully_saved)
      return redirect_to edit_chapters_path(position: @chapter.position.to_s)
    end

    # falhou, precisamos re-exibir as informações
    set_tab ('chapter'+params[:position]).to_sym
    render :edit
  end

  def empty
    set_tab ('chapter'+params[:position]).to_sym
    @chapter = @tcc.chapters.find_by(position: params[:position])

    authorize @chapter
  end

  def import
    set_tab ('chapter'+params[:position]).to_sym
    @chapter = @tcc.chapters.find_by(position: params[:position])

    # used in app/views/chapters/import.html.erb to show message
    @can_import = policy(@chapter).can_import?
    flash[:alert] = t('chapter_import_cannot_proceed') unless policy(@chapter).must_import?
  end

  def execute_import
    set_tab ('chapter'+params[:position]).to_sym
    @chapter = @tcc.chapters.find_by(position: params[:position])
    authorize @chapter

    redirect_to edit_chapters_path(params[:moodle_user], params[:position]),
                alert: t('chapter_import_cannot_proceed') unless policy(@chapter).can_import?

    remote = MoodleAPI::MoodleOnlineText.new
    @chapter.content = remote.fetch_online_text(current_moodle_user, @chapter.chapter_definition.coursemodule_id)
    @chapter.save!

    redirect_to edit_chapters_path(params[:moodle_user], params[:position]), notice: t('chapter_import_successfully')
  end
end
