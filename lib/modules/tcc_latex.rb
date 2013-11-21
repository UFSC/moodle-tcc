# encoding: utf-8
module TccLatex
  unloadable

  def self.latex_path
    File.join(Rails.root, 'latex')
  end

  def self.apply_latex(text)
    if text.nil?
      #texto vazio, retornar mensagem genérica de texto vazio
      return '[ainda não existe texto para esta seção]'
    end

    # Substituir caracteres html pelo respectivo em utf-8
    html = cleanup_html(text)

    # XHTML bem formado
    doc = Nokogiri::XML(html.to_xhtml)

    #Processar imagens
    doc = process_figures(doc)

    # Aplicar xslt
    doc = process_xslt(doc)

    return doc
  end

  def self.process_xslt(doc)
    xh2file = File.read(File.join(self.latex_path, 'xh2latex.xsl'))
    xslt = Nokogiri::XSLT(xh2file)
    transform = xslt.apply_to(doc)

    # Remover begin document, pois ja está no layout
    tex = transform.gsub('\begin{document}', '').gsub('\end{document}', '')
    return tex.strip
  end

  def self.cleanup_html(text)
    reader = HTMLEntities.new
    content = reader.decode(text)

    # Remove tags tbody e thead de tabelas para impressão correta no latex
    cleanup_pattern = %w(<tbody> </tbody> <thead> </thead>)
    cleanup_pattern.each { |pattern| content = content.gsub(pattern, '') }

    html = Nokogiri::HTML(content)

    # Remove tabela dentro de tabelas
    html.search('table').each do |tab|
      tab.search('table').remove
    end

    return html
  end

  def self.generate_references(content)
    #Criar arquivo de referência
    doc = Nokogiri::XML(content)

    #aplicar xslt
    xh2file = File.read(File.join(self.latex_path, 'xh2bib.xsl'))
    xslt = Nokogiri::XSLT(xh2file)
    content = xslt.apply_to(doc)

    #Salvar arquivo bib no tmp
    dir = File.join(Rails.root, 'tmp', 'rails-latex', "#{Process.pid}-#{Thread.current.hash}")
    input = File.join(dir, 'input.bib')

    FileUtils.mkdir_p(dir)
    File.open(input, 'wb') { |io|
      io.write(content)
    }

    # retorna "Rails-root/tmp/rails-latex/xxx/input.bib"
    return input
  end

  def self.process_figures(doc)
    #Inserir class figure nas imagens e resolver caminho
    images = doc.css('img').map { |i|
      i['class'] = 'figure'
      if i['src'] !~ URI::regexp
        i['src'] = Rails.public_path << i['src']
      end
    }

    return doc
  end

end