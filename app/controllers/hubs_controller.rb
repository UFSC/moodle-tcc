# encoding: utf-8
class HubsController < ApplicationController

  include LtiTccFilters
  include StateMachineUtils

  before_filter :check_visibility, :only => [:show_tcc]


  def show
    @current_user = current_user
    set_tab ('hub'+params[:position]).to_sym

    @hub = @tcc.hubs.hub_portfolio.find_by_position(params[:position])

    # Recupera a ultima versão que nos interessa
    @last_hub_commented = @hub.last_useful_version

    @hub.new_state = @hub.aasm_current_state

    # Busca diários no moodle
    @hub.fetch_diaries(@user_id)
  end

  def show_tcc
    @current_user = current_user
    set_tab ('hub'+params[:position]).to_sym

    @hub = @tcc.hubs.hub_tcc.find_by_position(params[:position])
    hub_portfolio = @tcc.hubs.hub_portfolio.find_by_position(params[:position])

    # Garante que haverá a transição de "novo" para algum outro estado ao enviar o formulário
    @hub.new_state = @hub.new? ? :draft : @hub.aasm_current_state

    # TODO: escrever testes para essa condição, já que isso é crítico.
    @hub.reflection = hub_portfolio.reflection if @hub.new?

    # Busca diários no moodle
    @hub.fetch_diaries(@user_id)

    # Recupera a ultima versão que nos interessa
    @last_hub_commented = @hub.last_useful_version

    # Se for estudante ele não deve conseguir ver as alterações do orientador enquanto ele não devolver ou aprovar
    if current_user.student? && (@hub.sent_to_admin_for_revision? || @hub.sent_to_admin_for_evaluation?)
      # Vamos exibir a ultima versão enviada ao invés da atual para que o estudante não veja as edições do orientador
      @hub = @last_hub_commented
    end

    render 'show'
  end


  def save
    if @type == 'portfolio'
      new_state = params[:hub_portfolio][:new_state]

      @hub = @tcc.hubs.hub_portfolio.find_by_position(params[:hub_portfolio][:position])
      @hub.attributes = params[:hub_portfolio]
    else
      new_state = params[:hub_tcc][:new_state]

      @hub = @tcc.hubs.hub_tcc.find_by_position(params[:hub_tcc][:position])
      @hub.attributes = params[:hub_tcc]
    end
    #
    # Estudante
    #
    if current_user.student?

      if @hub.valid?
        case new_state
          when 'sent_to_admin_for_revision'
            @hub.send_to_admin_for_revision if @hub.may_send_to_admin_for_revision?
          when 'sent_to_admin_for_evaluation'
            @hub.send_to_admin_for_evaluation if @hub.may_send_to_admin_for_evaluation?
          when 'draft'
            @hub.send_to_draft if @hub.may_send_to_draft?
        end

        @hub.save

        hub = @tcc.hubs.hub_portfolio.find_by_position(params[:position])

        if @type == 'tcc' && !hub.terminated?
          hub.send_to_terminated if hub.may_send_to_terminated?
          hub.save
        end
        flash[:success] = t(:successfully_saved)

        if @type == 'tcc'
          return redirect_to show_hubs_tcc_path(position: @hub.position.to_s)
        else
          return redirect_to show_hubs_path(position: @hub.position.to_s)
        end

      end
    else


      #
      # TUTOR E ORIENTADOR
      #

      # Ação do botão
      old_state = @hub.state

      if params[:valued] == 'Avaliado'
        @hub.admin_evaluate_ok if @hub.may_admin_evaluate_ok?
      elsif params[:valued] == 'Aprovar'
        change_state('admin_evaluation_ok', @hub)
      elsif params[:draft]
        @hub.send_back_to_student if @hub.may_send_back_to_student?
      end

      if @hub.valid? && @hub.save
        return redirect_user_to_start_page
      else
        @hub.state = old_state
      end
    end

    # falhou, precisamos re-exibir as informações
    @current_user = current_user
    set_tab ('hub'+params[:position]).to_sym

    last_comment_version = @hub.versions.where('state != ?', 'draft').last
    @last_hub_commented = last_comment_version.reify unless last_comment_version.nil?

    # Busca diários no moodle
    @hub.fetch_diaries(@user_id)

    render :show
  end

  def update_state
    if @type == 'tcc'
      @hub = @tcc.hubs.hub_tcc.find_by_position(params[:position])
      new_state = params[:hub_tcc][:new_state]
    else
      if params[:hub_portfolio][:new_state] == 'admin_evaluation_ok' && @hub.grade.nil?
        flash[:error] = t(:cannot_change_to_state_without_grade)
        return redirect_user_to_start_page
      end
      @hub = @tcc.hubs.hub_portfolio.find_by_position(params[:position])
      new_state = params[:hub_portfolio][:new_state]
    end

    if change_state(new_state, @hub)
      @hub.save!
      flash[:success] = t(:successfully_saved)
    else
      flash[:error] = t(:invalid_state)
    end

    redirect_user_to_start_page
  end

  private

  def check_visibility
    @hub = @tcc.hubs.hub_portfolio.find_by_position(params[:position])
    unless @hub.nil?
      if !@hub.admin_evaluation_ok? && !@hub.terminated?
        flash[:error] = t(:cannot_access_hub_without_grading)
        return redirect_user_to_start_page
      end
    end
  end

end
