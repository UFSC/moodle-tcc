class TccPolicy < ApplicationPolicy

  def show?
    if user.view_all?
      return true
    elsif user.student?
      return record.student_id == user.person.id
    elsif user.tutor?
      return record.tutor_id == user.person.id
    elsif user.tutor?
      return record.orientador_id == user.person.id
    end

    false
  end

  def list?
    false
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
