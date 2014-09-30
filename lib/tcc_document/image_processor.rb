module TccDocument
  class ImageProcessor

    def invalid_image_src
      "#{Rails.root}/app/assets/images/image-not-found.jpg"
    end

    # Realiza as transformações nas tags de figuras em um documento do Nokogiri
    #
    # @param [Nokogiri::XML]
    def execute(doc)

      # Inserir class figure nas imagens e resolver caminho
      doc.css('img').map do |img|
        img['class'] = 'figure'

        if img['src'] =~ /@@TOKEN@@/
          # precisamos substituir @@TOKEN@@ pelo token do usuário do Moodle
          img['src'] = img['src'].gsub('@@TOKEN@@', Settings.moodle_token)
          # é feito unescape e depois escape para garantir que a url estará correta
          # essa maneira é estranha, mas evita problemas :)
          img['src'] = URI.escape(URI.unescape(img['src']))
        elsif img['src'] !~ URI::regexp
          next if img['src'].nil?
          img['src'] = File.join(Rails.public_path, img['src'])
          # Se a URL contiver espaços ou caracter especial, deve ser decodificada
          img['src'] = URI.unescape(img['src'])
        else
          # FIXME: Esta linha provavelmente é um erro de digitação, verificar se ela ainda é necessária
          src = (URI.unescape(img['src']))
          original_filename = File.basename(URI.parse(img['src']).path.to_s)

          img['src'] = invalid_image_src
          img['alt'] = "Imagem invalida ou nao encontrada. - #{LatexToPdf.escape_latex(original_filename)}"
        end

      end

      doc
    end

  end
end