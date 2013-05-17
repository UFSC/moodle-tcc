class AbstractsController < ApplicationController
  include LtiTccFilters

  def show
    set_tab :abstract
    @abstract = @tcc.abstract.nil? ? @tcc.build_abstract : @tcc.abstract
  end

  def save
    @tcc = Tcc.find_by_moodle_user(@user_id)
    @abstract = @tcc.abstract.nil? ? @tcc.build_abstract : @tcc.abstract
    if @abstract.update_attributes(params[:abstract])
      flash[:success] = t(:successfully_saved)
    end
    redirect_to show_abstract_path
  end
end
