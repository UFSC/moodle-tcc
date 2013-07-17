# encoding: utf-8
namespace :tcc do
  desc 'Cria todos os TCCs das turmas'

  task :load_all, [:turma, :tcc_definition_id] => :environment do |t, args|
    #Turma A '20131', 1
    #Turma B '20132', 2
    populate_tccs(args[:turma], args[:tcc_definition_id])
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

    # Carrega a tabela 'user' do moodle
    moodle_config = YAML.load_file("#{Rails.root}/config/moodle.yml")['moodle']
    Remote::MoodleUser.establish_connection moodle_config

    # Carrega a view 'View_UNASUS2_Alunos' do middleware
    middleware = YAML.load_file("#{Rails.root}/config/database.yml")['middleware']
    Middleware::Unasus2Alunos.establish_connection middleware

    # Retorna as matriculas
    Middleware::Unasus2Alunos.find_all_by_periodo_ingresso(turma, select: 'matricula')
  end
end
