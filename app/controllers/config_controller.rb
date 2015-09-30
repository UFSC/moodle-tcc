class ConfigController < ApplicationController
  skip_before_action :get_tcc
  before_action :check_permission

  def index
    set_tab :internal_institutions
    redirect_to internal_institutions_path
  end

  protected

  def check_permission
    unless authorize(Tcc, :show_scope?)
      raise Authentication::UnauthorizedError, t('cannot_access_page_without_enough_permission')
      redirect_user_to_start_page
    end
  end

end
