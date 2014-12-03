module Authentication
  module LTI

    class CredentialsError < RuntimeError;
    end

    # Inicializa o Tool Provider e faz todas as checagens necessárias para garantir permissões
    # Caso encontre algum problema, redireciona para uma página de erro
    # Ao final do processo, salva na sessão as variáveis de inicialização do LTI para posterior reuso
    def authorize_lti!
      if initialize_tool_provider! && verify_oauth_signature! && verify_oauth_ttl!
        session['lti_launch_params'] = @tp.to_params
        return true
      end

      false
    end


    def initialize_tool_provider!
      key = params['oauth_consumer_key']
      instance_guid = params['tool_consumer_instance_guid']

      # Verifica se a chave foi informada e se é uma chave existente
      if key.blank? || key != Settings.consumer_key
        logger.error 'Invalid OAuth consumer key informed'

        # TODO: Migrar para o metodo "rescue_from"
        @tp = IMS::LTI::ToolProvider.new(nil, nil, params)
        @tp.lti_msg = "Your consumer didn't use a recognized key."
        @tp.lti_errorlog = 'Invalid OAuth consumer key informed'

        raise Authentication::LTI::CredentialsError, "'Consumer key' não foi reconhecida"
      end

      # Verifica se o host está autorizado a realizar a requisição
      # A idéia aqui é principalmente evitar que erroneamente seja acessado pelo desenvolvimento
      if Settings.instance_guid && instance_guid != Settings.instance_guid
        logger.error 'Unauthorized instance guid'

        # TODO: Migrar para o metodo "rescue_from"
        @tp = IMS::LTI::ToolProvider.new(nil, nil, params)
        @tp.lti_msg = 'You are not authorized to use this application. (Unauthorized instance guid)'
        @tp.lti_errorlog = 'Unauthorized guid'

        raise Authentication::LTI::CredentialsError, 'Unauthorized instance guid'
      end

      logger.debug 'LTI TP Initialized with valid key/secret'
      @tp = IMS::LTI::ToolProvider.new(key, Settings.consumer_secret, params)

      true
    end

    # Verifica a assinatura do OAuth
    def verify_oauth_signature!

      if !@tp.valid_request?(request)
        signature = OAuth::Signature.sign(request, {:consumer_secret => Settings.consumer_secret})
        logger.error 'Invalid OAuth signature'
        logger.error 'Should be: ' +signature

        raise Authentication::LTI::CredentialsError, 'Invalid OAuth signature'
      end

      true
    end

    # Verificação de TTL pra OAuth
    # TODO: Verificar implicação de definir o TTL em 1h
    def verify_oauth_ttl!

      if Time.now.utc.to_i - @tp.oauth_timestamp.to_i > 60*60
        logger.error 'OAuth request failed TTL'

        raise CredentialsError, 'Your request is too old'
      end

      true
    end

    def verify_oauth_nonce!
      # TODO: Implementar checagem de nonce para satizfazer segurança do OAuth
      # @tp.request_oauth_nonce

      true
    end
  end
end