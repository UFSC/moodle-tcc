# encoding: utf-8
namespace :tcc do
  desc 'Popula os grade items no moodle'
  task :populate_grade_items, [:courseid, :itemname] => :environment do |t, args|
    puts '[WS Moodle] Acessando Web Service para criar itens de nota'
    RestClient.post(TCC_CONFIG['server'],
                    :wsfunction => 'local_wstcc_create_grade_item',
                    :courseid => args[:courseid],
                    :itemname => args[:itemname],
                    :grademin => 0,
                    :grademax => 100,
                    :wstoken => TCC_CONFIG['token']) do |response|
    end
  end

end