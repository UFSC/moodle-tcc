# encoding: utf-8
namespace :tcc do
  desc 'Cria todos os TCCs das turmas'

  task :load_all => :environment do
    #Turma A
    populate_tccs('20131', 1)

    #Turma B
    populate_tccs('20132', 1)
  end

  #
  # Salva o Tcc de todos os alunos da turma indicada
  #
  def populate_tccs(turma, tcc_definition_id)
    tcc_definition = TccDefinition.find(tcc_definition_id)
    matriculas = get_matriculas_turma(turma)

    matriculas.with_progress "Criando os TCCs" do |aluno|

      user = Remote::MoodleUser.find_by_username(aluno.matricula)

      unless Tcc.find_by_moodle_user(user.id)
        group = TutorGroup.get_tutor_group(aluno.matricula)

        Tcc.create( moodle_user: user.id,
                    name: user.firstname+' '+user.lastname,
                    tutor_group: group,
                    tcc_definition: tcc_definition )
      end
    end
  end

  #
  # Busca as matrículas dos alunos da turma indicada
  #
  def get_matriculas_turma(turma)
    puts 'Buscando matrículas dos alunos da turma: '+turma

    # Carrega o banco do moodel
    moodle_config = YAML.load_file("#{Rails.root}/config/moodle.yml")['moodle']
    Remote::MoodleUser.establish_connection moodle_config

    Middleware::Unasus2Alunos.find_all_by_periodo_ingresso(turma, select: 'matricula')
  end
end
