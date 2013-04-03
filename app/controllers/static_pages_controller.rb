class StaticPagesController < ApplicationController
  if defined? ActionDispatch
    require 'oauth/request_proxy/rack_request'
    require 'action_dispatch/testing/test_process'
  else
    require 'oauth/request_proxy/action_controller_request'
    require 'action_controller/test_process'
  end

  def home
    if authorize?
      role =  @tp.to_params["roles"].split(",").first
      if role == "Instructor"
        #view para professor
      else
        #view para aluno
      end
    else
      render file: 'public/500.html'
    end
  end

  # the consumer keys/secrets
  $consumer_key = "consumer_key"
  $consumer_secret = "consumer_secret"

  private

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