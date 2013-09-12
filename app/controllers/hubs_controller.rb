# encoding: utf-8
class HubsController < ApplicationController

  include LtiTccFilters
  include StateMachineUtils

  before_filter :check_visibility, :only => [:show_tcc]


  def show
    @current_user = current_user
    set_tab ('hub'+params[:position]).to_sym

    @hub = @tcc.hubs.hub_portfolio.find_by_position(params[:position])

    last_comment_version = @hub.versions.where('state != ? AND state != ?', 'draft', 'new').last

    begin
      @last_hub_commented = last_comment_version.reify unless last_comment_version.nil?
    rescue Psych::SyntaxError
      # FIX-ME: Corrigir no banco o que está ocasionando este problema.
      Rails.logger.error "WARNING: Falha ao tentar recuperar informações do papertrail. (user: #{@current_user.id}, hub: #{@hub.id})"
    end

    @hub.new_state = @hub.aasm_current_state

    # Busca diários no moodle
    @hub.fetch_diaries(@user_id)
  end

  def show_tcc
    @current_user = current_user
    set_tab ('hub'+params[:position]).to_sym

    @hub = @tcc.hubs.hub_tcc.find_by_position(params[:position])
    hub_portfolio = @tcc.hubs.hub_portfolio.find_by_position(params[:position])

    # TODO: escrever testes para essa condição, já que isso é crítico.
    @hub.reflection = hub_portfolio.reflection if @hub.new?

    last_comment_version = @hub.versions.where('state != ? AND state != ?', 'draft', 'new').last

    begin
      @last_hub_commented = last_comment_version.reify unless last_comment_version.nil?
    rescue Psych::SyntaxError
      # FIX-ME: Corrigir no banco o  que está ocasionando este problema.
      Rails.logger.error "WARNING: Falha ao tentar recuperar informações do papertrail. (user: #{@current_user.id}, hub: #{@hub.id})"
    end

    @hub.new_state = @hub.aasm_current_state

    # Busca diários no moodle
    @hub.fetch_diaries(@user_id)
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
        return redirect_user_to_start_page
      end
    else


      #
      # TUTOR
      #

      # Ação do botão
      old_state = @hub.state

      if params[:valued]
        @hub.admin_evaluate_ok if @hub.may_admin_evaluate_ok?
      else
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
      case params[:hub_tcc][:new_state]
        when 'draft'
          to_draft(@hub)
        when 'sent_to_admin_for_revision'
          to_revision(@hub)
        when 'sent_to_admin_for_evaluation'
          to_evaluation(@hub)
        when 'admin_evaluation_ok'
          to_evaluation_ok(@hub)
        else
          flash[:error] = 'Estado selecionado é invádlio'
          return redirect_user_to_start_page
      end


    else
      @hub = @tcc.hubs.hub_portfolio.find_by_position(params[:position])

      if params[:hub_portfolio][:new_state] == 'admin_evaluation_ok' && @hub.grade.nil?
        flash[:error] = 'Não é possível alterar para este estado sem ter dado uma nota.'
        return redirect_user_to_start_page
      end
      case params[:hub_portfolio][:new_state]
        when 'draft'
          to_draft(@hub)
        when 'sent_to_admin_for_revision'
          to_revision(@hub)
        when 'sent_to_admin_for_evaluation'
          to_evaluation(@hub)
        when 'admin_evaluation_ok'
          to_evaluation_ok(@hub)
        else
          flash[:error] = 'Estado selecionado é invádlio'
          return redirect_user_to_start_page
      end
    end

    @hub.save!
    flash[:success] = t(:successfully_saved)
    redirect_user_to_start_page
  end

  private

  def check_visibility
    @hub = @tcc.hubs.hub_portfolio.find_by_position(params[:position])
    unless @hub.nil?
      if !@hub.admin_evaluation_ok? && !@hub.terminated?
        flash[:error] = 'Para acessar este Eixo, o mesmo deve estar avaliado no Portfolio'
        return redirect_user_to_start_page
      end
    end
  end

end
