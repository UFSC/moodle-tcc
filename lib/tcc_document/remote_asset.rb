module TccDocument
  class RemoteAsset

    attr_accessor :request, :dom_item

    def initialize(tcc, dom_item)
      @tcc = tcc
      @dom_item = dom_item
    end

    def cache
      @cache ||= MoodleAsset.find_by(tcc_id: @tcc.id, remote_id: remote_asset_id)
    end

    # @param [Faraday::Connection] remote_connection
    # @param [Boolean] revalidate
    def fetch_async!(remote_connection, revalidate)
      if revalidate
        @request = remote_connection.get(remote_url, nil, {:'If-None-Match' =>  cache.etag})
      else
        @request = remote_connection.get(remote_url)
      end

    end

    def filename
      URI.decode(remote_url.basename)
    end

    # Verificar se imagem está em cache e se existe no filesystem
    def is_cached?
      cache && File.exist?(cache.data.path)
    end

    def remote_url
      @remote_url ||= retrieve_url
    end

    def remote_asset_id
      @remote_asset_id ||= retrieve_asset_id
    end

    def should_fetch_asset?
      # possui um protocolo válido?
      %w(http https).include? remote_url.scheme
    end

    private

    # @return [String] filepath where download assets should be stored based on current TCC
    def download_dir
      File.join(Rails.public_path, 'uploads', 'moodle', 'pictures', @tcc.id.to_s)
    end

    def retrieve_url
      url = @dom_item['src']

      # precisamos substituir @@TOKEN@@ pelo token do usuário do Moodle
      url.gsub!('@@TOKEN@@', Settings.moodle_token) if url =~ /@@TOKEN@@/

      Addressable::URI.parse(url).normalize!
    end

    # Will extract asset id from a Moodle URL
    def retrieve_asset_id
      # Format: "/webservice/pluginfile.php/000/assignsubmission_onlinetext/submissions_onlinetext/000/file.jpg
      pattern = /\/assignsubmission_onlinetext\/submissions_onlinetext\/([0-9]+)\//
      match = pattern.match(remote_url.path)

      match ? match[1] : false
    end

  end
end