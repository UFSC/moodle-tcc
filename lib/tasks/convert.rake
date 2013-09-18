namespace :tcc do

  namespace :citacao do
    desc 'TCC | Converte citaçãoes do formato antigo para o atual'
    task :convert => :environment do
      tccs = Tcc.all

      tccs.with_progress("Convertendo #{tccs.count} Tccs") do |tcc|
        tcc.hubs.each do |hub|
          next unless Conversor::old?(hub.reflection)
          texto = Nokogiri::HTML(hub.reflection)

          texto.search('citacao').each do |c|
            attr = Conversor::get_attributes(c)
            new_text = Conversor::get_citacao(tcc, attr)

            c[:content] = new_text unless new_text.empty?
            c.content = new_text unless new_text.empty?
            c[:title] = new_text unless new_text.empty?
          end

          texto = texto.to_xml.sub("<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\" \"http://www.w3.org/TR/REC-html40/loose.dtd\">\n<html><body>", '')
          texto = texto.sub("</body>", '')
          texto = texto.sub("</html>", '')
          hub.reflection = texto
          hub.save!
        end
      end

    end
  end

end