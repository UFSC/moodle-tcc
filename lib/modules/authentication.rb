module Authentication
  def current_user
    User.new(@tp)
  end

  class User
    attr_accessor :lti_tp
    delegate :student?, :to => :lti_tp

    def initialize(lti_tp)
      @lti_tp = lti_tp
    end

    def instructor?
      if self.lti_tp.instructor?
        true
      else
        if admin?
           true
        else
           false
        end
      end
    end

    def admin?
      if self.lti_tp.admin?
        true
      else
        role =  self.lti_tp.roles.first
        if role == 'coordcurso' || role == 'coordavea' || role == 'tutoria'
          true
        else
          false
        end
      end

    end
  end
end