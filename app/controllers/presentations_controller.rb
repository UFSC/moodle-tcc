class PresentationsController < ApplicationController
  include LtiTccFilters

  def show
    set_tab :presentation
    @presentation = @tcc.presentation.nil? ? @tcc.build_presentation : @tcc.presentation
  end

  def save
    @tcc = Tcc.find_by_moodle_user(@user_id)
    @presentation = @tcc.presentation.nil? ? @tcc.build_presentation : @tcc.presentation
    if @presentation.update_attributes(params[:presentation])
      flash[:success] = t(:successfully_saved)
    end
    redirect_to show_presentation_path
  end
end
