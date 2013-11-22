# encoding: utf-8
module TccLatex
  unloadable

  def self.apply_latex(text)
    #texto vazio, retornar mensagem genérica de texto vazio
    if (text.nil?)
      return '[ainda não existe texto para esta seção]'
    end

    # Substituir caracteres html pelo respectivo em utf-8
    coder = HTMLEntities.new
    content = coder.decode(text)
    clean = content.gsub('<tbody>','').gsub('</tbody>','')
    html = Nokogiri::HTML(clean)

    # XHTML bem formado
    doc = Nokogiri::XML(html.to_xhtml)

    doc.search('table').each do |t|
      t.replace t.to_s.gsub(/<p\b[^>]*>/,'').gsub('</p>','')
    end

    # Aplicar xslt
    xh2file = Rails.public_path + '/xh2latex.xsl'
    xslt  = Nokogiri::XSLT(File.read(xh2file))
    transform = xslt.apply_to(doc)

    # Remover begin document, pois ja está no layout
    tex = transform.gsub('\begin{document}','').gsub('\end{document}','')
    return tex.strip
  end

  def self.generate_references(content)
    #Criar arquivo de referência
    doc = Nokogiri::XML(content)

    #aplicar xslt
    xh2file = Rails.public_path + '/xh2bib.xsl'
    tmpFile = File.read(xh2file)
    xslt  = Nokogiri::XSLT(tmpFile)
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

  def self.generate_figures(content)
    dir = File.join(Rails.root, 'tmp', 'rails-latex', 'teste')
    doc = Nokogiri::HTML(content)

      #Salvar imagens
      img_srcs = doc.css('img').map{ |i| i['src'] }
      img_dst = img_srcs.map{ |i| File.join(dir, File.basename(i)) }

  end

end