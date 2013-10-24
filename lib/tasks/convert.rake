namespace :tcc do

  namespace :citacao do
    desc 'TCC | Converte citaçãoes do formato antigo para o atual'
    task :convert_old => :environment do
      tccs = Tcc.all

      tccs.with_progress("Convertendo #{tccs.count} Tccs") do |tcc|
        tcc.hubs.each do |hub|
          next unless Conversor::old?(hub.reflection)
          texto = Conversor::convert_text(hub.reflection, tcc)
          hub.reflection = texto
          hub.save!
        end
      end

    end
    desc 'TCC | Adiciona reference_id às citações'
    task :add_reference_id => :environment do
      tccs = Tcc.all
      tccs.with_progress("Convertendo #{tccs.count} Tccs") do |tcc|
        tcc.hubs.each do |hub|
          texto = Conversor::add_reference_id(hub.reflection, tcc)
          hub.reflection = texto
          hub.save!
        end
      end

    end
  end

end