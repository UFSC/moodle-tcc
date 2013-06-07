class AbstractsController < ApplicationController
  include LtiTccFilters

  def show
    set_tab :abstract
    @abstract = @tcc.abstract.nil? ? @tcc.build_abstract : @tcc.abstract
    @abstract.new_state = "draft"

    last_comment_version = @abstract.versions.where('state != ?', "draft").last
    unless last_comment_version.nil?
      @last_abstract_commented = last_comment_version.reify
    end
  end

  def save
    @tcc = Tcc.find_by_moodle_user(@user_id)
    @abstract = @tcc.abstract.nil? ? @tcc.build_abstract : @tcc.abstract
    unless params[:abstract][:commentary]
      @abstract.attributes = params[:abstract]
      if @abstract.valid?
        case params[:abstract][:new_state]
          when "revision"
            if @abstract.may_send_to_leader_for_revision?
              @abstract.send_to_leader_for_revision
            end
          when "evaluation"
            if @abstract.may_send_to_leader_for_evaluation?
              @abstract.send_to_leader_for_evaluation
            end
        end
        @abstract.save
        flash[:success] = t(:successfully_saved)
        redirect_to save_abstract_path(:moodle_user => @user_id)
      else
        render :show
      end
    else
      if params[:valued]
        @abstract.leader_evaluate_ok if @abstract.may_leader_evaluate_ok?
      else
        @abstract.send_back_to_student if @abstract.may_send_back_to_student?
      end

      if @abstract.update_attributes(params[:abstract])
        redirect_to save_abstract_path(:moodle_user => @user_id)
      end
    end
  end
end
