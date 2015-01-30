class AbstractPolicy < ChapterPolicy

  def can_send_to_done?
    # verifica se há condições mínimas para a aprovação do capítulo
    super
    (!@record.tcc.title.nil? && !@record.tcc.title.empty?)
  end


end