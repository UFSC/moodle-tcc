module TccLatex
  unloadable

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