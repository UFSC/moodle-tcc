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
    else
      @chapter_comment = @chapter.chapter_comment || @chapter.build_chapter_comment
      @comment = @chapter_comment.comment
    end
  end

  def save
    @chapter = @tcc.chapters.find_by(position: params[:position])
    authorize @chapter

    @chapter.attributes = params[:chapter]

    @chapter_comment = @chapter.chapter_comment || @chapter.build_chapter_comment
    @chapter_comment.attributes = params[:chapter_comment]

    if params[:done]
      @chapter.to_done;
    elsif params[:review]
      @chapter.to_review;
    elsif params[:draft]
      @chapter.to_draft;
    end

    if @chapter.valid? && @chapter.save
      @chapter_comment.save!
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
    remote_text = remote.fetch_online_text(current_moodle_user, @chapter.chapter_definition.coursemodule_id)

    @chapter.content = cleanup_and_process_remote_text(remote_text)
    @chapter.save!

    redirect_to edit_chapters_path(params[:moodle_user], params[:position]), notice: t('chapter_import_successfully')
  end

  private

  def cleanup_and_process_remote_text(remote_text)
    # XHTML bem formatado e com as correções necessárias para não atrapalhar o documento final do LaTex
    xml = TccDocument::HTMLProcessor.new.execute(remote_text)
    # Realiza transformações nas tags de imagem
    xml = TccDocument::ImageProcessor.new.execute(xml)
    # Download das figuras do Moodle e transformação em cópias locais
    xml = TccDocument::ImageDownloaderProcessor.new(@tcc).execute(xml)

    xml.to_xhtml
  end
end
