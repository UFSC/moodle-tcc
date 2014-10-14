# encoding: utf-8
namespace :tcc do
  desc 'Popula os grade items no moodle'
  task :populate_grade_items, [:courseid, :itemname, :lti_id, :itemnumber] => :environment do |t, args|

    # ID do portfolio da turma A (2013) : 5
    # ID do portfolio da turma B (2013) : 2

    # Tasks necessárias
    # Turma A
    # rake tcc:populate_grade_items[101,'Eixo 1',5,1]
    # rake tcc:populate_grade_items[101,'Eixo 2',5,2]
    # rake tcc:populate_grade_items[101,'Eixo 3',5,3]

    # Turma B
    # rake tcc:populate_grade_items[102,'Eixo 1',2,1]
    # rake tcc:populate_grade_items[102,'Eixo 2',2,2]
    # rake tcc:populate_grade_items[102,'Eixo 3',2,3]

    puts '[WS Moodle] Acessando Web Service para criar itens de nota'
    MoodleAPI::MoodleGrade.populate_grade_items(args[:courseid], args[:itemname], args[:lti_id], args[:itemnumber])
  end

end