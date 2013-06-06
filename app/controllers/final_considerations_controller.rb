class FinalConsiderationsController < ApplicationController
  include LtiTccFilters

  def show
    set_tab :final_considerations
    @final_considerations = @tcc.final_considerations.nil? ? @tcc.build_final_considerations : @tcc.final_considerations
    @final_considerations.new_state = "draft"
  end

  def save
    @tcc = Tcc.find_by_moodle_user(@user_id)
    @final_considerations = @tcc.final_considerations.nil? ? @tcc.build_final_considerations : @tcc.final_considerations
    @final_considerations.attributes = params[:final_considerations]
    if @final_considerations.valid?
      case params[:final_considerations][:new_state]
        when "revision"
          if @final_considerations.may_send_to_leader_for_revision?
            @final_considerations.send_to_leader_for_revision
          end
        when "evaluation"
          if @final_considerations.may_send_to_leader_for_evaluation?
            @final_considerations.send_to_leader_for_evaluation
          end
      end
      @final_considerations.save
      flash[:success] = t(:successfully_saved)
      redirect_to save_final_considerations_path
    end
  end
end
