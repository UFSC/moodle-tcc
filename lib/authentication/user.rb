module Authentication
  class User
    attr_accessor :lti_tp
    attr_accessor :person
    delegate :admin?, :to => :lti_tp

    def initialize(lti_tp)
      @lti_tp = lti_tp
      @person = Person.find_by(moodle_id: lti_tp.user_id)

      if !@person && view_all?
        sync = SyncTcc.new(lti_tp.custom_params['tcc_definition'])
        @person = sync.find_or_create_person(lti_tp.user_id)
      end

      raise PersonNotFoundError unless @person
    end

    def id
      self.person.moodle_id
    end

    def instructor?
      if self.lti_tp.instructor?
        true
      elsif orientador?
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
        # tirado o coordenador de tutoria de ter o acesso de visão geral, posi os tutores não terão permissão de
        # acesso nessa versão da ferramenta
        #
        # coordenador_avea? || coordenador_tutoria? || coordenador_curso?
        #TODO: esperando o coordenador
        coordenador_avea? || coordenador_curso?
      end
    end

    def admin?
      self.lti_tp.has_role?(Roles.administrator) || self.lti_tp.has_role?('administrator')
    end

    def coordenador_avea?
      self.lti_tp.has_role?(Roles.coordenador_avea)
    end

    def coordenador_curso?
      self.lti_tp.has_role?(Roles.coordenador_curso)
    end

    def coordenador_tutoria?
      self.lti_tp.has_role?(Roles.coordenador_tutoria)
    end

    def tutor?
      # tirado o tutor de ter o acesso à ferramenta
      #
      # self.lti_tp.has_role?('urn:moodle:role/td')
      false
    end

    def orientador?
      self.lti_tp.has_role?(Roles.orientador)
    end

    def student?
      self.lti_tp.has_role?(Roles.student) || self.lti_tp.has_role?('urn:lti:role:ims/lis/learner') || self.lti_tp.has_role?('student')
    end

  end
end