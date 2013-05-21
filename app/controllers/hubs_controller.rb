class HubsController < ApplicationController
  include LtiTccFilters

  def show
    set_tab ("hub"+params[:category]).to_sym
    if @tp.student?
      @hub = @tcc.hubs.find_or_initialize_by_category(params[:category])
    else
      @hub = @tcc.hubs.where(:category => params[:category]).first
    end

    unless @hub.nil?
      last_version = @hub.versions.last
      unless last_version.nil?
        unless last_version.comment.nil?
          @hub.comment = last_version.comment
        end
      end
      @old_hub = @hub.previous_version if @hub.versions.size > 1
      unless @old_hub.nil?
         @old_version =  @hub.versions[-2]
      end

      if @tp.student?
        get_hubs_diaries # search on moodle webserver
      else
        #@comment = @hub.comments.find_or_initialize_by_version_id(:version_id => @hub.versions.last.id)
      end
    else
      render :text =>  t(:hub_undefined)
    end
  end

  def save
    @tcc = Tcc.find_by_moodle_user(@user_id)
    unless params[:hub][:comment]
      @hub = @tcc.hubs.find_or_initialize_by_category(params[:hub][:category])
      @hub.attributes = params[:hub]
      if @hub.valid?

        case params[:hub][:new_state]
          when "draft"
            #does nothing
          when "revision"
            if @hub.may_send_to_tutor_for_revision?
               @hub.send_to_tutor_for_revision
            end
          when "evaluation"
            if @hub.may_send_to_tutor_for_evaluation?
               @hub.send_to_tutor_for_evaluation
            end
        end

        @hub.save
        flash[:success] = t(:successfully_saved)
        redirect_to show_hubs_path
      else
        render :show
      end
    else
      @hub = @tcc.hubs.find_or_initialize_by_category(params[:category])
      version = @hub.versions.last
      version.comment = params[:hub][:comment]
      version.save

      unless params[:hub][:grade].blank?
        if @hub.may_tutor_evaluate_ok?
          @hub.tutor_evaluate_ok
        end
      else @hub.may_send_back_to_student?
        @hub.send_back_to_student
      end

      if @hub.save
        redirect_to show_hubs_path(:category => @hub.category, :moodle_user => @user_id)
      end
    end
  end

  private

  def get_hubs_diaries
    @tcc.hubs.each do |hub|
      diaries_conf = TCC_CONFIG["hubs"][hub.category-1]["diaries"]
      diaries_conf.size.times do |i|
        set_diary(hub, i, diaries_conf[i]["id"], diaries_conf[i]["title"])
      end
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

  def get_online_text(user_id, assign_id)
    RestClient.post(TCC_CONFIG["server"],
                    :wsfunction => "local_wstcc_get_user_online_text_submission",
                    :userid => user_id, :assignid => assign_id,
                    :wstoken => TCC_CONFIG["token"]) { |response|
      if response.code == 200
        parser = Nori.new
        unless parser.parse(response)["RESPONSE"].nil?
          online_text = parser.parse(response)["RESPONSE"]["SINGLE"]["KEY"].first["VALUE"]
          if online_text["@null"].nil?
            online_text
          end
        end
      end
    }
  end
end
