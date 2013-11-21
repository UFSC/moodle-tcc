# encoding: utf-8
module Conversor

  REFERENCES_TYPE = {'internet' => 'InternetRef',
                     'gerais' => 'GeneralRef',
                     'livros' => 'BookRef',
                     'capítulos' => 'BookCapRef',
                     'artigos' => 'ArticleRef',
                     'legislative' => 'LegislativeRef'}

  CITACAO_TYPE = {'cd' => :direct_citation, 'ci' => :indirect_citation}

  def self.convert_text(txt, tcc)
    return if txt.nil? || txt.empty?

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

  def self.get_reference(tcc, attr)
    return tcc.references.where(:element_id => attr[:id],
                                :element_type => REFERENCES_TYPE[attr[:ref_type]]).first
  end

  def self.get_citacao(tcc, attr)
    ref = get_reference(tcc, attr)
    ref.element.send(CITACAO_TYPE[attr[:citacao_type]]) unless ref.nil?
  end

  def self.get_reference_id(tcc, attr)
    ref = get_reference(tcc, attr)
    ref.id unless ref.nil?
  end
end