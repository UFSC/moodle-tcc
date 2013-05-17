class FinalConsiderationsController < ApplicationController
  include LtiTccFilters

  def show
    set_tab :final_considerations
    @final_considerations = @tcc.final_considerations.nil? ? @tcc.build_final_considerations : @tcc.final_considerations
  end

  def save
    @tcc = Tcc.find_by_moodle_user(@user_id)
    @final_considerations = @tcc.final_considerations.nil? ? @tcc.build_final_considerations : @tcc.final_considerations
    if @final_considerations.update_attributes(params[:final_considerations])
      flash[:success] = t(:successfully_saved)
    end
    redirect_to show_final_considerations_path
  end
end
