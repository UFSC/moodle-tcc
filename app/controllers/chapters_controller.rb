# encoding: utf-8
class ChaptersController < ApplicationController

  def show
    set_tab ('chapter'+params[:position]).to_sym
    @chapter = @tcc.chapters.where(position: params[:position])
  end


  def save
    @chapter = @tcc.chapters.find_by_position(params[:position])
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

end
