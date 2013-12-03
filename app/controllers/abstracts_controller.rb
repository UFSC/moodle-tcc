# encoding: utf-8
class AbstractsController < ApplicationController
  include StateMachineUtils


  def edit
    @current_user = current_user
    set_tab :abstract
    @abstract = @tcc.abstract.nil? ? @tcc.build_abstract : @tcc.abstract
    @abstract.new_state = @abstract.new? ? :draft : @abstract.aasm_current_state

    @last_commented = @abstract.last_useful_version

    # Se for estudante ele não deve conseguir ver as alterações do orientador enquanto ele não devolver ou aprovar
    if current_user.student? && (@abstract.sent_to_admin_for_revision? || @abstract.sent_to_admin_for_evaluation?)
      # Vamos exibir a ultima versão enviada ao invés da atual para que o estudante não veja as edições do orientador
      @abstract = @last_commented if @last_commented
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

    redirect_to  edit_abstracts_path(@abstract, moodle_user: params[:moodle_user])
  end

  def update
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
        redirect_to edit_abstracts_path(moodle_user: @user_id)
      else
        render :edit
      end
    else
      if params[:valued] == 'Avaliado'
        @abstract.admin_evaluate_ok if @abstract.may_admin_evaluate_ok?
      elsif params[:valued] == 'Aprovar'
        change_state('admin_evaluation_ok', @abstract)
      elsif params[:draft]
        @abstract.send_back_to_student if @abstract.may_send_back_to_student?
      end

      if @abstract.update_attributes(params[:abstract])
        redirect_to edit_abstracts_path(moodle_user: @user_id)
      end
    end
  end
end
