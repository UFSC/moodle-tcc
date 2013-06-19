module HubHelper
  def diary_content content
    content.blank? ? t('empty_diaries') : content.html_safe
  end
end
