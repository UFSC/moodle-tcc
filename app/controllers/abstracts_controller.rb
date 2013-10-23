# encoding: utf-8
class AbstractsController < ApplicationController
  include LtiTccFilters
  include StateMachineUtils


  def show
    @current_user = current_user
    set_tab :abstract
    @abstract = @tcc.abstract.nil? ? @tcc.build_abstract : @tcc.abstract
    @abstract.new_state = @abstract.aasm_current_state

    last_comment_version = @abstract.versions.where('state != ?', 'draft').last
    unless last_comment_version.nil?
      @last_abstract_commented = last_comment_version.reify
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
      if params[:valued] == 'Avaliado'
        @abstract.admin_evaluate_ok if @abstract.may_admin_evaluate_ok?
      elsif params[:valued] == 'Aprovar'
        change_state('admin_evaluation_ok', @abstract)
      else
        @abstract.send_back_to_student if @abstract.may_send_back_to_student?
      end

      if @abstract.update_attributes(params[:abstract])
        redirect_to save_abstract_path(moodle_user: @user_id)
      end
    end
  end
end
