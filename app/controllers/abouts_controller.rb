class AboutsController < ApplicationController
  skip_before_action :get_tcc
  before_action :check_permission

  # GET /abouts
  def index
    About.reset
    @about = About.all
  end

  protected

  def check_permission
    unless authorize(Tcc, :show_config?)
      raise Authentication::UnauthorizedError, t('cannot_access_page_without_enough_permission')
      redirect_user_to_start_page
    end
  end
end
