class LatexChapterDecorator < Draper::Decorator

  def content
    # texto vazio, retornar mensagem genérica de texto vazio
    return '[nenhum conteúdo foi produzido para este capítulo]' if object.content.nil? || object.content.empty?

    TccLatex.apply_latex(object.content)
  end

  def title
    title = object.chapter_definition.title
    title.gsub('"', '') unless title.nil?

    title
  end
end