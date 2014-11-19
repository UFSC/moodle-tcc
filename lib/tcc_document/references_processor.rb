module TccDocument
  class ReferencesProcessor < BaseProcessor

    def execute(content)
      # Criar arquivo de referência
      doc = Nokogiri::XML(content)

      # Aplicar XSLT
      xslt = Nokogiri::XSLT(xslt_bibtex_template)
      content = xslt.apply_to(doc)

      # Salvar arquivo bib no tmp
      input = File.join(temp_dir, 'input.bib')
      File.open(input, 'wb') { |io| io.write(content) }

      # retorna "Rails-root/tmp/rails-latex/xxx/input.bib"
      input
    end

    private

    def xslt_bibtex_template
      File.read(File.join(self.latex_path, 'xh2bib.xsl'))
    end

    def temp_dir
      path = File.join(Rails.root, 'tmp', 'rails-latex', "#{Process.pid}-#{Thread.current.hash}")
      FileUtils.mkdir_p(path)

      path
    end
  end
end