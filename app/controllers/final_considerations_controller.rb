class FinalConsiderationsController < ApplicationController
  include LtiTccFilters

  def show
    set_tab :final_considerations
    @final_considerations = @tcc.final_considerations.nil? ? @tcc.build_final_considerations : @tcc.final_considerations
    @final_considerations.new_state = 'draft'

    last_comment_version = @final_considerations.versions.where('state != ?', 'draft').last
    unless last_comment_version.nil?
      @last_final_considerations_commented = last_comment_version.reify
    end
  end

  def save
    @tcc = Tcc.find_by_moodle_user(@user_id)
    @final_considerations= @tcc.final_considerations.nil? ? @tcc.build_final_considerations: @tcc.final_considerations
    unless params[:final_considerations][:commentary]
      @final_considerations.attributes = params[:final_considerations]
      if @final_considerations.valid?
        case params[:final_considerations][:new_state]
          when 'revision'
            if @final_considerations.may_send_to_admin_for_revision?
              @final_considerations.send_to_admin_for_revision
            end
          when 'evaluation'
            if @final_considerations.may_send_to_admin_for_evaluation?
              @final_considerations.send_to_admin_for_evaluation
            end
        end
        @final_considerations.save
        flash[:success] = t(:successfully_saved)
        redirect_to save_final_considerations_path(:moodle_user => @user_id)
      else
        render :show
      end
    else
      if params[:valued]
        @final_considerations.admin_evaluate_ok if @final_considerations.may_admin_evaluate_ok?
      else
        @final_considerations.send_back_to_student if @final_considerations.may_send_back_to_student?
      end

      if @final_considerations.update_attributes(params[:final_considerations])
        redirect_to save_final_considerations_path(:moodle_user => @user_id)
      end
    end
  end
end
