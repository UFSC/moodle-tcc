module InstructorAdminHelper

  def status_cell(object, link_to_path)
    state = object.blank? ? 'new' : object.state

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
        link_to(content, edit_grade_tcc_path(moodle_user: tcc.student.moodle_id), id: "edit-grade-#{tcc.id}", target: '_blank', remote: true, title: "#{title}")
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

  def moodle_url_message(moodle_id)
    url = URI.parse(Settings.moodle_url)
    url.merge!("message/index.php?id=#{moodle_id}").to_s
  end

end
