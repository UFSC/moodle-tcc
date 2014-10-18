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

  def create?
    save?
  end

  def save?
    show?
  end

  def edit?
    save?
  end

  def update?
    save?
  end

  def list?
    false
  end

  def edit_defense_date?
    user.coordenador_avea? || user.admin?
  end

  # Apresenta as tabs somente para o estudante, pois para os outros o acesso aos itens do TCC será pela lista
  def show_tabs_header?
    user.student?
  end

  # Identifica o nome do estudante caso as telas não sejam abertas por abas
  def show_student?
    !show_tabs_header?
  end

  def show_compound_names?
    (user.coordenador_avea? || user.admin?)
  end

  def import_chapters?
    if user.student?
      return record.student_id == user.person.id
    end
    show_compound_names?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
