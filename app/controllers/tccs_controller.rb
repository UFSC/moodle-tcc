class TccsController < ApplicationController
  include LtiTccFilters

  def show
    puts "gggggggggggggggggggggggggg"
    set_tab :data
  end

  def save
    @tcc = Tcc.find_by_moodle_user(@user_id)
    if @tcc.update_attributes(params[:tcc])
      flash[:success] = t(:successfully_saved)
    end
    redirect_to show_tcc_path
  end
end
