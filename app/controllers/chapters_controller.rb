# encoding: utf-8
class ChaptersController < ApplicationController

  def show
    set_tab ('chapter'+params[:position]).to_sym
    @chapter = @tcc.chapters.find_by(position: params[:position])

    redirect_to import_chapters_path(params[:position]) if @chapter.content.nil? || @chapter.content.empty?
  end

  def save
    @chapter = @tcc.chapters.find_by(position: params[:position])
    @chapter.attributes = params[:chapter]

    #
    # Estudante
    #
    if current_user.student?
      if @chapter.valid? && @chapter.save
        flash[:success] = t(:successfully_saved)
        return redirect_to show_chapters_path(position: @chapter.position.to_s)
      end
    else
      if @chapter.valid? && @chapter.save
        return redirect_user_to_start_page
      end
    end

    # falhou, precisamos re-exibir as informações
    set_tab ('chapter'+params[:position]).to_sym

    render :show
  end

  def import
    set_tab ('chapter'+params[:position]).to_sym
    @chapter = @tcc.chapters.find_by(position: params[:position])

    @can_import = true
  end

  def execute_import
    set_tab ('chapter'+params[:position]).to_sym
    @chapter = @tcc.chapters.find_by(position: params[:position])

    imported_text = MoodleAPI::MoodleOnlineText.fetch_online_text_for_printing(current_moodle_user,
                                                                               @chapter.chapter_definition.coursemodule_id)

    @chapter.content = imported_text
    @chapter.save!
    redirect_to show_chapters_path(params[:position]), notice: 'Importação concluída com sucesso!'
  end

end
