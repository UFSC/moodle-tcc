module InstructorAdminHelper

  def status_cell(object, link_to_path)
    state = object.blank? ? 'new' : object.state
    #state = object.blank? ? 'new' : 'draft'

    content_tag 'td', class: status_label_class(state) do
      link_to(label_text('actions', state),
              link_to_path,
              target: '_blank',
              title: "Clique aqui para #{label_title('actions', state)}")
    end

  end

  def grade_cell(tcc, state, title)
    #state = 'valued' - Avaliado
    #state = 'waiting' - Aguardando  acabar
    #state = 'for_evaluation' - Sem nota mas não pode editar
    #state = 'insert_grade'- Acabou o TCC e pode inserir nota
    #state = 'readonly' - com nota sem editar

    action = 'grade_label'

    content = (!tcc.nil? && !tcc.grade.nil?) ? tcc.grade.to_i : label_text(action, state)
    content_tag 'td', class: status_label_class(state) do
      if %w(valued insert_grade).include?(state)
        link_to(content,
                "##{tcc.id}",
                #class: 'alert-link',
                target: '_blank',
                data: {:toggle => "modal"},
                title: "#{title}")
      else
        "#{content}"
      end
    end
  end

  def student_name(tcc)
    student = tcc.student.decorate

    "<strong>#{student.name}</strong> <br /><i>#{student.matricula}</i>".html_safe
  end

  private

  def status_label_class(state)
    "status #{state}"
  end

  def label_text(type, state)
    t(type+'.'+state.to_s)
  end

  def label_title(type, state)
    t(type+'.'+state.to_s+'Title')
  end
end
