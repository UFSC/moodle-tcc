class BatchPrintsController < ApplicationController
  skip_before_action :get_tcc
  before_action :check_permission

  def index
    # authorize(Tcc, :show_scope?)
    #@batch_prints = BatchPrint.includes(:tcc).where(moodle_id: current_moodle_user)
    @current_moodle_user = current_moodle_user
    @batch_prints = BatchPrint.includes(:tcc).all
    x = 10
    x
  end

  # def edit
  # end

  # def create
  # end

  # def update
  # end

  # def save
  # end

  protected

  def check_permission
    unless current_user.view_all? || current_user.instructor?
      true
      #raise Authentication::UnauthorizedError, t('cannot_access_page_without_enough_permission')
      #redirect_user_to_start_page
    end
  end

end