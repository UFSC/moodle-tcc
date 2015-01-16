module BatchPrintsHelper

  def bp_grade_cell(tcc, state, title)
    #state = 'valued' - Avaliado
    #state = 'waiting' - Aguardando  acabar
    #state = 'for_evaluation' - Sem nota mas não pode editar
    #state = 'insert_grade'- Acabou o TCC e pode inserir nota
    #state = 'readonly' - com nota sem editar

    action = 'grade_label'

    content = (!tcc.nil? && !tcc.grade.nil?) ? tcc.grade.to_i : label_text(action, state)
    content_tag 'td', class: status_label_class(state) do
      "#{content}"
    end
  end

  def bp_student_name(tcc)
    if tcc.nil?
      return "<strong>{student.name}</strong>"
    end
    student = tcc.student.decorate

    "<strong>#{student.name}</strong> <i>#{student.matricula}</i>".html_safe
  end
end
