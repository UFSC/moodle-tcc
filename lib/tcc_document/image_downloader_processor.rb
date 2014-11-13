require 'typhoeus/adapters/faraday'

module TccDocument
  class ImageDownloaderProcessor < BaseProcessor

    def initialize(tcc)
      @tcc = tcc
      @download_list = []
    end

    # Realiza as transformações nas tags de figuras em um documento do Nokogiri
    #
    # @param [Nokogiri::XML::Document] doc
    # @return [Nokogiri::XML::Document] documento com as alterações do processamento de imagens
    def execute(doc)

      # verifica toda as imagens, verifica o cache e faz o download daquelas que ainda não estão em disco
      remote_connection.in_parallel do
        doc.css('img').map do |img|
          remote_url = retrive_url(img)

          if should_fetch_image?(remote_url)

            # Verificar se imagem está em cache e se existe no sistema
            cache = MoodleAsset.find_by(tcc_id: tcc_id, data_file_name: remote_img.basename)
            if !cache.blank? && File.exist?(File.join(moodle_dir, cache.data_file_name))
              # Imagem já está em cache, trocar caminho
              img['src'] = cache.data.content.file
            else
              # Imagem não está em cache, recuperar
              queue_download(img, remote_url)
            end

          end
        end
      end

      # faz o processamento das imagens que foram baixadas, armazena as referências no banco de dados
      @download_list.each do |item|
        fetch_image(item)
      end

      doc
    end

    private

    def retrive_url(img)
      url = img['src']

      # precisamos substituir @@TOKEN@@ pelo token do usuário do Moodle
      url.gsub!('@@TOKEN@@', Settings.moodle_token) if url =~ /@@TOKEN@@/

      Addressable::URI.parse(url).normalize!
    end

    def remote_connection
      @remote_connection ||= Faraday.new(Settings.moodle_url, :ssl => {:verify => false}) do |faraday|
        faraday.request :url_encoded
        faraday.adapter :typhoeus
      end
    end

    def should_fetch_image?(url)
      # possui um protocolo válido?
      %w(http https).include? url.scheme
    end

    def queue_download(image_dom, remote_url)
      @download_list << {dom: image_dom, request: remote_connection.get(remote_url)}
    end

    def fetch_image(item)
      original_src = item[:dom]['src']
      original_filename = File.basename(URI.parse(item[:dom]['src']).path)
      file, filename = create_file_to_upload(item, doc)

      # se houver algum problema com a transferência, vamos ignorar e processar o próximo
      unless file
        Rails.logger.error "[Moodle Asset]: Falhou ao tentar transferir #{filename} (#{item[:dom]['src']})"
        return false
      end

      begin
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
      File.delete(filename)
    end


    def create_file_to_upload(item, doc)
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

    def download_dir
      File.join(Rails.public_path, 'uploads', 'moodle', 'pictures', tcc.id.to_s)
    end
  end
end