module TccDocument
  class DocumentProcessor < BaseProcessor

    # @param [Nokogiri::XML::Document] document
    # @return [String] latex text document
    def execute(document)
      latex = Nokogiri::XSLT(xslt_latex_template).apply_to(document)

      # Remover begin/end document, pois o mesmo já é inserido no layout
      latex = latex.gsub('\begin{document}', '').gsub('\end{document}', '')

      # Remover lihas em branco no inicio e ao final do arquivo
      latex.strip
    end

    private

    def xslt_latex_template
      File.read(File.join(self.latex_path, 'xh2latex.xsl'))
    end
  end
end