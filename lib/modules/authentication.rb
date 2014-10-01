# encoding: utf-8
module Authentication

  class PersonNotFoundError < RuntimeError; end
  class UnauthorizedError < RuntimeError; end

  def self.included(base)
    base.send(:include, Authentication::LTI)
  end

  def current_user
    @current_user ||= User.new(@tp) unless @tp.nil?
  end


  # ID do Moodle User atual ou o ID personificado quando o acesso for por não-estudantes.
  #
  # @return [Integer] ID do Moodle User
  def current_moodle_user
    @moodle_user ||=
      if (current_user.instructor? || current_user.orientador? || current_user.view_all?) && params['moodle_user']
        params['moodle_user']
      else
        current_user.id
      end
  end

  # Redireciona o usuário atual para a página de início relativa as permissões de acesso dele
  #
  def redirect_user_to_start_page
    if current_user.student?
      logger.debug 'LTI user identified as a student'
      redirect_to tcc_path
    elsif current_user.tutor?
      logger.debug 'LTI user identified as a tutor'
      redirect_to instructor_admin_path
    elsif current_user.orientador?
      logger.debug 'LTI user identified as a leader'
      redirect_to instructor_admin_path
    elsif current_user.view_all?
      logger.debug 'LTI user is part of a view_all role'
      redirect_to instructor_admin_path
    else
      logger.error "LTI user identified as an unsupported role: '#{@tp.roles}'"
      redirect_to access_denied_path
    end
  end

  # FIX-ME: migrar para person
  class User
    attr_accessor :lti_tp
    attr_accessor :person
    delegate :admin?, :to => :lti_tp

    def initialize(lti_tp)
      @lti_tp = lti_tp
      @person = Person.find_by(moodle_id: lti_tp.user_id)

      raise PersonNotFoundError unless @person
    end

    def id
      self.person.moodle_id
    end

    def instructor?
      if self.lti_tp.instructor?
        true
      elsif tutor?
        true
      else
        admin?
      end
    end

    def view_all?
      if admin?
        true
      else
        coordenador_avea? || coordenador_tutoria? || coordenador_curso?
      end
    end

    def coordenador_avea?
      self.lti_tp.has_role?('urn:moodle:role/coordavea')
    end

    def coordenador_curso?
      self.lti_tp.has_role?('urn:moodle:role/coordcurso')
    end

    def coordenador_tutoria?
      self.lti_tp.has_role?('urn:moodle:role/tutoria')
    end

    def tutor?
      self.lti_tp.has_role?('urn:moodle:role/td')
    end

    def orientador?
      self.lti_tp.has_role?('urn:moodle:role/orientador')
    end

    def student?
      self.lti_tp.has_role?('urn:moodle:role/student') || self.lti_tp.has_role?('urn:lti:role:ims/lis/learner') || self.lti_tp.has_role?('student')
    end


  end # User class

  module LTI

    class CredentialsError < RuntimeError; end

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
      key = params['oauth_consumer_key']
      instance_guid = params['tool_consumer_instance_guid']

      # Verifica se a chave foi informada e se é uma chave existente
      if key.blank? || key != Settings.consumer_key
        logger.error 'Invalid OAuth consumer key informed'

        # TODO: Migrar para o metodo "rescue_from"
        @tp = IMS::LTI::ToolProvider.new(nil, nil, params)
        @tp.lti_msg = "Your consumer didn't use a recognized key."
        @tp.lti_errorlog = 'Invalid OAuth consumer key informed'

        raise CredentialsError.new("Consumer key wasn't recognized")
      end

      # Verifica se o host está autorizado a realizar a requisição
      # A idéia aqui é principalmente evitar que erroneamente seja acessado pelo desenvolvimento
      if Settings.instance_guid && instance_guid != Settings.instance_guid
        logger.error 'Unauthorized instance guid'

        # TODO: Migrar para o metodo "rescue_from"
        @tp = IMS::LTI::ToolProvider.new(nil, nil, params)
        @tp.lti_msg = 'You are not authorized to use this application. (Unauthorized instance guid)'
        @tp.lti_errorlog = 'Unauthorized guid'

        raise CredentialsError.new('Unauthorized instance guid')
      end

      logger.debug 'LTI TP Initialized with valid key/secret'
      @tp = IMS::LTI::ToolProvider.new(key, Settings.consumer_secret, params)

      return true
    end

    # Verifica a assinatura do OAuth
    def verify_oauth_signature!

      # FIX-ME: Temporariamente removendo validação de assinaturas pois está quebrado em produção:
      return true

      if !@tp.valid_request?(request)
        signature = OAuth::Signature.sign(request, :consumer_secret => @consumer_secret)
        logger.error 'Invalid OAuth signature'
        logger.error 'Should be: ' +signature

        raise CredentialsError.new('Invalid OAuth signature')
      end

      return true
    end

    # Verificação de TTL pra OAuth
    # TODO: Verificar implicação de definir o TTL em 1h
    def verify_oauth_ttl!

      if Time.now.utc.to_i - @tp.oauth_timestamp.to_i > 60*60
        logger.error 'OAuth request failed TTL'

        raise CredentialsError.new('Your request is too old')
      end

      return true
    end

    def verify_oauth_nonce!
      # TODO: Implementar checagem de nonce para satizfazer segurança do OAuth
      # @tp.request_oauth_nonce

      return true
    end
  end
end