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

      c['reference_id'] = Conversor::get_reference_id(tcc, attr)

      if !new_text.nil?
        c.content = new_text unless new_text.empty?
        c[:title] = new_text unless new_text.empty?
      end
    end
    return texto.search('body').first.inner_html
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

  def self.get_reference_id(tcc, attr)
    ref = tcc.references.where(:element_id => attr[:id]).first
    ref.id if !ref.nil?
  end
end