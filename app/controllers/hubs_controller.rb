# encoding: utf-8
class HubsController < ApplicationController

  include LtiTccFilters

  def show
    set_tab ("hub"+params[:category]).to_sym

    if @tp.student?
      @hub = @tcc.hubs.find_or_initialize_by_category(params[:category])
      @hub.new_state = @hub.aasm_current_state
    else
      @hub = @tcc.hubs.find_or_initialize_by_category(params[:category])
      @hub.new_state = @hub.aasm_current_state
    end

    unless @hub.nil?
      last_comment_version = @hub.versions.where('state != ?', "draft").last

      @last_hub_commented = last_comment_version.reify unless last_comment_version.nil?

      last_version = @hub.versions.last
      unless last_version.nil?
        @hub.comment = last_version.comment unless last_version.comment.nil?
      end

      get_hub_diaries(@hub) # search on moodle webserver
    else
      render :text => t(:hub_undefined)
    end
  end

  def save
    @tcc = Tcc.find_by_moodle_user(@user_id)
    unless params[:hub][:commentary]
      @hub = @tcc.hubs.find_or_initialize_by_category(params[:hub][:category])
      @hub.attributes = params[:hub]
      if @hub.valid?
        case params[:hub][:new_state]
          when "revision"
            @hub.send_to_admin_for_revision if @hub.may_send_to_admin_for_revision?
          when "evaluation"
            @hub.send_to_admin_for_evaluation if @hub.may_send_to_admin_for_evaluation?
        end
        @hub.save
        flash[:success] = t(:successfully_saved)
        redirect_to show_hubs_path
      else
        render :show
      end
    else
      @hub = @tcc.hubs.find_or_initialize_by_category(params[:category])
      if params[:valued]
        @hub.admin_evaluate_ok if @hub.may_admin_evaluate_ok?
      else
        @hub.send_back_to_student if @hub.may_send_back_to_student?
      end

      if @hub.update_attributes(params[:hub])
        redirect_to show_hubs_path(:category => @hub.category, :moodle_user => @user_id)
      end
    end
  end

  private

  def get_hub_diaries(hub)
    diaries_conf = TCC_CONFIG["hubs"][hub.category-1]["diaries"]
    diaries_conf.size.times do |i|
      set_diary(hub, i, diaries_conf[i]["id"], diaries_conf[i]["title"])
    end
  end

  def set_diary(hub, i, content_id, title)
    unless diary = hub.diaries.find_by_pos(i)
      diary = hub.diaries.build
    end
    online_text = get_online_text(@user_id, content_id)
    diary.content = online_text unless online_text.nil?
    diary.title = title
    diary.pos = i
  end

  def get_online_text(user_id, coursemodule_id)
    logger.debug "[WS Moodle] Acessando Web Service: user_id=#{user_id}, coursemodule_id=#{coursemodule_id}"
    RestClient.post(TCC_CONFIG["server"],
                    :wsfunction => "local_wstcc_get_user_online_text_submission",
                    :userid => user_id, :coursemoduleid => coursemodule_id,
                    :wstoken => TCC_CONFIG["token"]) do |response|

      logger.debug "[WS Moodle] resposta: #{response.code} #{response.inspect}"

      if response.code != 200
        logger.error "Falha ao acessar o webservice do Moodle: HTTP_ERROR: #{response.code}"
        return "Falha ao acessar o Moodle: (HTTP_ERROR: #{response.code})"
      end

      # Utiliza Nokogiri como parser XML
      doc = Nokogiri.parse(response)

      # Verifica se ocorreu algum problema com o acesso
      if !doc.xpath('/EXCEPTION').blank?


        error_code = doc.xpath('/EXCEPTION/ERRORCODE').text
        error_message = doc.xpath('/EXCEPTION/MESSAGE').text
        debug_info = doc.xpath('/EXCEPTION/DEBUGINFO').text

        logger.error "Falha ao acessar o webservice do Moodle: #{error_message} (ERROR_CODE: #{error_code}) - #{debug_info}"
        return "Falha ao acessar o Moodle: #{error_message} (ERROR_CODE: #{error_code})"
      end

      # Recupera o conteúdo do texto online
      online_text = doc.xpath('/RESPONSE/SINGLE/KEY[@name="onlinetext"]/VALUE').text

    end
  end
end
