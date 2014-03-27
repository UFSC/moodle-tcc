# encoding: utf-8
class FinalConsiderationsController < ApplicationController
  include StateMachineUtils


  def edit
    @current_user = current_user
    set_tab :final_considerations
    @final_considerations = @tcc.final_considerations.nil? ? @tcc.build_final_considerations : @tcc.final_considerations
    @final_considerations.new_state = @final_considerations.new? ? :draft : @final_considerations.aasm.current_state

    @last_commented = @final_considerations.last_useful_version

    # Se for estudante ele não deve conseguir ver as alterações do orientador enquanto ele não devolver ou aprovar
    if current_user.student? && (@final_considerations.sent_to_admin_for_revision? || @final_considerations.sent_to_admin_for_evaluation?)
      # Vamos exibir a ultima versão enviada ao invés da atual para que o estudante não veja as edições do orientador
      @final_considerations = @last_commented if @last_commented
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

    redirect_to  edit_final_considerations_path(moodle_user: params[:moodle_user])
  end

  def update
    save
  end

  def create
    save
  end

  def save
    @tcc = Tcc.find_by_moodle_user(@user_id)
    @final_considerations = @tcc.final_considerations.nil? ? @tcc.build_final_considerations : @tcc.final_considerations

    unless params[:final_considerations][:commentary]
      @final_considerations.attributes = params[:final_considerations]
      new_state = params[:final_considerations][:new_state]

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
        redirect_to edit_final_considerations_path(moodle_user: @user_id)
      else
        render :edit
      end
    else
      if params[:valued] == 'Avaliado'
        @final_considerations.admin_evaluate_ok if @final_considerations.may_admin_evaluate_ok?
      elsif params[:valued] == 'Aprovar'
        change_state('admin_evaluation_ok', @final_considerations)
      elsif params[:draft]
        @final_considerations.send_back_to_student if @final_considerations.may_send_back_to_student?
      end

      if @final_considerations.update_attributes(params[:final_considerations])
        redirect_to edit_final_considerations_path(moodle_user: @user_id)
      else
        render :edit
      end
    end
  end
end
