# encoding: utf-8
class HubsController < ApplicationController

  include LtiTccFilters

  def show
    @current_user = current_user
    set_tab ('hub'+params[:position]).to_sym

    @hub = @tcc.hubs.find_by_position(params[:position])

    last_comment_version = @hub.versions.where('state != ?', 'draft').last

    @last_hub_commented = last_comment_version.reify unless last_comment_version.nil?
    @hub.new_state = @hub.aasm_current_state

    # Busca diários no moodle
    @hub.fetch_diaries(@user_id)
  end

  def save
    @tcc = Tcc.find_by_moodle_user(@user_id)
    new_state = params[:hub][:new_state]

    @hub = @tcc.hubs.find_by_position(params[:hub][:position])
    @hub.attributes = params[:hub]

    #
    # Estudante
    #
    if current_user.student?

      if @hub.valid?
        case new_state
          when 'revision'
            @hub.send_to_admin_for_revision if @hub.may_send_to_admin_for_revision?
          when 'evaluation'
            @hub.send_to_admin_for_evaluation if @hub.may_send_to_admin_for_evaluation?
        end

        @hub.save
        flash[:success] = t(:successfully_saved)
        return redirect_to show_hubs_path
      end
    else


      #
      # TUTOR
      #

      # Ação do botão
      old_state = @hub.state

      if params[:valued]
        @hub.admin_evaluate_ok if @hub.may_admin_evaluate_ok?
      else
        @hub.send_back_to_student if @hub.may_send_back_to_student?
      end

      if @hub.valid? && @hub.save
        return redirect_to show_hubs_path(:position => @hub.position, :moodle_user => @user_id)

      else
        @hub.state = old_state
      end
    end

    render :show
  end

  def update_state
    @tcc = Tcc.find_by_moodle_user(params[:moodle_user])

    @hub = @tcc.hubs.find_by_position(params[:position])

    if params[:hub][:new_state] == 'admin_evaluation_ok' && @hub.grade.nil?
      flash[:error] = 'Não é possível alterar para este estado sem ter dado uma nota.'
      return redirect_to instructor_admin_tccs_path
    end

    case params[:hub][:new_state]
      when 'draft'
        to_draft(@hub)
      when 'sent_to_admin_for_revision'
        to_revision(@hub)
      when 'sent_to_admin_for_evaluation'
        to_evaluation(@hub)
      else
        to_evaluation_ok(@hub)
    end

    @hub.save!
    flash[:success] = t(:successfully_saved)
    redirect_to instructor_admin_tccs_path
  end

  private

  def to_draft(hub)
    case hub.aasm_current_state
      when :draft
        # ta certo
      when :sent_to_admin_for_revision
        hub.send_back_to_student
      when :sent_to_admin_for_evaluation
        hub.send_back_to_student
    end
  end

  def to_revision(hub)
    case hub.aasm_current_state
      when :draft
        hub.send_to_admin_for_revision
    end
  end

  def to_evaluation(hub)
    case hub.aasm_current_state
      when :draft
        hub.send_to_admin_for_evaluation
    end
  end

  def to_evaluation_ok(hub)
    case hub.aasm_current_state
      when :draft
        hub.send_to_admin_for_evaluation
        hub.admin_evaluate_ok
      when :send_to_admin_for_revision
        hub.admin_evaluate_ok
      when :sent_to_admin_for_evaluation
        hub.admin_evaluate_ok
    end
  end
end
