class PresentationsController < ApplicationController
  include LtiTccFilters

  def show
    set_tab :presentation
    @presentation = @tcc.presentation.nil? ? @tcc.build_presentation : @tcc.presentation
    @presentation.new_state = "draft"
  end

  def save
    @tcc = Tcc.find_by_moodle_user(@user_id)
    @presentation = @tcc.presentation.nil? ? @tcc.build_presentation : @tcc.presentation
    @presentation.attributes = params[:presentation]
    if @presentation.valid?
      case params[:presentation][:new_state]
        when "revision"
          if @presentation.may_send_to_leader_for_revision?
            @presentation.send_to_leader_for_revision
          end
        when "evaluation"
          if @presentation.may_send_to_leader_for_evaluation?
            @presentation.send_to_leader_for_evaluation
          end
      end
      @presentation.save
      flash[:success] = t(:successfully_saved)
      redirect_to save_presentation_path
    end
  end
end
