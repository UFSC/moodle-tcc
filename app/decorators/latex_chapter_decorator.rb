class LatexChapterDecorator < Draper::Decorator

  def content
    # texto vazio, retornar mensagem genérica de texto vazio
    return I18n.t('empty_chapter') if object.content.nil? || object.content.empty?

    # .html_safe é essencial para evitar do & ser convertido para &amp;
    TccLatex.apply_latex(object.content).html_safe
  end

  def title
    title = object.chapter_definition.title
    title.gsub('"', '') unless title.nil?

    title
  end
end