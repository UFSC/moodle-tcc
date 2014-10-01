module TccDocument
  class DocumentProcessor < BaseProcessor

    def execute(document)
      latex = Nokogiri::XSLT(xslt_template).apply_to(document)

      # Remover begin/end document, pois o mesmo já é inserido no layout
      latex = latex.gsub('\begin{document}', '').gsub('\end{document}', '')

      # Remover lihas em branco no inicio e ao final do arquivo
      latex.strip
    end

    def xslt_template
      File.read(File.join(self.latex_path, 'xh2latex.xsl'))
    end
  end
end