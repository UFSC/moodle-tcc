class TccDefinitionsController < ApplicationController
  inherit_resources

  skip_before_action :get_tcc
  before_action :check_permission

  def index
    @tcc_definition = TccDefinition.includes(:chapter_definitions).find(@tp.custom_params['tcc_definition'])
  end

  def edit
    @modal_title = t(:'activerecord.models.tcc_definition')
    @tcc_definition = TccDefinition.includes(:chapter_definitions).find(@tp.custom_params['tcc_definition'])
  end

  def update
    @modal_title = t(:'activerecord.models.tcc_definition')
    @tcc_definition = TccDefinition.includes(:chapter_definitions).find(@tp.custom_params['tcc_definition'])

    if @tcc_definition.update_attributes(params[:tcc_definition])
      flash[:success] = t(:successfully_saved)
      redirect_to tcc_definitions_path
    else
      flash[:error] = t(:please_fix_invalid_data)
      @modal_title = t(:edit_internal_institution)
      render :edit
    end
  end

  protected

  def check_permission
    unless authorize(Tcc, :show_config?)
      raise Authentication::UnauthorizedError, t('cannot_access_page_without_enough_permission')
      redirect_user_to_start_page
    end
  end
end