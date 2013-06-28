# encoding: utf-8
class HubsController < ApplicationController

  include LtiTccFilters

  def show
    set_tab ('hub'+params[:category]).to_sym

    # Verifica se o hub é um hab válido
    category = params[:category].to_i
    unless category.between?(1, TCC_CONFIG['hubs'].count)
      return render :text => t(:hub_undefined), :status => 500
    end

    @hub = @tcc.hubs.find_or_initialize_by_category(params[:category])

    last_comment_version = @hub.versions.where('state != ?', 'draft').last

    @last_hub_commented = last_comment_version.reify unless last_comment_version.nil?

    # Busca diários no moodle
    @hub.fetch_diaries(@user_id)
  end

  def save
    @tcc = Tcc.find_by_moodle_user(@user_id)
    new_state = params[:hub][:new_state]

    @hub = @tcc.hubs.find_or_initialize_by_category(params[:hub][:category])
    @hub.attributes = params[:hub]

    #
    # Estudante
    #
    if @tp.student?

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
        return redirect_to show_hubs_path(:category => @hub.category, :moodle_user => @user_id)

      else
        @hub.state = old_state
      end
    end

    render :show
  end
end
