module TccDocument
  class HTMLProcessor

    def execute(content)
      content = decode_entities(content)
      content = simplify_tables(content)
      convert_to_xml(fix_tables!(content))
    end

    private

    # Texto com HTML Entities convertido para os respectivos símbolos UTF8
    #
    # @param [String] content
    # @return [String] texto sem HTML Entities
    def decode_entities(content)
      # HTMLEntities converte &nbsp em \u00a0 (non-breaking space)
      # Isso causa problemas indesejados no Latex, portanto, vamos converter ambos
      # para espaços normais
      content = content.gsub('&nbsp;', ' ').gsub(/\u00a0/, ' ')

      # Converte caracteres HTML entities para equivalente em utf8
      reader = HTMLEntities.new
      reader.decode(content)
    end

    # Remove tags tbody e thead de tabelas para impressão correta no latex
    #
    # @param [String] content
    # @return [String] texto sem as tags mencionadas
    def simplify_tables(content)
      # Remove tags tbody e thead de tabelas para impressão correta no latex
      cleanup_pattern = %w(<tbody> </tbody> <thead> </thead>)
      cleanup_pattern.each { |pattern| content = content.gsub(pattern, '') }

      content
    end

    # Remove diversas tags que não são válidas dentro de tabelas para o Latex
    # E retorna o conteúdo em XHTML
    #
    # @param [String] content
    # @return [Nokogiri::HTML::Document] texto em XHTML com a remoção dos itens inválidos nas tabelas
    def fix_tables!(content)
      html = Nokogiri::HTML(content)

      # Remove tabela dentro de tabelas
      html.search('table').each do |tab|
        tab.search('table').remove
      end

      # Remove tags h1, h2, h3, h4, h5 das tabelas
      html.search('table').each do |t|
        t.replace t.to_s.gsub(/<h[0-9]\b[^>]*>/, '').gsub('</h>', '')
      end

      # Remove parágrafos dentro das tabelas, se tiver parágrafo não renderiza corretamente
      html.search('table').each do |tab|
        tab.replace tab.to_s.gsub(/<p\b[^>]*>/, '').gsub('</p>', '')
      end

      # Remove espaço extra no inicio e final da celula da tabela
      html.search('td').each do |cell|
        cell.inner_html = cell.inner_html.strip
      end

      # Remove bullets dentro das tabelas
      html.search('table').each do |tab|
        tab.replace tab.to_s.gsub('<ul>', '').gsub('</ul>', '').gsub('<li>', '').gsub('</li>', '')
      end

      html
    end

    # Converte um documento manipulado pelo Nokogiri como HTML para XHTML e depois para XML
    # @return [Nokogiri::XML::Document]
    def convert_to_xml(nokogiri_html)
      Nokogiri::XML(nokogiri_html.to_xhtml)
    end
  end
end