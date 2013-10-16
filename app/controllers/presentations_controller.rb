# encoding: utf-8
class PresentationsController < ApplicationController
  include LtiTccFilters
  include StateMachineUtils


  def show
    @current_user = current_user
    set_tab :presentation
    @presentation = @tcc.presentation.nil? ? @tcc.build_presentation : @tcc.presentation
    @presentation.new_state = @presentation.aasm_current_state

    last_comment_version = @presentation.versions.where('state != ?', 'draft').last
    unless last_comment_version.nil?
      @last_presentation_commented = last_comment_version.reify
    end
  end

  def update_state
    @presentation = Presentation.find(params[:format])
    new_state = params[:presentation][:new_state]

    if change_state(new_state, @presentation)
      @presentation.save!
      flash[:success] = t(:successfully_saved)
    else
      flash[:error] = t(:invalid_state)
    end

    redirect_user_to_start_page
  end

  def save
    @tcc = Tcc.find_by_moodle_user(@user_id)
    @presentation= @tcc.presentation.nil? ? @tcc.build_presentation : @tcc.presentation
    new_state = params[:presentation][:new_state]

    unless params[:presentation][:commentary]
      @presentation.attributes = params[:presentation]
      if @presentation.valid?
        case new_state
          when 'sent_to_admin_for_revision'
            @presentation.send_to_admin_for_revision if @presentation.may_send_to_admin_for_revision?
          when 'sent_to_admin_for_evaluation'
            @presentation.send_to_admin_for_evaluation if @presentation.may_send_to_admin_for_evaluation?
          when 'draft'
            @presentation.send_to_draft if @presentation.may_send_to_draft?
        end

        @presentation.save
        flash[:success] = t(:successfully_saved)
        redirect_to save_presentation_path(moodle_user: @user_id)
      else
        render :show
      end
    else
      if params[:valued]
        @presentation.admin_evaluate_ok if @presentation.may_admin_evaluate_ok?
      else
        @presentation.send_back_to_student if @presentation.may_send_back_to_student?
      end

      if @presentation.update_attributes(params[:presentation])
        redirect_to save_presentation_path(moodle_user: @user_id)
      end
    end
  end
end
