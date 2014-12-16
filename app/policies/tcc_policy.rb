class TccPolicy < ApplicationPolicy
  def show?
    if user.view_all?
      return true
    elsif user.orientador?
      return record.orientador.id == user.person.id
    elsif user.tutor?
      return record.tutor.id == user.person.id
    elsif user.student?
      return record.student.id == user.person.id
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

  # Verifica se pode exibir a lista de TCCs
  def show_scope?
    (user.view_all? || user.instructor?)
  end

  # Verifica se pode montar as telas de edição de notas
  def show_assign_grade?
    user.orientador? || edit_defense_date?
  end

  # Verifica se pode alterar a nota na tela de edição de notas
  def edit_assign_grade?
    if user.orientador?
      can_edit = record.orientador.id == user.person.id
    else
      can_edit = edit_defense_date?
    end
    return can_edit
  end

  # Verifica se pode dar a nota, verificar se todas as partes do TCC estão avaliadas
  def can_grade?
    # verificar se todos os capitulos estao avaliado
    return false unless (!record.abstract.nil? && !record.abstract.empty? && record.abstract.state.eql?('done'))
    record.chapters.each do | ichapter |
      return false unless (!ichapter.nil? && !ichapter.empty? && ichapter.state.eql?('done'))
    end

    #verifica se existe o título definido
    return false if (!record.nil? && record.title.empty?)
    #verifica se existe ao menos 5 referencias criadas
    #record.references.count >= 5
    return true
  end

  # Verifica se pode editar a data de defesa
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

  # Verifica se pode apresentar a ferramenta de Nomes Composto (na bibliografia)
  def show_compound_names?
    (user.coordenador_avea? || user.admin?)
  end

  # Verifica se pode importar os capítulos das atividades do Moodle
  def import_chapters?
    if user.student?
      return record.student_id == user.person.id
    end
    show_compound_names?
  end

  class Scope < Scope
    def resolve
      if user.view_all?
        return scope
      elsif user.orientador?
        return scope.where(orientador_id: user.person.id)
      elsif user.tutor?
        # como o
        #return scope.where(tutor_id: user.person.id)
        return scope.where(tutor_id: 0)
      end
      #limita o acesso ao próprio usuário logado
      scope.where(student_id: user.person.id)
    end
  end
end
