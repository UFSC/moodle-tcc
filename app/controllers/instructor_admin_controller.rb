# encoding: utf-8

class InstructorAdminController < ApplicationController
  autocomplete :tcc, :name, :full => true
  skip_before_action :get_tcc
  before_action :check_permission

  def index
    authorize(Tcc, :show_scope?)
    @tcc_definition = TccDefinition.includes(:chapter_definitions).find(@tp.custom_params['tcc_definition'])
    show_graded_after = @tp.custom_params['show_graded_after']
    show_graded_before = @tp.custom_params['show_graded_before']
    tccs = tcc_searchable(@tcc_definition, show_graded_after, show_graded_before)

    search_options = {eager_load: [:abstract, :tcc_definition]}
    @tccs = tccs.search(params[:search], params[:page], search_options).includes(:orientador)

    @chapters = @tcc_definition.chapter_definitions.map { |h| h.title }
  end

  def autocomplete_tcc_name
    term = params[:term]

    tcc_definition = TccDefinition.find(@tp.custom_params['tcc_definition'])
    show_graded_after = @tp.custom_params['show_graded_after']
    show_graded_before = @tp.custom_params['show_graded_before']
    tccs = tcc_searchable(tcc_definition, show_graded_after, show_graded_before)

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

  def tcc_searchable(tcc_definition, show_graded_after, show_graded_before)
    tccList = Tcc.includes(:student, chapters: [:chapter_definition]).
        where(tcc_definition_id: tcc_definition.id)

    show_graded_before = show_graded_before.nil? ? '' : show_graded_before.gsub('\'', '')
    show_graded_after = show_graded_after.nil? ? '': show_graded_after.gsub('\'', '')
    where = ''
    if  (!show_graded_before.empty? and !show_graded_after.empty? )
      where = "( grade_updated_at between ? and ? )"
      where = "grade_updated_at is null or #{where}"
      tccList = tccList.where(where, show_graded_after, show_graded_before)
    else
      if ( !show_graded_after.empty? )
        where += '( grade_updated_at > ?)'
        where = "grade_updated_at is null or #{where}"
        tccList = tccList.where(where, show_graded_after)
      elsif ( !show_graded_before.empty? )#or show_graded_after.empty?
        where += '( grade_updated_at < ? )'
        where = "grade_updated_at is null or #{where}"
        tccList = tccList.where(where, show_graded_before)
      end
    end
    policy_scope(tccList)
  end


end
