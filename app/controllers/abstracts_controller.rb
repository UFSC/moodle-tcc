# encoding: utf-8
class AbstractsController < ApplicationController
  include LtiTccFilters
  include StateMachineUtils


  def show
    @current_user = current_user
    set_tab :abstract
    @abstract = @tcc.abstract.nil? ? @tcc.build_abstract : @tcc.abstract
    @abstract.new_state = @abstract.aasm_current_state

    last_draft_version = @abstract.versions.where('state = ?', 'draft').last
    unless last_draft_version.nil?
      @last_abstract_commented = last_draft_version.reify.next_version unless last_draft_version.nil?
    end

    if current_user.student? && !@abstract.draft? && !@abstract.new? && !@last_abstract_commented.nil?
      @abstract = @last_abstract_commented
    elsif((current_user.student? && @abstract.draft?)|| (!current_user.student? && @abstract.draft?))
      @last_abstract_commented = @abstract.versions.where('state = ? OR state = ?', 'sent_to_admin_for_evaluation', 'sent_to_admin_for_revision').last.reify
    end
  end

  def update_state
    @abstract = Abstract.find(params[:format])
    new_state = params[:abstract][:new_state]

    if change_state(new_state, @abstract)
      @abstract.save!
      flash[:success] = t(:successfully_saved)
    else
      flash[:error] = t(:invalid_state)
    end

    redirect_user_to_start_page
  end

  def save
    @tcc = Tcc.find_by_moodle_user(@user_id)
    @abstract = @tcc.abstract.nil? ? @tcc.build_abstract : @tcc.abstract
    new_state = params[:abstract][:new_state]

    unless params[:abstract][:commentary]
      @abstract.attributes = params[:abstract]
      if @abstract.valid?
        case new_state
          when 'sent_to_admin_for_revision'
            @abstract.send_to_admin_for_revision if @abstract.may_send_to_admin_for_revision?
          when 'sent_to_admin_for_evaluation'
            @abstract.send_to_admin_for_evaluation if @abstract.may_send_to_admin_for_evaluation?
          when 'draft'
            @abstract.send_to_draft if @abstract.may_send_to_draft?
        end

        @abstract.save
        flash[:success] = t(:successfully_saved)
        redirect_to save_abstract_path(moodle_user: @user_id)
      else
        render :show
      end
    else
      if params[:valued]
        @abstract.admin_evaluate_ok if @abstract.may_admin_evaluate_ok?
      elsif params[:draft]
        @abstract.send_back_to_student if @abstract.may_send_back_to_student?
      end

      if @abstract.update_attributes(params[:abstract])
        redirect_to save_abstract_path(moodle_user: @user_id)
      end
    end
  end
end
