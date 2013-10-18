# encoding: utf-8
class FinalConsiderationsController < ApplicationController
  include LtiTccFilters
  include StateMachineUtils


  def show
    @current_user = current_user
    set_tab :final_considerations
    @final_considerations = @tcc.final_considerations.nil? ? @tcc.build_final_considerations : @tcc.final_considerations
    @final_considerations.new_state = @final_considerations.aasm_current_state

    last_comment_version = @final_considerations.versions.where('state != ?', 'draft').last
    unless last_comment_version.nil?
      @last_final_considerations_commented = last_comment_version.reify
    end
  end

  def update_state
    @final_consideration = FinalConsiderations.find(params[:format])
    new_state = params[:final_considerations][:new_state]

    if change_state(new_state, @final_consideration)
      @final_consideration.save!
      flash[:success] = t(:successfully_saved)
    else
      flash[:error] = t(:invalid_state)
    end

    redirect_user_to_start_page
  end

  def save
    @tcc = Tcc.find_by_moodle_user(@user_id)
    @final_considerations = @tcc.final_considerations.nil? ? @tcc.build_final_considerations : @tcc.final_considerations
    new_state = params[:final_considerations][:new_state]

    unless params[:final_considerations][:commentary]
      @final_considerations.attributes = params[:final_considerations]
      if @final_considerations.valid?
        case new_state
          when 'sent_to_admin_for_revision'
            @final_considerations.send_to_admin_for_revision if @final_considerations.may_send_to_admin_for_revision?
          when 'sent_to_admin_for_evaluation'
            @final_considerations.send_to_admin_for_evaluation if @final_considerations.may_send_to_admin_for_evaluation?
          when 'draft'
            @final_considerations.send_to_draft if @final_considerations.may_send_to_draft?
        end

        @final_considerations.save
        flash[:success] = t(:successfully_saved)
        redirect_to save_final_considerations_path(moodle_user: @user_id)
      else
        render :show
      end
    else
      if params[:valued] == 'Avaliado'
        @final_considerations.admin_evaluate_ok if @final_considerations.may_admin_evaluate_ok?
      elsif params[:valued] == 'Aprovar'
        change_state('admin_evaluate_ok', @final_considerations)
      else
        @final_considerations.send_back_to_student if @final_considerations.may_send_back_to_student?
      end

      if @final_considerations.update_attributes(params[:final_considerations])
        redirect_to save_final_considerations_path(moodle_user: @user_id)
      end
    end
  end
end
