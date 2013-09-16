# encoding: utf-8
namespace :tcc do
  desc 'Popula os grade items no moodle'
  task :populate_grade_items, [:courseid, :itemname, :lti_id, :itemnumber] => :environment do |t, args|
    puts '[WS Moodle] Acessando Web Service para criar itens de nota'
    MoodleGrade.populate_grade_items(args[:courseid], args[:itemname], args[:lti_id], args[:itemnumber])
  end

end