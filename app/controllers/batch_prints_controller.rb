class BatchPrintsController < ApplicationController
  skip_before_action :get_tcc
  before_action :check_permission

  def index
    authorize(Tcc, :show_scope?)
    @current_moodle_user = current_moodle_user
    @tcc_definition = TccDefinition.includes(:chapter_definitions).find(@tp.custom_params['tcc_definition'])
    tccList = Tcc.includes(:student,:orientador).
                  joins(:student).
                  joins(:orientador).
                  where(tcc_definition_id: @tcc_definition.id).
                  where.not(orientador: nil).
                  #where.not(grade: nil).
                  order('orientadors_tccs.name, people.name')
    tccs = policy_scope(tccList)
    @tccs = tccs
  end

  def print
    authorize(Tcc, :show_scope?)
    arr_moodle_ids = params[:moodle_ids].split(';')
    puts("size = #{arr_moodle_ids.size}")
    if arr_moodle_ids.size > 0
      Test2Worker.perform_async(arr_moodle_ids, @tp.lis_person_name_full, @tp.lis_person_contact_email_primary)
      flash[:success] = "A impressão será enviada por e-mail para: #{@tp.lis_person_name_full} - #{@tp.lis_person_contact_email_primary}"
    else
      flash[:alert] = "Deve haver ao menos um TCC slecionado para a impressão!"
    end
    redirect_to batch_select_path

  end

  protected

  def check_permission
    unless current_user.view_all? || current_user.instructor?
      true
      raise Authentication::UnauthorizedError, t('cannot_access_page_without_enough_permission')
      redirect_user_to_start_page
    end
  end

end