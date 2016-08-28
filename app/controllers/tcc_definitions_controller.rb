class TccDefinitionsController < ApplicationController

  skip_before_action :get_tcc
  before_action :check_permission

  def index
    set_title
    @tcc_definition = TccDefinition.includes(:chapter_definitions, :tccs).find(@tp.custom_params['tcc_definition'])
    render :edit
  end

  def edit
    set_title
    @tcc_definition = TccDefinition.includes(:chapter_definitions, :tccs).find(@tp.custom_params['tcc_definition'])
    if @tcc_definition.auto_save_minutes.nil?
      @tcc_definition.auto_save_minutes = 0
    end
  end

  def update
    set_title
    @tcc_definition = TccDefinition.includes(:chapter_definitions, :tccs).find(@tp.custom_params['tcc_definition'])
    params[:tcc_definition]['auto_save_minutes'] = 0 if (params[:tcc_definition]['auto_save_minutes'].nil? ||
        params[:tcc_definition]['auto_save_minutes'].empty?)
    if @tcc_definition.update_attributes(params[:tcc_definition])
      flash[:success] = t(:successfully_saved)
      redirect_to tcc_definitions_path
    else
      flash[:error] = t(:please_fix_invalid_data)
      render :edit
    end
  end

  private

  def set_title
    @modal_title = t(:'activerecord.models.tcc_definition')
  end

  protected

  def check_permission
    unless authorize(Tcc, :show_config?)
      raise Authentication::UnauthorizedError, t('cannot_access_page_without_enough_permission')
      redirect_user_to_start_page
    end
  end
end