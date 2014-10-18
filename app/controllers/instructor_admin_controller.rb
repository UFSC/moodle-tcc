# encoding: utf-8

class InstructorAdminController < ApplicationController
  autocomplete :tcc, :name, :full => true
  skip_before_action :get_tcc
  before_action :check_permission

  def index
    tcc_definition = TccDefinition.find(@tp.custom_params['tcc_definition'])
    tccs = tcc_searchable(tcc_definition)

    search_options = {eager_load: [:abstract, :tcc_definition]}
    @tccs = tccs.search(params[:search], params[:page], search_options)

    @chapters = tcc_definition.chapter_definitions.map { |h| h.title }
  end

  def autocomplete_tcc_name
    term = params[:term]

    tcc_definition = TccDefinition.find(@tp.custom_params['tcc_definition'])
    tccs = tcc_searchable(tcc_definition)

    @tccs = tccs.search(term, 0)

    render :json => @tccs.map { |tcc| {:id => tcc.id, :label => tcc.student.name, :value => tcc.student.name} }
  end

  protected

  # TODO: colocar no tcc_policy.rb
  def check_permission
    unless current_user.view_all? || current_user.instructor?
      raise Authentication::UnauthorizedError.new(t('cannot_access_page_without_enough_permission'))
      redirect_user_to_start_page
    end
  end

  # TODO: colocar no tcc_policy.rb
  def tcc_searchable(tcc_definition)
    tccs = Tcc.includes(:student, chapters: [:chapter_definition]).where(tcc_definition_id: tcc_definition.id)

    if current_user.orientador?
      tccs = tccs.where(orientador_id: current_user.person.id)
    elsif current_user.tutor?
      tccs = tccs.where(tutor_id: current_user.person.id)
    end

    tccs
  end


end
