# encoding: utf-8

class InstructorAdminController < ApplicationController
  autocomplete :tcc, :name, :full => true
  skip_before_action :get_tcc
  before_action :check_permission

  def navbar
    authorize(Tcc, :show_scope?)
    @tcc_definition = TccDefinition.includes(:chapter_definitions).find(@tp.custom_params['tcc_definition'])
    tccs = tcc_searchable(@tcc_definition)
    search_options = {eager_load: [:abstract, :tcc_definition]}
    @tccs = tccs.search(params[:search], params[:page], search_options)

    set_tab :tccs
    @compound_names = CompoundName.search(params[:search], params[:page], { per: 60 })
    @chapters = @tcc_definition.chapter_definitions.map { |h| h.title }
  end

  def index
    authorize(Tcc, :show_scope?)
    @tcc_definition = TccDefinition.includes(:chapter_definitions).find(@tp.custom_params['tcc_definition'])
    tccs = tcc_searchable(@tcc_definition)

    search_options = {eager_load: [:abstract, :tcc_definition]}
    @tccs = tccs.search(params[:search], params[:page], search_options).includes(:orientador)

    @chapters = @tcc_definition.chapter_definitions.map { |h| h.title }
  end

  def autocomplete_tcc_name
    term = params[:term]

    tcc_definition = TccDefinition.find(@tp.custom_params['tcc_definition'])
    tccs = tcc_searchable(tcc_definition)

    @tccs = tccs.search(term, 0)

    render :json => @tccs.map { |tcc| {:id => tcc.id, :label => tcc.student.name, :value => tcc.student.name} }
  end

  protected

  def check_permission
    unless current_user.view_all? || current_user.instructor?
      raise Authentication::UnauthorizedError, t('cannot_access_page_without_enough_permission')
      redirect_user_to_start_page
    end
  end

  def tcc_searchable(tcc_definition)
    tccList = Tcc.includes(:student, chapters: [:chapter_definition]).where(tcc_definition_id: tcc_definition.id)
    policy_scope(tccList)
  end


end
