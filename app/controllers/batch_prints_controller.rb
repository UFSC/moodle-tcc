class BatchPrintsController < ApplicationController
  skip_before_action :get_tcc
  before_action :check_permission

  def index

    authorize(Tcc, :show_scope?)
    @current_moodle_user = current_moodle_user
    @tcc_definition = TccDefinition.includes(:chapter_definitions).find(@tp.custom_params['tcc_definition'])

    tccList = Tcc.includes(:student, :orientador, :abstract, :chapters).
                  joins(:student).
                  joins(:orientador).
                  where(tcc_definition_id: @tcc_definition.id).
                  where.not(orientador: nil).
                  order('orientadors_tccs.name, people.name')

    show_graded_before = @tp.custom_params['show_graded_before']
    show_graded_before = show_graded_before.nil? ? '' : show_graded_before.gsub('\'', '')

    show_graded_after = @tp.custom_params['show_graded_after']
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

    tccs = policy_scope(tccList)
    @tccs = tccs
  end

  def print
    authorize(Tcc, :show_scope?)
    @tcc_definition = TccDefinition.includes(:chapter_definitions).find(@tp.custom_params['tcc_definition'])
    arr_moodle_ids = params[:moodle_ids].split(',')
    if arr_moodle_ids.size > 0
      BatchTccsWorker.perform_async(arr_moodle_ids, @tp.lis_person_name_full, @tp.lis_person_contact_email_primary,
                                    @tcc_definition.pdf_link_hours)
      flash[:success] = "A impressão será enviada por e-mail para: #{@tp.lis_person_name_full} - #{@tp.lis_person_contact_email_primary}"
    else
      flash[:alert] = "Deve haver ao menos um TCC selecionado para a impressão!"
    end
    redirect_to batch_select_path

  end

  protected

  def check_permission
    unless current_user.view_all? || current_user.instructor?
      raise Authentication::UnauthorizedError, t('cannot_access_page_without_enough_permission')
      redirect_user_to_start_page
    end
  end

end