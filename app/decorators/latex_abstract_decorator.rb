class LatexAbstractDecorator < Draper::Decorator
  def content
    # texto vazio, retornar mensagem genérica de texto vazio
    return I18n.t('empty_abstract') if object.content.nil? || object.content.empty?

    # .html_safe é essencial para evitar do & ser convertido para &amp;
    TccLatex.apply_latex(object.content).html_safe
  end

  def keywords
    # texto vazio, retornar mensagem genérica de texto vazio
    return I18n.t('empty_abstract_keywords') if object.keywords.nil? || object.content.empty?

    object.keywords
  end
end