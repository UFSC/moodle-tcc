# encoding: utf-8

require 'typhoeus/adapters/faraday'

module TccLatex
  unloadable

  def self.latex_path
    File.join(Rails.root, 'latex')
  end

  def self.apply_latex(tcc, text)
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
    docx = download_figures(tcc, doc)

    #Simula rowspan
    doc = fix_rowspan(doc)

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

    # Remove caracter &nbsp antes da conversão de HTML Entities
    text = text.gsub('&nbsp;', ' ')
    text = text.gsub(/\u00a0/, ' ')

    # Converte caracteres HTML entities para equivalente em utf8
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

    # Remove parágrafos dentro das tabelas, se tiver parágrafo não renderiza corretamente
    html.search('table').each do |t|
      t.replace t.to_s.gsub(/<p\b[^>]*>/, '').gsub('</p>', '')
    end

    # Remove espaço extra no inicio e final da celula da tabela
    html.search('td').each do |cell|
      cell.inner_html = cell.inner_html.strip
    end

    return html
  end

  def self.fix_rowspan(html)
    td_position = Array.new
    tr_position = 0
    rowspan = 0

    html.search('tr').each_with_index do |tr, current_tr_position|
      tr.search('td').each_with_index do |td, current_td_position|
        #Verifica se a linha e a célula devem receber espaço em branco
        if tr_position > (current_tr_position - rowspan) and td_position.include? current_td_position
          td.replace "<td></td>" + td.to_s
        end

        if td.to_s.include? "rowspan"
          rowspan = td.xpath('@rowspan').first.value.to_i

          #Salva posição da linha que tenha rowspan
          tr_position = current_tr_position
          #Salva posição da célular que tenha rowspan
          td_position.push(current_td_position)
        end
      end
    end

    return html
  end

  def self.generate_references(content)
    # Criar arquivo de referência
    doc = Nokogiri::XML(content)

    # Aplicar xslt
    xh2file = File.read(File.join(self.latex_path, 'xh2bib.xsl'))
    xslt = Nokogiri::XSLT(xh2file)
    content = xslt.apply_to(doc)

    # Salvar arquivo bib no tmp
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

    # Inserir class figure nas imagens e resolver caminho
    doc.css('img').map do |img|
      img['class'] = 'figure'

      if img['src'] =~ /@@PLUGINFILE@@/
        img['src'] = img['src'].gsub('@@PLUGINFILE@@', '')
        img['src'] = "Imagem do Moodle: #{img['src']}"
      elsif img['src'] =~ /@@TOKEN@@/
        # precisamos substituir @@TOKEN@@ pelo token do usuário do Moodle
        img['src'] = img['src'].gsub('@@TOKEN@@', TCC_CONFIG['token'])
      elsif img['src'] !~ URI::regexp
        img['src'] = File.join(Rails.public_path, img['src'])
      end

      # Se a URL contiver espaços ou caracter especial, deve ser decodificada
      img['src'] = URI.unescape(img['src'])

      # Extrai as tuplas de estilo inline
      img_attributes = extract_style_attributes(img)
      img['width'] = img_attributes[:width] if img_attributes.has_key? :width
      img['height'] = img_attributes[:height] if img_attributes.has_key? :height
    end

    return doc
  end

  def self.download_figures(tcc, doc)
    conn = Faraday.new(:url => 'http://ufsc.br') do |faraday|
      faraday.adapter :typhoeus
    end

    #Definicao de Tcc id e Diretorios
    tcc_id = tcc.id
    app_name = Rails.application.class.parent_name.parameterize
    moodle_dir = File.join(Rails.public_path, 'uploads', 'moodle', 'pictures', tcc_id.to_s)

    # Requisição das imagens
    process = []
    tmp_files = []

    conn.in_parallel do
      doc.css('img').map do |img|
        remote_img = img['src']

        if remote_img =~ URI::regexp(%w(http https))
          cache = MoodleAsset.where(tcc_id: tcc_id, data_file_name: File.basename(remote_img)).first

          # Verificar se imagem está em cache e se existe no sistema
          if !cache.blank? && File.exist?(File.join(moodle_dir, cache.data_file_name))
            img['src'] = cache.data.content.file
          else
            process << {:dom => img, :request => conn.get(remote_img)}
          end

        end

      end
    end

    # Salvar imagens no db
    process.each do |item|
      tmp_dir = File.join(Dir::tmpdir, "#{app_name}_#{Time.now.to_i}_#{rand(100)}")
      Dir.mkdir(tmp_dir)

      #Criar imagem tmp
      url = URI.parse item[:dom]['src']
      filename = File.join tmp_dir, File.basename(url.path)
      file = File.open(filename, 'wb')
      file.write(item[:request].body)
      tmp_files << filename

      #Salvar
      asset = MoodleAsset.new
      asset.tcc_id = tcc_id
      asset.data = file

      if asset.valid?
        asset.save

        # Mudar caminho da imagem para onde foi salvo
        item[:dom]['src'] = asset.data.current_path
      else
        Rails.logger.error "[Moodle Asset]: Falhou ao tentar salvar a imagem (#{asset.errors.messages})"
      end

      file.close
    end

  ensure
    tmp_files.each { |tmp_file| File.delete(tmp_file) }
  end

  def self.extract_style_attributes(img)
    style_attributes = {}

    unless img['style'].nil? || img['style'].empty?
      styles = img['style'].split(';').map { |item| item.strip }

      styles.each do |style_item|
        key, value = style_item.split(':')
        style_attributes[key.to_sym] = value.strip
      end
    end

    return style_attributes
  end

end