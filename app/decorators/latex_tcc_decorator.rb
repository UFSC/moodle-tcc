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
end