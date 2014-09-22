# encoding: utf-8
namespace :tcc do

  desc 'Sincroniza pessoas e cria o TCC'
  task :sync => :environment do
    TccDefinition.all do |tccd|
      sync = SyncTcc.new(tccd)
      sync.call
    end
  end

end