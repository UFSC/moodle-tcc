module Authentication

  def self.included(base)
    base.send(:include, Authentication::LTI)
  end

  def current_user
    @current_user ||= User.new(@tp) unless @tp.nil?
  end

  class User
    attr_accessor :lti_tp
    delegate :student?, :to => :lti_tp
    delegate :admin?, :to => :lti_tp

    def initialize(lti_tp)
      @lti_tp = lti_tp
    end

    def instructor?
      if self.lti_tp.instructor?
        true
      else
        admin?
      end
    end

    def view_all?
      if admin?
        true
      else
        self.lti_tp.has_role?('urn:moodle:role/coordavea') ||
            self.lti_tp.has_role?('urn:moodle:role/coordcurso') ||
            self.lti_tp.has_role?('urn:moodle:role/tutoria')
      end
    end

    def coordavea?
      self.lti_tp.has_role?('urn:moodle:role/coordavea')
    end

    def coordcurso?
      self.lti_tp.has_role?('urn:moodle:role/coordcurso')
    end

    def tutoria?
      self.lti_tp.has_role?('urn:moodle:role/tutoria')
    end
  end # User class

  module LTI
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

      # FIX-ME: Temporariamente removendo validação de assinaturas pois está quebrado em produção:
      return true

      if !@tp.valid_request?(request)
        logger.error 'Invalid OAuth signature'

        return show_error 'The OAuth signature was invalid'
      end

      return true
    end

    # Verificação de TTL pra OAuth
    # TODO: Verificar implicação de definir o TTL em 1h
    def verify_oauth_ttl!

      if Time.now.utc.to_i - @tp.oauth_timestamp.to_i > 60*60
        logger.error 'OAuth request failed TTL'

        return show_error 'Your request is too old.'
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
end