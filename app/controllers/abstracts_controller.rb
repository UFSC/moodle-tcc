class AbstractsController < ApplicationController
  include LtiTccFilters

  def show
    set_tab :abstract
    @abstract = @tcc.abstract.nil? ? @tcc.build_abstract : @tcc.abstract
    @abstract.new_state = "draft"
  end

  def save
    @tcc = Tcc.find_by_moodle_user(@user_id)
    @abstract = @tcc.abstract.nil? ? @tcc.build_abstract : @tcc.abstract
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
      redirect_to save_abstract_path
    end
  end
end
