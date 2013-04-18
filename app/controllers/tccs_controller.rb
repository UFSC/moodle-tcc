class TccsController < ApplicationController
  if defined? ActionDispatch
    require 'oauth/request_proxy/rack_request'
    require 'action_dispatch/testing/test_process'
  else
    require 'oauth/request_proxy/action_controller_request'
    require 'action_controller/test_process'
  end

  before_filter :authorize, :only => :index

  def index
      role =  @tp.to_params["roles"].split(",").first.downcase
      if role == 'instructor'
        redirect_to '/instructor_admin_tccs'
      else
        unless @tcc = Tcc.find_by_moodle_user(@tp.context_id)
          @tcc = Tcc.new
        end
        render 'index'
      end
  end


  def create
    @tcc = Tcc.new(params[:tcc])
    @tcc.moodle_user = 'fabio'
    if @tcc.save
      render 'index'
    else
      render 'new'
    end
  end

  def update
    @tcc = Tcc.find(params[:id])
    if @tcc.update_attributes(params[:tcc])
      render 'index'
    else
      render 'edit'
    end
  end

  private

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
