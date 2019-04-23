namespace :person do

  desc 'Sincroniza todas as pessoas vinculadas aos TCCs com os dados do Moodle'
  task :sync => :environment do
    TccDefinition.all.each do |tccd|
      puts "=== Sincronização #{tccd.internal_name} ==="
      puts
      sync = SyncPerson.new(tccd)
      sync.call
      sync.display_errors!
      puts
    end
  end

  namespace :sync do

    desc 'Sincroniza todas as pessoas vinculadas aos TCCs com os dados do Moodle'
    task :context, [:tcc_definition_id] => :environment do |t, args|
      tccd = TccDefinition.find(args[:tcc_definition_id].strip)
      puts
      sync = SyncPerson.new(tccd)
      sync.call
      sync.display_errors!
      puts
    end


  end
end
