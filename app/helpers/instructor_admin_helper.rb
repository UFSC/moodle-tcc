module InstructorAdminHelper

  def status_cell(object, link_to_path)
    state = object.blank? ? 'new' : 'draft'

    content_tag 'td', class: status_label_class(state) do
      link_to(label_text('actions', state), link_to_path, target: '_blank')
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
end
