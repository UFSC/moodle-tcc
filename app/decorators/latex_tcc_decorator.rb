class LatexTccDecorator < Draper::Decorator
  decorates_association :student

  def defense_date
    defense_date = Date.today

    if !object.defense_date.nil?
      defense_date = object.defense_date
    elsif !object.tcc_definition.defense_date.nil?
      defense_date = object.tcc_definition.defense_date
    end

    h.lesc h.l(defense_date, format: :abnt)
  end

  def orientador_name
    h.lesc object.orientador.name unless object.orientador.nil?
  end

  def student_name
    h.lesc student.name
  end

  def title
    h.lesc object.title unless object.title.nil?
  end

  def city
    h.lesc object.tcc_definition.internal_course.internal_institution.city unless
        object.tcc_definition.internal_course.internal_institution.city.nil?
  end

  def logo_path
    inst = object.tcc_definition.internal_course.internal_institution
    logo_path = "#{Rails.root}/public/#{inst.image_url().to_s}"

    h.lesc File.exists?(logo_path)? logo_path : ''
  end

  def institution
    h.lesc object.tcc_definition.internal_course.internal_institution.institution_name unless
        object.tcc_definition.internal_course.internal_institution.institution_name.nil?
  end

  def coordinator
    h.lesc object.tcc_definition.internal_course.coordinator_name unless
        object.tcc_definition.internal_course.coordinator_name.nil?
  end

  def course
    h.lesc object.tcc_definition.internal_course.course_name unless
        object.tcc_definition.internal_course.course_name.nil?
  end

  def department
    h.lesc object.tcc_definition.internal_course.department_name unless
        object.tcc_definition.internal_course.department_name.nil?
  end

  def center
    h.lesc object.tcc_definition.internal_course.center_name unless
        object.tcc_definition.internal_course.center_name.nil?
  end

  def presentation
    h.lesc object.tcc_definition.internal_course.presentation_data unless
        object.tcc_definition.internal_course.presentation_data.nil?
  end

  def approval
    h.lesc object.tcc_definition.internal_course.approval_data unless
        object.tcc_definition.internal_course.approval_data.nil?
  end
end