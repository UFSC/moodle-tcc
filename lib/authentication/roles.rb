module Authentication
  module Roles

    def self.administrator
      'urn:lti:sysrole:ims/lis/administrator'
    end

    def self.coordenador_avea
      'urn:moodle:role/coordavea'
    end

    def self.coordenador_curso
      'urn:moodle:role/coordcurso'
    end

    def self.coordenador_tutoria
      'urn:moodle:role/tutoria'
    end

    def self.orientador
      'urn:moodle:role/orientador'
    end

    def self.student
      'urn:moodle:role/student'
    end

    def self.tutor
      'urn:moodle:role/td'
    end
  end
end
