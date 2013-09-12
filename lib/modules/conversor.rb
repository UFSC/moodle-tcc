module Conversor

  REFERENCES_TYPE = {'internet' => 'InternetRef',
                     'gerais' => 'GeneralRef',
                     'livros' => 'BookRef',
                     'capítulos' => 'CapRef',
                     'artigos' => 'ArticleRef',
                     'legislative' => 'LegislativeRef'}

  CITACAO_TYPE = {'cd' => :direct_citation, 'ci' => :indirect_citation}

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