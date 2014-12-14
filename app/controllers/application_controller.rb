class ApplicationController < ActionController::Base
  include Authentication
  include LtiTccFilters
  include Pundit

  before_action :allow_iframe
  protect_from_forgery with: :exception

  rescue_from Authentication::UnauthorizedError, :with => :unauthorized_error
  rescue_from Authentication::PersonNotFoundError, :with => :person_not_found_error
  rescue_from Authentication::LTI::CredentialsError, :with => :lti_credentials_error
  rescue_from LtiTccFilters::TccNotFoundError, :with => :tcc_not_found_error
  rescue_from Pundit::NotAuthorizedError, :with => :user_not_authorized

  # Set current_user as assetable
  def ckeditor_before_create_asset(asset)
    asset.assetable = @tcc
    return true
  end

  def allow_iframe
    response.headers['X-Frame-Options'] = "ALLOW-FROM #{Settings.moodle_url}"
  end

  protected

  def lti_credentials_error(exception)
    @exception = exception

    respond_to do |format|
      format.html { render :template => 'errors/lti_credentials_error' }
      format.all  { render :nothing => true, :status => 403 }
    end
  end

  def person_not_found_error(exception)
    @exception = exception

    respond_to do |format|
      format.html { render :template => 'errors/person_not_found' }
      format.all  { render :nothing => true, :status => 404 }
    end
  end

  def tcc_not_found_error(exception)
    @exception = exception

    respond_to do |format|
      format.html { render :template => 'errors/tcc_not_found' }
      format.all  { render :nothing => true, :status => 403 }
    end
  end

  def unauthorized_error(exception)
    @exception = exception

    respond_to do |format|
      format.html { render :template => 'errors/unauthorized' }
      format.all  { render :nothing => true, :status => 403 }
    end
  end

  def user_not_authorized(exception)
    @exception = exception

    #flash[:error] = "You are not authorized to perform this action."
    #redirect_to(request.referrer || root_path)
    respond_to do |format|
      format.html { render :template => 'errors/unauthorized' }
      format.all  { render :nothing => true, :status => 403 }
    end
  end
end
