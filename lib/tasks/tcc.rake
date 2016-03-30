# encoding: utf-8
namespace :tcc do

  desc 'TCC | Sincroniza pessoas e cria o TCC'
  task :sync => :environment do
    TccDefinition.all.each do |tccd|
      if ( tccd.enabled_sync )
        puts "=== Sincronização #{tccd.internal_name} ==="
        puts
        sync = SyncTcc.new(tccd)
        sync.call
        sync.display_errors!
        puts
      end
    end
  end

  desc 'TCC | Realiza a atualização do TCC Definition em cada TCC'
  task :update_definitions => :environment do

    Tcc.all.with_progress 'Atualizando TCCs baseado no TCC Definition associado' do |tcc|
      tcc.send(:create_or_update_chapters)
    end

  end
end

desc 'Clear expired sessions'
task :clear_expired_sessions => :environment do
  puts "=== Cleaning the expired sessions: Starting ==="
  sql = 'DELETE FROM sessions WHERE updated_at < (CURRENT_TIMESTAMP() - INTERVAL 1 DAY + INTERVAL 3 HOUR);' # (GMT)
  ActiveRecord::Base.connection.execute(sql)
  puts "=== Cleaning the expired sessions: Finished ==="
end
