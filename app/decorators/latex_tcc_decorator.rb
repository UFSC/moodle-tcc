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

  def advisor_nomenclature
    h.lesc object.tcc_definition.advisor_nomenclature unless object.tcc_definition.nil?
  end

  def student_name
    student_without_enrollment = object.student.name.gsub(/\([^()\s]*\)$/, '').strip
    h.lesc student_without_enrollment
  end

  def title
    h.lesc object.title unless object.title.nil?
  end

  def coordinator_gender
    dec_result = 'm'
    dec_result = h.lesc object.tcc_definition.internal_course.coordinator_gender unless
        ( object.tcc_definition.nil? ||
            object.tcc_definition.internal_course.nil? ||
            object.tcc_definition.internal_course.coordinator_gender.nil? )
    dec_result
  end

  def logo_path
    logo_path = "#{Rails.root}/app/assets/images/image-not-found.jpg".squeeze("/")
    unless ( object.tcc_definition.nil? ||
        object.tcc_definition.internal_course.nil? ||
        object.tcc_definition.internal_course.internal_institution.nil? )
      inst = object.tcc_definition.internal_course.internal_institution
      logo_path = "#{Rails.root}/public/#{inst.image_url().to_s}".squeeze("/")
    end
    h.lesc File.exists?(logo_path)? logo_path : I18n.t('not_registered')
  end

  def logo_width
    dec_result = 70
    dec_result = h.lesc object.tcc_definition.internal_course.internal_institution.logo_width unless
        ( object.tcc_definition.nil? ||
            object.tcc_definition.internal_course.nil? ||
            object.tcc_definition.internal_course.internal_institution.nil? ||
            object.tcc_definition.internal_course.internal_institution.logo_width.nil?)
    dec_result
  end

  def city
    dec_result = I18n.t('not_registered')# '[NÃO CADASTRADO]'
    dec_result = h.lesc object.tcc_definition.internal_course.internal_institution.city unless
        ( object.tcc_definition.nil? ||
            object.tcc_definition.internal_course.nil? ||
            object.tcc_definition.internal_course.internal_institution.nil? ||
            object.tcc_definition.internal_course.internal_institution.city.nil?)
    dec_result
  end

  def institution
    dec_result = I18n.t('not_registered')# '[NÃO CADASTRADO]'
    dec_result = h.lesc object.tcc_definition.internal_course.internal_institution.institution_name unless
        ( object.tcc_definition.nil? ||
          object.tcc_definition.internal_course.nil? ||
          object.tcc_definition.internal_course.internal_institution.nil? ||
          object.tcc_definition.internal_course.internal_institution.institution_name.nil?)
    dec_result
  end

  def coordinator
    dec_result = I18n.t('not_registered')# '[NÃO CADASTRADO]'
    dec_result = h.lesc object.tcc_definition.internal_course.coordinator_name unless
        ( object.tcc_definition.nil? ||
          object.tcc_definition.internal_course.nil? ||
          object.tcc_definition.internal_course.coordinator_name.nil? )
    dec_result
  end

  def course
    dec_result = I18n.t('not_registered')# '[NÃO CADASTRADO]'
    dec_result = h.lesc object.tcc_definition.internal_course.course_name unless
        ( object.tcc_definition.nil? ||
          object.tcc_definition.internal_course.nil? ||
          object.tcc_definition.internal_course.course_name.nil? )
    dec_result
  end

  def department
    dec_result = I18n.t('not_registered')# '[NÃO CADASTRADO]'
    dec_result = h.lesc object.tcc_definition.internal_course.department_name unless
        ( object.tcc_definition.nil? ||
          object.tcc_definition.internal_course.nil? ||
          object.tcc_definition.internal_course.department_name.nil? )
    dec_result
  end

  def center
    dec_result = I18n.t('not_registered')# '[NÃO CADASTRADO]'
    dec_result = h.lesc object.tcc_definition.internal_course.center_name unless
        ( object.tcc_definition.nil? ||
          object.tcc_definition.internal_course.nil? ||
          object.tcc_definition.internal_course.center_name.nil? )
    dec_result
  end

  def presentation
    dec_result = I18n.t('not_registered')# '[NÃO CADASTRADO]'
    dec_result = h.lesc object.tcc_definition.internal_course.presentation_data unless
        ( object.tcc_definition.nil? ||
          object.tcc_definition.internal_course.nil? ||
          object.tcc_definition.internal_course.presentation_data.nil?)
    dec_result
  end

  def approval
    dec_result = I18n.t('not_registered')# '[NÃO CADASTRADO]'
    dec_result = h.lesc object.tcc_definition.internal_course.approval_data unless
        ( object.tcc_definition.nil? ||
          object.tcc_definition.internal_course.nil? ||
          object.tcc_definition.internal_course.approval_data.nil?)
    dec_result
  end
end