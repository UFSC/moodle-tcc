class TccsController < ApplicationController
  if defined? ActionDispatch
    require 'oauth/request_proxy/rack_request'
    require 'action_dispatch/testing/test_process'
  else
    require 'oauth/request_proxy/action_controller_request'
    require 'action_controller/test_process'
  end

  require 'rest_client'

  #token = "c901357eacaf7f6861c762d7872a045f"
  #client = RestClient.get 'http://localhost/moodle/webservice/xmlrpc/server.php?wstoken='+token

  before_filter :authorize, :only => :index

  def index
      role =  @tp.to_params["roles"].split(",").first.downcase
      if role == 'instructor'
        redirect_to instructor_admin_tccs_path
      else
        unless @tcc = Tcc.find_by_moodle_user(@tp.context_id)
          @tcc = Tcc.new
        end

        @tcc.build_abstract if @tcc.abstract.nil?

        while @tcc.hubs.size < 3 do
          hub = @tcc.hubs.build
          hub.update_attributes(:category => @tcc.hubs.size)
        end

        get_hubs_diaries

        @tcc.build_bibliography if @tcc.bibliography.nil?
        @tcc.build_presentation if @tcc.presentation.nil?
        @tcc.build_final_considerations if @tcc.final_considerations.nil?
      end
  end

  def create
    @tcc = Tcc.new(params[:tcc])
    @tcc.moodle_user = session['launch_params']['context_id']
    if @tcc.save
      flash[:success] = t(:successfully_saved)
      render 'index'
    else
      render 'index'
    end
  end

  def update
    @tcc = Tcc.find(params[:id])
    if @tcc.update_attributes(params[:tcc])
      flash[:success] = t(:successfully_saved)
      render 'index'
    else
      render 'index'
    end
  end

  private

  def get_hubs_diaries
    @tcc.hubs.each do |hub|
      case hub.category
        when 1
          2.times do |i|
            diary = hub.diaries.build
            diary.content = "sem web service"
            diary.title = "Titulo do diario"
          end
        when 2
          3.times do
            diary = hub.diaries.build
            diary.content = "sem web service"
            diary.title = "Titulo do diario"
          end
        when 3
          3.times do
            diary = hub.diaries.build
            diary.content = "sem web service"
            diary.title = "Titulo do diario"
          end
      end
    end
    @tcc.save
  end


  # the consumer keys/secrets
  $consumer_key = "consumer_key"
  $consumer_secret = "consumer_secret"

  def authorize
    if params['oauth_consumer_key'] == $consumer_key
      @tp = IMS::LTI::ToolProvider.new($consumer_key, $consumer_secret, params)
      if @tp.valid_request?(request)
        session['launch_params'] = @tp.to_params
      else
        render file: 'public/500.html'
      end
    else
      render file: 'public/500.html'
    end
  end
end
