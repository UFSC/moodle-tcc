class InternalInstitutionsController < ApplicationController
  inherit_resources

  autocomplete :internal_institution, :institution_name, :full => true

  skip_before_action :get_tcc
  before_action :check_permission

  def index
    @internal_institutions = InternalInstitution.search(params[:search], params[:page], { per: 7 })
  end

  def new
    @modal_title = t(:add_internal_institution)
    @internal_institution = InternalInstitution.new()

    respond_to do |format|
      format.html
    end
  end

  def create
    @internal_institution = InternalInstitution.new(params[:internal_institution])

    if @internal_institution.valid? && @internal_institution.save!
      flash[:success] = t(:successfully_saved)
      redirect_to internal_institutions_path()
    else
      flash[:error] = t(:please_fix_invalid_data)
      @modal_title = t(:add_internal_institution)
      render :new
    end
  end

  def edit
    @modal_title = t(:edit_internal_institution)
    @internal_institution = InternalInstitution.find(params[:id])
  end

  def update
    @internal_institution = InternalInstitution.find(params[:id])

    if @internal_institution.update_attributes(params[:internal_institution])
      flash[:success] = t(:successfully_saved)
      redirect_to internal_institutions_path()
    else
      flash[:error] = t(:please_fix_invalid_data)
      @modal_title = t(:edit_internal_institution)
      render :edit
    end
  end

  def destroy
    @internal_institution = InternalInstitution.find(params[:id])

    @internal_institution.destroy

    if @internal_institution.errors.any?
      flash[:error] = @internal_institution.errors.full_messages.join("\n")
      @internal_institutions = InternalInstitution.all
    else
      flash[:success] = t(:successfully_saved)
    end

    respond_to do |format|
      format.html { redirect_to(:back) }
      format.xml  { head :ok }
    end
  end

  private

  def internal_institution_params
    params.require(:internal_institution).permit(:institution_name)
  end

  protected

  def check_permission
    unless authorize(Tcc, :show_internal_institutions?)
      raise Authentication::UnauthorizedError, t('cannot_access_page_without_enough_permission')
      redirect_user_to_start_page
    end
  end
end

