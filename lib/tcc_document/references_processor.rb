module TccDocument
  class ReferencesProcessor < BaseProcessor

    def execute(content)
      # nome do arquivo bib
      inputFileName = 'input.bib'
      
      # Criar arquivo de referência
      doc = Nokogiri::XML(content)

      # Aplicar XSLT
      xslt = Nokogiri::XSLT(xslt_bibtex_template)
      content = xslt.apply_to(doc)

      # Salvar arquivo bib no tmp
      input = File.join(temp_dir, inputFileName)
      File.open(input, 'wb') { |io| io.write(content) }

      # retorna
      # "input.bib" se usa docker
      # senão "Rails-root/tmp/rails-latex/xxx/input.bib"
      Settings.docker_image.present? ? inputFileName : input
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
