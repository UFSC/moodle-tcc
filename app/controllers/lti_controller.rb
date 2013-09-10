# encoding: utf-8
class LtiController < ApplicationController

  # Responsável por realizar a troca de mensagens e validação do LTI como um Tool Provider
  # De acordo com o papel informado pelo LTI Consumer, redireciona o usuário
  def establish_connection
    if authorize_lti!
      @type = @tp.custom_params['type']

      redirect_user_to_start_page
    end
  end

  def access_denied

  end

end
