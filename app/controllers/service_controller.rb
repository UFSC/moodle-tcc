# encoding: utf-8
class ServiceController < ApplicationController
  skip_before_filter :authorize
  skip_before_filter :get_tcc
  before_filter :check_consumer_key

  def report
    # Envia portfolios
    if params[:user_ids]
      @tccs = Tcc.where(moodle_user: params[:user_ids])
      render 'service/report', status: :ok
    else
      render status: :bad_request, json: {error_message: 'Invalid params (missing user_ids)'}
    end
  end

  def report_tcc
    # Envia TCCs
    if params[:user_ids]
      @tccs = Tcc.where(moodle_user: params[:user_ids])
      render 'service/report_tcc', status: :ok
    else
      render status: :bad_request, json: {error_message: 'Invalid params (missing user_ids)'}
    end
  end

  def tcc_definition
    if params[:tcc_definition_id]
      @tcc_definition = TccDefinition.find(params[:tcc_definition_id])
      render 'service/tcc_definition', status: :ok
    else
      render status: :bad_request, json: {error_message: 'Invalid params (missing tcc_definition_id)'}
    end
  end

  def ping
    render text: 'Ok', status: :ok
  end

  private

  def check_consumer_key
    if params[:consumer_key] != Settings.consumer_key
      Rails.logger.debug "[WS Relatórios]: Falha na autenticação. #{params.inspect}"
      render status: :unauthorized, json: {error_message: 'Invalid consumer key'}
    end
  end
end
