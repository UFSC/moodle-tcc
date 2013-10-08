module Conversor

  REFERENCES_TYPE = {'internet' => 'InternetRef',
                     'gerais' => 'GeneralRef',
                     'livros' => 'BookRef',
                     'capítulos' => 'CapRef',
                     'artigos' => 'ArticleRef',
                     'legislative' => 'LegislativeRef'}

  CITACAO_TYPE = {'cd' => :direct_citation, 'ci' => :indirect_citation}

  def self.convert_text(txt, tcc)
    texto = Nokogiri::HTML(txt)
    texto.search('citacao').each do |c|
      attr = Conversor::get_attributes(c)
      new_text = Conversor::get_citacao(tcc, attr)

      c.content = new_text unless new_text.empty?
      c[:title] = new_text unless new_text.empty?
    end

    texto = texto.to_xml.sub("<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\" \"http://www.w3.org/TR/REC-html40/loose.dtd\">\n<html><body>", '')
    texto = texto.sub("<p>", '')
    texto = texto.sub("</p>", '')
    texto = texto.sub("</body>", '')
    texto = texto.sub("</html>", '')
    texto
  end

  def self.get_attributes(c)
    {:ref_type => c['ref-type'], :citacao_type => c['citacao_type'], :id => c['id']}
  end

  def self.search_for_citacoes(text)
    citacoes = Nokogiri::HTML(text).search('citacao')
    citacoes
  end

  def self.get_citacao(tcc, attr)
    ref = tcc.references.where(:element_id => attr[:id]).first
    ref = ref.element if !ref.nil?
    ref.send(CITACAO_TYPE[attr[:citacao_type]]) if !ref.nil?
  end

  def self.old?(text)
    if text.nil?
      false
    else
      text.include? '[['
    end
  end
end