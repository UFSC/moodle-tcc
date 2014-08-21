class ApplicationController < ActionController::Base
  include Authentication
  include LtiTccFilters
  protect_from_forgery with: :exception
  before_action :allow_iframe

  # Set current_user as assetable
  def ckeditor_before_create_asset(asset)
    asset.assetable = @tcc
    return true
  end

  def allow_iframe
    response.headers['X-Frame-Options'] = "ALLOW-FROM #{Settings.moodle_url}"
  end
end
