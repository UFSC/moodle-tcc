# encoding: utf-8
class PresentationsController < ApplicationController

  def edit
    @current_user = current_user
    set_tab :presentation
    @presentation = @tcc.presentation.nil? ? @tcc.build_presentation : @tcc.presentation
    @presentation.new_state = @presentation.new? ? :draft : @presentation.aasm.current_state

    @last_commented = @presentation.last_useful_version

    # Se for estudante ele não deve conseguir ver as alterações do orientador enquanto ele não devolver ou aprovar
    if current_user.student? && (@presentation.sent_to_admin_for_revision? || @presentation.sent_to_admin_for_evaluation?)
      # Vamos exibir a ultima versão enviada ao invés da atual para que o estudante não veja as edições do orientador
      @presentation = @last_commented if @last_commented
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

    redirect_to edit_presentations_path(moodle_user: @user_id)
  end

  def update
    save
  end

  def create
    save
  end

  def save
    @tcc = Tcc.find_by_moodle_user(@user_id)
    @presentation= @tcc.presentation.nil? ? @tcc.build_presentation : @tcc.presentation

    unless params[:presentation][:commentary]
      @presentation.attributes = params[:presentation]
      new_state = params[:presentation][:new_state]

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
        redirect_to edit_presentations_path(moodle_user: @user_id)
      else
        render :edit
      end
    else
      if params[:valued] == 'Avaliado'
        @presentation.admin_evaluate_ok if @presentation.may_admin_evaluate_ok?
      elsif params[:valued] == 'Aprovar'
        change_state('admin_evaluation_ok', @presentation)
      elsif params[:draft]
        @presentation.send_back_to_student if @presentation.may_send_back_to_student?
      end

      if @presentation.update_attributes(params[:presentation])
        redirect_to edit_presentations_path(moodle_user: @user_id)
      else
        render :edit
      end
    end
  end
end
