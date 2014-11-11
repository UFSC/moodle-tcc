# encoding: utf-8

require 'typhoeus/adapters/faraday'

module TccLatex

  def self.apply_latex(text)
    # XHTML bem formatado e com as correções necessárias para não atrapalhar o documento final do LaTex
    xml = TccDocument::HTMLProcessor.new.execute(text)

    # Realiza transformações nas tags de imagem
    xml = TccDocument::ImageProcessor.new.execute(xml)

    # Download das figuras do Moodle e transformação em cópias locais
    # download_figures(tcc, xml)

    # Aplicar XSLT para obter um arquivo LaTeX
    latex = TccDocument::DocumentProcessor.new.execute(xml)

    latex
  end

  def self.download_figures(tcc, doc)
    process = []
    tmp_files = []

    # Definicao de Tcc id e Diretorios
    tcc_id = tcc.id
    moodle_dir = File.join(Rails.public_path, 'uploads', 'moodle', 'pictures', tcc_id.to_s)

    # Requisição das imagens
    conn = Faraday.new(Settings.moodle_url, :ssl => {:verify => false}) do |faraday|
      faraday.request :url_encoded
      faraday.adapter :typhoeus
    end

    conn.in_parallel do
      doc.css('img').map do |img|
        remote_img = img['src']

        if remote_img =~ URI::regexp(%w(http https))
          remote_filename = File.basename(URI.parse(remote_img).path)
          cache = MoodleAsset.where(tcc_id: tcc_id, data_file_name: remote_filename).first

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
      original_src = item[:dom]['src']
      original_filename = File.basename(URI.parse(item[:dom]['src']).path)
      file, filename = create_file_to_upload(item, doc)

      # se houver algum problema com a transferência, vamos ignorar e processar o próximo
      unless file
        Rails.logger.error "[Moodle Asset]: Falhou ao tentar transferir #{filename} (#{item[:dom]['src']})"
        next
      end

      tmp_files << filename

      # Salvar
      asset = MoodleAsset.new
      asset.tcc_id = tcc_id
      asset.data = file

      if asset.valid?
        asset.save

        # Mudar caminho da imagem para onde foi salvo
        item[:dom]['src'] = asset.data.current_path
      else
        Rails.logger.error "[Moodle Asset]: Falhou ao tentar salvar a imagem (original: #{original_src}) (error: #{asset.errors.messages})"
        item[:dom]['src'] = "#{Rails.root}/app/assets/images/image-not-found.jpg"
        item[:dom]['alt'] = "Imagem invalida ou nao encontrada. - #{LatexToPdf.escape_latex(original_filename)}"
      end

      file.close
    end

  ensure
    tmp_files.each { |tmp_file| File.delete(tmp_file) }
  end

  def self.create_file_to_upload(item, doc)
    # Setup temporary directory
    app_name = Rails.application.class.parent_name.parameterize
    tmp_dir = File.join(Dir::tmpdir, "#{app_name}_#{Time.now.to_i}_#{SecureRandom.hex(12)}")
    Dir.mkdir(tmp_dir)

    if item[:request].status == 200
      # Criar imagem tmp
      url = URI.parse item[:dom]['src']
      filename = File.join tmp_dir, File.basename(url.path)
      file = File.open(filename, 'wb')
      file.write(item[:request].body)
    else
      file = false
      filename = item[:dom]['src'].split('?')[0].split('/').last

      # Troca a tag da imagem não carregada pela mensagem no pdf
      new_node = Nokogiri::XML::Node.new('p', doc)
      new_node.content = "[ Imagem do Moodle não carregada: #{filename} ]"
      item[:dom].replace new_node
    end

    return file, filename
  end

end
