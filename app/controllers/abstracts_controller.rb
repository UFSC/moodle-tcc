# encoding: utf-8
class AbstractsController < ApplicationController
  include ControllersUtils

  def edit
    set_tab :abstract
    @abstract = @tcc.abstract || @tcc.build_abstract

    authorize @abstract

    @current_user_abstract = current_user
    @comment = @tcc.abstract.comment || @tcc.abstract.build_comment
  end

  def create
    @abstract = @tcc.build_abstract(params[:abstract])

    authorize @abstract

    @comment = @tcc.abstract.build_comment()
    @comment.attributes = params[:comment] if params[:comment]

    b_save_title = save_title

    b_change_state = change_state

    @abstract.content = ControllersUtils::remove_blank_lines(@abstract.content)

    if @abstract.valid? && @abstract.save
      #@comment.save!
      flash[:success] = t(:successfully_saved) if b_save_title && b_change_state
      return redirect_to edit_abstracts_path(moodle_user: params[:moodle_user])
    end
    # falhou, precisamos re-exibir as informações
    set_tab :abstract
    render :edit
  end

  def update
    @abstract = @tcc.abstract

    authorize @abstract

    @abstract.attributes = params[:abstract] if params[:abstract]

    @comment = @tcc.abstract.comment || @tcc.abstract.build_comment
    @comment.attributes = params[:comment] if params[:comment]

    b_save_title = save_title

    b_change_state = change_state

    @abstract.content = ControllersUtils::remove_blank_lines(@abstract.content)

    if @abstract.valid? && @abstract.save
      @comment.save! if params[:comment]
      flash[:success] = t(:successfully_saved) if b_save_title && b_change_state
      return redirect_to edit_abstracts_path(moodle_user: params[:moodle_user])
    end
    # falhou, precisamos re-exibir as informações
    set_tab :abstract
    render :edit

  end

  private

  def change_state
    if params[:done]
      if policy(@abstract).can_send_to_done?
        @abstract.to_done
      else
        flash[:alert] = 'O capítulo não pôde ser aprovado! <br/> Verifique se o título não está vazio, se há referências citadas no texto ou se há pendências de versionamento!'.html_safe
        return false
      end
    elsif params[:review]
      @abstract.to_review
    elsif (params[:draft] || (!@abstract.empty? && @abstract.state.eql?(:empty.to_s)))
      @abstract.to_draft
    elsif (@abstract.empty? && %w(draft empty).include?(@abstract.state) )
      @abstract.to_empty_admin
    elsif (params[:review_admin])
      @abstract.to_review_admin if policy(@abstract).can_send_to_review_admin?
    elsif (params[:draft_admin] || (!@abstract.empty? && @abstract.state.eql?(:empty.to_s)))
      @abstract.to_draft_admin if policy(@abstract).can_send_to_draft_admin?
    end
    true
  end

  def save_title
    # verifica se o título foi alterado
    saved = true
    unless (!params[:tcc] || @tcc.title.eql?(params[:tcc][:title]))
      @tcc.title = params[:tcc][:title]

      # se foi alterado, verifica se é valido
      if !@tcc.valid? || !@tcc.save
        flash[:error] = 'Título inválido'
        set_tab :abstract
        render :edit
        saved = false
      end
    end
    saved
  end
end
