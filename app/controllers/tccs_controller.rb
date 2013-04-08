class TccsController < ApplicationController
  if defined? ActionDispatch
    require 'oauth/request_proxy/rack_request'
    require 'action_dispatch/testing/test_process'
  else
    require 'oauth/request_proxy/action_controller_request'
    require 'action_controller/test_process'
  end

  def show
    if authorize?
      @role =  @tp.to_params["roles"].split(",").first
      if @role == 'Instructor'
        @tccs = Tcc.all
        render 'instructor_admin'
      else
        if @tcc = Tcc.find_by_moodle_user(@tp.username)
          render 'edit'
        else
          @tcc = Tcc.new(:moodle_user => @tp.username)
          render 'new'
        end
      end
    else
      render file: 'public/500.html'
    end
  end

  def edit

  end

  def create
    @tcc = Tcc.new(params[:tcc])
    if @tcc.save

    else

    end
  end

  def update

  end

  private

  # the consumer keys/secrets
  $consumer_key = "consumer_key"
  $consumer_secret = "consumer_secret"

  def authorize?
    if params['oauth_consumer_key'] == $consumer_key
      @tp = IMS::LTI::ToolProvider.new($consumer_key, $consumer_secret, params)
      unless @tp.valid_request?(request)
        false
      else
        true
      end
    else
      false
    end
  end
end
