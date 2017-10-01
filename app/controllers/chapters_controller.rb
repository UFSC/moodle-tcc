class ChaptersController < ApplicationController
  include TccContent

  def edit
    set_tab ('chapter'+params[:position]).to_sym
    @chapter = @tcc.chapters.find_by(position: params[:position])
    authorize @chapter

    @current_user_chapter = current_user
    if policy(@chapter).must_import?
      if policy(@tcc).import_chapters?
        redirect_to import_chapters_path(params[:moodle_user], params[:position])
      else
        redirect_to empty_chapters_path(params[:moodle_user], params[:position])
      end
    else
      @comment = @chapter.comment || @chapter.build_comment
    end
  end

  def save
    count_typed, count_new = 0 # duplicate, independent variable

    @chapter = @tcc.chapters.find_by(position: params[:position])
    authorize @chapter

    chapter_server = @chapter.dup

    @chapter.attributes = params[:chapter]

    chapter_typed = @chapter.dup

    @comment = @chapter.comment || @chapter.build_comment
    @comment.attributes = params[:comment] if params[:comment]

    b_change_state = change_state

    new_content = TccContent::remove_blank_lines( @chapter.content)

    if chapter_server.content.eql?(new_content)
      # o texto não foi alterado
      # content_changed = false # ToDo: variável para ser usada quando for gravar o histórico
    else
      # o texto foi alterado
      # content_changed = true

      array_typed = Rails::Html::FullSanitizer.new.sanitize(chapter_typed.content).
          split("\r\n").join(' ').split(' ').select(&:presence)
      count_typed = array_typed.count
      if array_typed.present? &&
          array_typed.last.present? &&
          array_typed.last.eql?(Rails.application.secrets.error_key)
        # chave para gerar o erro
        # força gerar o erro para o servidor
        count_new = -1
      else
        count_new = Rails::Html::FullSanitizer.new.sanitize(new_content).
            split("\r\n").join(' ').split(' ').select(&:presence).count
      end
    end

    if !(count_typed.eql?(count_new))
      # se o texto digitado for diferente do texto com as linhas em branco removidas,
      #   então gera o erro
      msg_error = t('error_tcc_content_cleaning_blank_lines')
      flash.now[:error] = msg_error if b_change_state
      raise TccContent::CleaningBlankLinesError.new, msg_error
    end
    @chapter.content = new_content

    if @chapter.valid? && @chapter.save
      @comment.save! if params[:comment]

      flash[:success] = t(:successfully_saved)  if b_change_state
      return redirect_to edit_chapters_path(position: @chapter.position.to_s)
    end

    # falhou, precisamos re-exibir as informações
    set_tab ('chapter'+params[:position]).to_sym
    @current_user_chapter = current_user
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

    return redirect_to edit_chapters_path(params[:moodle_user], params[:position]),
                       alert: t('chapter_import_cannot_proceed') unless policy(@chapter).can_import?

    remote = MoodleAPI::MoodleOnlineText.new
    remote_text = remote.fetch_online_text_with_images(current_moodle_user, @chapter.chapter_definition.coursemodule_id)

    @chapter.content = TccService.new(@tcc).process_remote_text(remote_text)
    @chapter.to_draft
    @chapter.save!

    redirect_to edit_chapters_path(params[:moodle_user], params[:position]), notice: t('chapter_import_successfully')
  end

  private

  def change_state
    if params[:done]
      if policy(@chapter).can_send_to_done?
        @chapter.to_done
      else
        flash[:alert] = 'O capítulo não pôde ser aprovado! <br/> Verifique se há referências citadas no texto ou se há pendências de versionamento!'.html_safe
        return false
      end
    elsif params[:review]
      @chapter.to_review
    elsif (params[:draft] || (!@chapter.empty? && @chapter.state.eql?(:empty.to_s)))
      @chapter.to_draft
    elsif (@chapter.empty? && %w(draft empty).include?(@chapter.state) )
      @chapter.to_empty_admin
    elsif (params[:review_admin])
      @chapter.to_review_admin if policy(@chapter).can_send_to_review_admin?
    elsif (params[:draft_admin] || (!@chapter.empty? && @chapter.state.eql?(:empty.to_s)))
      @chapter.to_draft_admin if policy(@chapter).can_send_to_draft_admin?
    end
    true
  end
end
