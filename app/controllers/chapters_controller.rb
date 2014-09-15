# encoding: utf-8
class ChaptersController < ApplicationController
  before_filter :check_visibility, :only => [:show_tcc]

  def show
    @current_user = current_user
    set_tab ('chapter'+params[:position]).to_sym

    @chapter = @tcc.chapters.hub_portfolio.find_by_position(params[:position])

    # Recupera a ultima versão que nos interessa
    @last_hub_commented = @chapter.last_useful_version

    @chapter.new_state = @chapter.aasm.current_state

    # Busca diários no moodle
    @chapter.fetch_diaries(@user_id)
  end

  def show_tcc
    @current_user = current_user
    set_tab ('chapter'+params[:position]).to_sym

    @chapter = @tcc.chapters.hub_tcc.find_by_position(params[:position])
    hub_portfolio = @tcc.chapters.hub_portfolio.find_by_position(params[:position])

    # Garante que haverá a transição de "novo" para algum outro estado ao enviar o formulário
    @chapter.new_state = @chapter.new? ? :draft : @chapter.aasm.current_state

    # TODO: escrever testes para essa condição, já que isso é crítico.
    @chapter.reflection = hub_portfolio.reflection if @chapter.new?

    # Recupera a ultima versão que nos interessa
    @last_hub_commented = @chapter.last_useful_version

    # Se for estudante ele não deve conseguir ver as alterações do orientador enquanto ele não devolver ou aprovar
    if current_user.student? && (@chapter.sent_to_admin_for_revision? || @chapter.sent_to_admin_for_evaluation?)
      # Vamos exibir a ultima versão enviada ao invés da atual para que o estudante não veja as edições do orientador
      @chapter = @last_hub_commented if @last_hub_commented
    end

    # Busca diários no moodle
    @chapter.fetch_diaries(@user_id)

    render 'show'
  end


  def save
    if @type == 'portfolio'
      new_state = params[:hub_portfolio][:new_state]

      @chapter = @tcc.chapters.hub_portfolio.find_by_position(params[:hub_portfolio][:position])
      @chapter.attributes = params[:hub_portfolio]
    else
      new_state = params[:hub_tcc][:new_state]

      @chapter = @tcc.chapters.hub_tcc.find_by_position(params[:hub_tcc][:position])
      @chapter.attributes = params[:hub_tcc]
    end
    #
    # Estudante
    #
    if current_user.student?

      if @chapter.valid?
        case new_state
          when 'sent_to_admin_for_revision'
            @chapter.send_to_admin_for_revision if @chapter.may_send_to_admin_for_revision?
          when 'sent_to_admin_for_evaluation'
            @chapter.send_to_admin_for_evaluation if @chapter.may_send_to_admin_for_evaluation?
          when 'draft'
            @chapter.send_to_draft if @chapter.may_send_to_draft?
        end

        @chapter.save

        hub = @tcc.chapters.hub_portfolio.find_by_position(params[:position])

        if @type == 'tcc' && !hub.terminated?
          hub.send_to_terminated if hub.may_send_to_terminated?
          hub.save
        end
        flash[:success] = t(:successfully_saved)

        if @type == 'tcc'
          return redirect_to show_hubs_tcc_path(position: @chapter.position.to_s)
        else
          return redirect_to show_hubs_path(position: @chapter.position.to_s)
        end

      end
    else


      #
      # TUTOR E ORIENTADOR
      #

      # Ação do botão
      old_state = @chapter.state

      if params[:valued] == 'Avaliado'
        @chapter.admin_evaluate_ok if @chapter.may_admin_evaluate_ok?
      elsif params[:valued] == 'Aprovar'
        change_state('admin_evaluation_ok', @chapter)
      elsif params[:draft]
        @chapter.send_back_to_student if @chapter.may_send_back_to_student?
      end

      if @chapter.valid? && @chapter.save
        return redirect_user_to_start_page
      else
        @chapter.state = old_state
      end
    end

    # falhou, precisamos re-exibir as informações
    @current_user = current_user
    set_tab ('chapter'+params[:position]).to_sym

    last_comment_version = @chapter.versions.where('state != ?', 'draft').last
    @last_hub_commented = last_comment_version.reify unless last_comment_version.nil?

    # Busca diários no moodle
    @chapter.fetch_diaries(@user_id)

    render :show
  end

  def update_state
    if @type == 'tcc'
      @chapter = @tcc.chapters.hub_tcc.find_by_position(params[:position])
      new_state = params[:hub_tcc][:new_state]
    else
      @chapter = @tcc.chapters.hub_portfolio.find_by_position(params[:position])
      if params[:hub_portfolio][:new_state] == 'admin_evaluation_ok' && @chapter.grade.nil?
        flash[:error] = t(:cannot_change_to_state_without_grade)
        return redirect_user_to_start_page
      end
      new_state = params[:hub_portfolio][:new_state]
    end

    if change_state(new_state, @chapter)
      @chapter.save!
      flash[:success] = t(:successfully_saved)
    else
      flash[:error] = t(:invalid_state)
    end

    redirect_user_to_start_page
  end

  private

  def check_visibility
    @chapter = @tcc.chapters.hub_portfolio.find_by_position(params[:position])
    unless @chapter.nil?
      if !@chapter.admin_evaluation_ok? && !@chapter.terminated?
        flash[:error] = t(:cannot_access_hub_without_grading)
        return redirect_user_to_start_page
      end
    end
  end

end
