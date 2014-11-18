require 'typhoeus/adapters/faraday'

module TccDocument
  class ImageDownloaderProcessor < BaseProcessor

    # @param [Tcc] tcc
    # @param [Nokogiri::XML::Document] doc
    def initialize(tcc, doc)
      @tcc = tcc
      @doc = doc
      @download_queue = Queue.new
    end

    # Realiza as transformações nas tags de figuras em um documento do Nokogiri
    #

    # @return [Nokogiri::XML::Document] documento com as alterações do processamento de imagens
    def execute

      # Este bloco garante que o somente após todos os downloads terminarem, o código seguinte será executado.
      remote_connection.in_parallel do
        @doc.css('img').map do |img|

          # Create RemoteAsset objects
          remote_asset = RemoteAsset.new(@tcc, img)

          next unless remote_asset.should_fetch_asset?

          if remote_asset.is_cached?
            # Imagem já está em cache, fazer request usando etags para garantir que não houve alteração
            queue_download(remote_asset, revalidate: true)
          else
            # Imagem não está em cache, fazer download assíncrono.
            queue_download(remote_asset)
          end

        end
      end

      # faz o processamento das imagens que foram baixadas, armazena as referências no banco de dados
      until @download_queue.empty?
        persist_asset(@download_queue.pop)
      end

      @doc
    end

    private

    def handle_request(remote_asset)
      if remote_asset.request.success?

        AssetStringIO.new(remote_asset.filename, remote_asset.request.body)
      elsif remote_asset.request.status == 304 # Not-Modified

        # Versão em cache não foi alterada remotamente, substituir o item da dom
        remote_asset.dom_item['src'] = remote_asset.cache.data.url
        remote_asset.dom_item['data-asset-id'] = remote_asset.cache.id

        false
      else

        # Troca a tag da imagem não carregada pela mensagem no pdf
        new_node = Nokogiri::XML::Node.new('p', @doc)
        new_node.content = "[ Imagem do Moodle não carregada: #{remote_asset.filename} ]"
        remote_asset.dom_item.replace new_node
        Rails.logger.error "[Moodle Asset]: Falhou ao tentar transferir #{remote_asset.filename} (#{remote_asset.remote_url})"

        false
      end
    end

    # @param [RemoteAsset] remote_asset
    def persist_asset(remote_asset)

      asset_io = handle_request(remote_asset)
      return unless asset_io

      # Salvar
      asset = MoodleAsset.new
      asset.tcc_id = @tcc.id
      asset.data = asset_io
      asset.etag = remote_asset.request.headers['etag']
      asset.remote_id = remote_asset.remote_asset_id

      if asset.valid? && asset.save!

        # Mudar caminho da imagem para onde foi salvo
        remote_asset.dom_item['src'] = asset.data.url
        remote_asset.dom_item['data-asset-id'] = asset.id
      else
        Rails.logger.error "[Moodle Asset]: Falhou ao tentar salvar a imagem (original: #{remote_asset.remote_url}) (error: #{asset.errors.messages})"
        remote_asset.dom_item['src'] = image_url('images/image-not-found.jpg')
        remote_asset.dom_item['alt'] = "Imagem inválida ou não encontrada. (#{remote_asset.filename})"
      end

    end

    def queue_download(remote_asset, revalidate: false)
      remote_asset.fetch_async!(remote_connection, revalidate)
      @download_queue << remote_asset
    end

    def remote_connection
      @remote_connection ||= Faraday.new(Settings.moodle_url, ssl: {verify: false}) do |faraday|
        faraday.request :url_encoded
        faraday.adapter :typhoeus
      end
    end

  end

  class AssetStringIO < StringIO
    attr_accessor :filepath

    def initialize(*args)
      super(*args[1..-1])
      @filepath = args[0]
    end

    def original_filename
      File.basename(@filepath)
    end
  end

end