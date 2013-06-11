class PresentationsController < ApplicationController
  include LtiTccFilters

  def show
    set_tab :presentation
    @presentation = @tcc.presentation.nil? ? @tcc.build_presentation : @tcc.presentation
    @presentation.new_state = "draft"

    last_comment_version = @presentation.versions.where('state != ?', "draft").last
    unless last_comment_version.nil?
      @last_presentation_commented = last_comment_version.reify
    end
  end

  def save
    @tcc = Tcc.find_by_moodle_user(@user_id)
    @presentation= @tcc.presentation.nil? ? @tcc.build_presentation: @tcc.presentation
    unless params[:presentation][:commentary]
      @presentation.attributes = params[:presentation]
      if @presentation.valid?
        case params[:presentation][:new_state]
          when "revision"
            if @presentation.may_send_to_admin_for_revision?
              @presentation.send_to_admin_for_revision
            end
          when "evaluation"
            if @presentation.may_send_to_admin_for_evaluation?
              @presentation.send_to_admin_for_evaluation
            end
        end
        @presentation.save
        flash[:success] = t(:successfully_saved)
        redirect_to save_presentation_path(:moodle_user => @user_id)
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
        redirect_to save_presentation_path(:moodle_user => @user_id)
      end
    end
  end
end
