class HubsController < ApplicationController
  include LtiTccFilters

  def show
    set_tab ("hub"+params[:category]).to_sym

    @hub = @tcc.hubs.find_or_initialize_by_category(params[:category])
    get_hubs_diaries # search on moodle webserver
  end

  def save
    @tcc = Tcc.find_by_moodle_user(@user_id)
    @hub = @tcc.hubs.find_or_initialize_by_category(params[:hub][:category])
    if @hub.update_attributes(params[:hub])
      flash[:success] = t(:successfully_saved)
    end
    redirect_to show_hubs_path
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
