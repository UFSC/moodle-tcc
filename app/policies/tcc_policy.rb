class TccPolicy < ApplicationPolicy

  def show?
    if user.view_all?
      return true
    elsif user.student?
      return record.student_id == user.person.id
    elsif user.orientador?
      return record.orientador_id == user.person.id
    elsif user.tutor?
      return record.tutor_id == user.person.id
    end

    false
  end

  def list?
    false
  end

  def can_edit_defense_date?
    return user.coordenador_avea? || user.admin?
  end

  # Apresenta as tabs somente para o estudante, pois para os outros o acesso aos itens do TCC será pela lista
  def can_show_tabs_header?
    return user.student?
  end

  # Identifica o nome do estudante caso as telas não sejam abertas por abas
  def can_identify_student?
    return !can_show_tabs_header?
  end

  def can_work_with_compound_names?
    return (user.coordenador_avea? || user.admin?)
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
