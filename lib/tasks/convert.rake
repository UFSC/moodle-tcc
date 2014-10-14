# encoding: utf-8
namespace :tcc do

  namespace :citacao do
    desc 'TCC | Converte citaçãoes do formato antigo para o atual'
    task :convert_old => :environment do
      tccs = Tcc.all

      tccs.with_progress("Convertendo #{tccs.count} Tccs") do |tcc|
        tcc.chapters.each do |hub|
          texto = Conversor::convert_text(hub.reflection, tcc)
          hub.reflection = texto
          hub.save!
        end
      end

    end
  end

end