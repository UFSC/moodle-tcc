module Authentication

  class PersonNotFoundError < RuntimeError
  end

  class UnauthorizedError < RuntimeError
  end

  def self.included(base)
    base.send(:include, Authentication::Moodle)
    base.send(:include, Authentication::LTI)
  end

end