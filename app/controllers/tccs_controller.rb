class TccsController < ApplicationController
  before_filter :authorize, :only => [:show, :update]
  before_filter :get_tcc, :only => :show

  def show
    set_tab_view

    @tcc.build_abstract if @tcc.abstract.nil?

    while @tcc.hubs.size < TCC_CONFIG["hubs"].size do
      @tcc.hubs.build(:category => @tcc.hubs.size+1)
    end
    i = 0
    @hubs = Array.new
    @tcc.hubs.each{ |h|
      @hubs[i] = h
      i = i+1
    }

    get_hubs_diaries # search on moodle webserver

    @tcc.build_bibliography if @tcc.bibliography.nil?
    @tcc.build_presentation if @tcc.presentation.nil?
    @tcc.build_final_considerations if @tcc.final_considerations.nil?
  end

  def update
    @tcc = Tcc.find_by_moodle_user(@user_id)
    puts params[:tcc]
    if @tcc.update_attributes(params[:tcc])
      flash[:success] = t(:successfully_saved)
    end
    redirect_to tcc_path
  end

  private

  def get_hubs_diaries
    @tcc.hubs.each do |hub|
      diaries = TCC_CONFIG["hubs"][hub.category-1]["diaries"]
      diaries.size.times do |i|
        set_diary(hub, i, diaries[i]["id"], diaries[i]["title"])
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

  def authorize
    lti_params = session['lti_launch_params']

    if lti_params.nil?
      logger.error 'Access Denied: LTI not initialized'
      redirect_to access_denied_path
    else
      @tp = IMS::LTI::ToolProvider.new(TCC_CONFIG["consumer_key"], TCC_CONFIG["consumer_secret"], lti_params)
      if @tp.instructor?
         @user_id = params["moodle_user"]
      else
         @user_id = @tp.user_id
      end

      logger.debug "Recovering LTI TP for: '#{@tp.roles}' "
    end
  end

  def get_tcc
    unless @tcc = Tcc.find_by_moodle_user(@user_id)
      @tcc = Tcc.create( :moodle_user => @user_id )
    end
  end

  def set_tab_view
    if params[:tab].blank?
      set_tab "data".to_sym
    elsif params[:tab] == "hub"
      @hub = true
      @category = params[:category].to_i
      set_tab (params[:tab]+params[:category]).to_sym
    else
      set_tab params[:tab].to_sym
    end
  end
end
