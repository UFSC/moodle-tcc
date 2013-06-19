module HubHelper
  def diary_content content
    content.blank? ? '[ não existe nada postado para esta atividade ainda ]' : content.html_safe
  end
end
