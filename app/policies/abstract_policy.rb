class AbstractPolicy < ChapterPolicy

  def can_send_to_done?
    # verifica se há condições mínimas para a aprovação do capítulo
    # super
    (super && @record.tcc.title.present?)
  end

end