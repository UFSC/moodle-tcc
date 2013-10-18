module TccLatex
  unloadable

  def self.apply_latex(text)
    # Substituir caracteres html pelo respectivo em utf-8
    coder = HTMLEntities.new
    content = coder.decode(text)
    html = Nokogiri::HTML(content)

    # XHTML bem formado
    doc = Nokogiri::XML(html.to_xhtml)

    # Aplicar xslt
    xh2file = Rails.public_path + '/xh2latex.xsl'
    xslt  = Nokogiri::XSLT(File.read(xh2file))
    transform = xslt.apply_to(doc)

    # Remover begin document, pois ja está no layout
    tex = transform.gsub('\begin{document}','').gsub('end{document}','')
    return tex
  end



  def self.references
    #criar html do references
    htmlfile = Rails.public_path + '/references.html'
    file = File.read(htmlfile)
    doc = Nokogiri::XML(file)

    #aplicar xslt
    xh2file = Rails.public_path + '/xh2bib.xsl'
    tmpFile = File.read(xh2file)
    xslt  = Nokogiri::XSLT(tmpFile)

    return xslt.apply_to(doc)
  end



end