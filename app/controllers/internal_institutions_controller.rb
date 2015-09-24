require 'mini_magick'

class InternalInstitutionsController < InheritedResources::Base
  skip_before_action :get_tcc
  before_action :check_permission


  # validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def index
    @internal_institutions = InternalInstitution.all
  end

  def new
    # authorize(Tcc, :show_compound_names?)

    @modal_title = t(:add_internal_institution)
    @internal_institution = InternalInstitution.new()

    respond_to do |format|
      format.js
    end
  end

  def create
    # authorize(Tcc, :show_compound_names?)
    internal_institution = InternalInstitution.new(params[:internal_institution])

    if internal_institution.save
      flash[:success] = t(:successfully_saved)
    end

    redirect_to internal_institutions_path(moodle_user: params[:moodle_user], anchor: 'internal_institutions')
  end

  def edit
    @modal_title = t(:edit_internal_institution)
    @internal_institution = InternalInstitution.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    #authorize(Tcc, :show_compound_names?)
    internal_institution = InternalInstitution.find(params[:id])

    if internal_institution.update_attributes(params[:internal_institution])
      flash[:success] = t(:successfully_saved)
    end

    redirect_to internal_institutions_path(moodle_user: params[:moodle_user])
  end

  # BLOB
  # def show_avatar
  #   @internal_institution = InternalInstitution.find(params[:id])
  #   logo = @internal_institution.institution_logo
  #   send_data logo, :type => 'image/png',:disposition => 'inline'
  # end

  private

  def internal_institution_params
    params.require(:internal_institution).permit(:institution_name)
  end

  protected

  def check_permission
    unless current_user.view_all? || current_user.instructor?
      raise Authentication::UnauthorizedError, t('cannot_access_page_without_enough_permission')
      redirect_user_to_start_page
    end
  end


end

