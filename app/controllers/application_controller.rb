class ApplicationController < ActionController::Base
  include Authentication
  include LtiTccFilters
  protect_from_forgery with: :exception

  # Set current_user as assetable
  def ckeditor_before_create_asset(asset)
    asset.assetable = @tcc
    return true
  end
end
