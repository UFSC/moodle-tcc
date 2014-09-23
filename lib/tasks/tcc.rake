# encoding: utf-8
namespace :tcc do

=begin

  O processo de sincronização então será realizado da seguinte forma:

  1. Obter a lista de participantes de um determinado curso X informado no TCCDefinitions
  2. De acordo com o id dos participantes, verificar quem ainda não foi sincronizado e selecionar estes
  3. Realizar a geração inicial do TCC dessas pessoas e proceder com a obtenção de Tutor e Orientador
  responsável pelos mesmos. Caso o Tutor ou Orientador não existam dentro do sistema de TCC, cadastrá-los.
  4. Ao final, verificar quais TCCs ainda estão sem tutor ou orientador, e tentar localizar as
  pessoas responsáveis por estes.

=end

  desc 'TCC | Sincroniza pessoas e cria o TCC'
  task :sync => :environment do
    TccDefinition.all.each do |tccd|
      puts "Sincronização para TCC Definition #{tccd.internal_name}..."

      sync = SyncTcc.new(tccd)
      sync.call
    end
  end


  desc 'TCC | Realiza a atualização do TCC Definition em cada TCC'
  task :update_definitions => :environment do

    Tcc.all.with_progress 'Atualizando TCCs baseado no TCC Definition associado' do |tcc|
      tcc.send(:create_or_update_chapters)
    end

  end
end