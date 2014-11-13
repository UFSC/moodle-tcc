# encoding: utf-8

module TccLatex

  def self.apply_latex(text)
    # XHTML bem formatado e com as correções necessárias para não atrapalhar o documento final do LaTex
    xml = TccDocument::HTMLProcessor.new.execute(text)

    # Realiza transformações nas tags de imagem
    xml = TccDocument::ImageProcessor.new.execute(xml)

    # Download das figuras do Moodle e transformação em cópias locais
    # download_figures(tcc, xml)
    # xml = TccDocument::ImageDownloaderProcessor.new(tcc).execute(xml)

    # Aplicar XSLT para obter um arquivo LaTeX
    latex = TccDocument::DocumentProcessor.new.execute(xml)

    latex
  end

end
