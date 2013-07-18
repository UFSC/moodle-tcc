class ServiceController < ApplicationController
  def report
    respond_to do |format|
      if params[:consumer_key] == TCC_CONFIG['consumer_key']
        @tcc = Tcc.first #Todo: Falta mudar para pegar as informações necessárias
        format.json  { render :json => @tcc }
        format.xml  { render :xml => @tcc }
      else
        format.json  { render :json => nil }
      end
    end
  end
end