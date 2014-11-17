# encoding: utf-8

class TccService

  def initialize(tcc)
    @tcc = tcc
  end

  def self.apply_latex(text)
    # XHTML bem formatado e com as correções necessárias para não atrapalhar o documento final do LaTex
    xml = TccDocument::HTMLProcessor.new.execute(text)

    # Realiza transformações nas tags de imagem
    xml = TccDocument::ImageProcessor.new.execute(xml)

    # Aplicar XSLT para obter um arquivo LaTeX
    latex = TccDocument::DocumentProcessor.new.execute(xml)

    latex
  end

  def process_remote_text(text)
    # XHTML bem formatado e com as correções necessárias para não atrapalhar o documento final do LaTex
    xml = TccDocument::HTMLProcessor.new.execute(text)

    # Download das figuras do Moodle e transformação em cópias locais
    xml = TccDocument::ImageDownloaderProcessor.new(@tcc).execute(xml)

    xml.to_xhtml
  end

end