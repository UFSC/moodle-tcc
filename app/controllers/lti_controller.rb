class LtiController < ApplicationController

  # Responsável por realizar a troca de mensagens e validação do LTI como um Tool Provider
  # De acordo com o papel informado pelo LTI Consumer, redireciona o usuário
  def establish_connection
    if authorize_lti!
      if @tp.student?
        logger.debug 'LTI user identified as a student'
        redirect_to tccs_path
      elsif @tp.instructor?
        logger.debug 'LTI user identified as a instructor'
        redirect_to instructor_admin_tccs_path
      end
    end

    return false
  end

  private

  # Inicializa o Tool Provider e faz todas as checagens necessárias para garantir permissões
  # Caso encontre algum problema, redireciona para uma página de erro
  # Ao final do processo, salva na sessão as variáveis de inicialização do LTI para posterior reuso
  def authorize_lti!
    if initialize_tool_provider! && verify_oauth_signature! && verify_oauth_ttl!
      session['lti_launch_params'] = @tp.to_params
      return true
    end

    return false
  end

  def initialize_tool_provider!
    # TODO: criar tabela para armazenar consumer_key => consumer_secret
    key = params['oauth_consumer_key']

    # Verifica se a chave foi informada e se é uma chave existente
    if key.blank? || key != TCC_CONFIG['consumer_key']
      logger.error 'Invalid OAuth consumer key informed'

      @tp = IMS::LTI::ToolProvider.new(nil, nil, params)

      @tp.lti_msg = "Your consumer didn't use a recognized key."
      @tp.lti_errorlog = 'Invalid OAuth consumer key informed'

      return show_error "Consumer key wasn't recognized"
    end

    logger.debug 'LTI TP Initialized with valid key/secret'

    @tp = IMS::LTI::ToolProvider.new(key, TCC_CONFIG['consumer_secret'], params)
    return true
  end

  # Verifica a assinatura do OAuth
  def verify_oauth_signature!

    if !@tp.valid_request?(request)
      logger.error 'Invalid OAuth signature'

      return show_error 'The OAuth signature was invalid'
    end

    return true
  end

  # Verificação de TTL pra OAuth
  # TODO: Verificar implicação de definir o TTL em 1h
  def verify_oauth_ttl!

    if Time.now.utc.to_i - @tp.request_oauth_timestamp.to_i > 60*60
      return show_error "Your request is too old."
    end

    return true
  end

  def verify_oauth_nonce!
    # TODO: Implementar checagem de nonce para satizfazer segurança do OAuth
    # @tp.request_oauth_nonce

    return true
  end

  def show_error(error_message)
    render :inline => error_message, :status => 403
    return false
  end
end
