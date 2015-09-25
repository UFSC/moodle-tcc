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
      @comment = @chapter.comment || @chapter.build_comment
    end
  end

  def save
    @chapter = @tcc.chapters.find_by(position: params[:position])
    authorize @chapter

    @chapter.attributes = params[:chapter]

    @comment = @chapter.comment || @chapter.build_comment
    @comment.attributes = params[:comment] if params[:comment]

    ## O CKEditor está realizando a limpeza de linhas em branco
    # config.autoParagraph = false; # no config.sj do editor

    ## tira linhas em branco
    # U+00A0	/	194 160	/ NO-BREAK SPACE
    space2 = 194.chr("UTF-8")+160.chr("UTF-8")
    @chapter.content.gsub!(/#{space2}/) {" "}
    space1 = 160.chr("UTF-8")
    @chapter.content.gsub!(/#{space1}/) {" "}

    lines = @chapter.content.split("\r\n\r\n")
    newLines = lines.map { | x |
      # se não encontrar parágrafo com "imagem" e texto com espaços
      if /^<p(.*)><(.*)>(\s*)<\/p>$/.match(x).nil?
        # se não encontrar parágrafo e texto com espaços
        if /^<p(.*)>(\s*)<\/p>$/.match(x).nil?
          # então adiciona o texto em newLines
          x
        # senão, se encontrar parágrafo e texto com espaços
        # então abandona o texto e não adiciona em newLines
        end
      else
        # se encontrar parágrafo com "imagem" e texto com espaços
        # então adiciona o texto em newLines
        x
      end
    }.compact.join("\r\n\r\n")
    @chapter.content = newLines.chomp!

    b_change_state = change_state

    if @chapter.valid? && @chapter.save
      @comment.save! if params[:comment]

      flash[:success] = t(:successfully_saved)  if b_change_state
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
        flash[:error] = 'O capítulo não pôde ser aprovado! <br/> Verifique se há referências citadas no texto!'.html_safe
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
