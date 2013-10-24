# encoding: utf-8
namespace :tcc do

  desc 'TCC | Realiza procedimentos de sincronização na ordem correta'
  task :sync => [:update_orientador, :update_email]

  desc 'TCC | Cria todos os TCCs das turmas'
  task :load_all, [:turma, :tcc_definition_id] => :environment do |t, args|
    #Turma A '20131', 1
    #Turma B '20132', 2
    populate_tccs(args[:turma], args[:tcc_definition_id])
  end

  desc 'TCC | Cria um HubTcc para cada HubPortfolio existente'
  task :update_hubs => :environment do

    Tcc.all.with_progress 'Criando HubTcc a partir do HubPortfolio existente' do |tcc|

      # Check if HubTcc's are there, if not they must be created
      if tcc.hubs.hub_tcc.count == 0
        # Each HubPortfolio must have its HubTcc match
        tcc.hubs.hub_portfolio.each do |hub_port|
          hub_tcc = tcc.hubs.build(tcc: tcc, hub_definition: hub_port.hub_definition, position: hub_port.hub_definition.position, type: 'HubTcc')
          # FIXME: STI não está preservando o type no momento do build, o workaround abaixo "resolve" temporariamente
          hub_tcc.type = 'HubTcc'
          hub_tcc.save
        end
      end
    end

  end

  desc 'TCC | Realiza a atualização do TCC Definition em cada TCC'
  task :update_definitions => :environment do

    Tcc.all.with_progress 'Atualizando TCCs baseado no TCC Definition associado' do |tcc|
      tcc.send(:create_or_update_hubs)
    end

  end

  desc 'TCC | Atualiza os orientadores responsáveis pelos TCCs com base no Middleware'
  task :update_orientador => :environment do

    failed = []
    Tcc.all.with_progress 'Atualizando orientador responsável pelos TCCs' do |tcc|
      matricula = MoodleUser.find_username_by_user_id(tcc.moodle_user)
      orientador_cpf = OrientadorGroup.find_orientador_by_matricula_aluno(matricula)

      if orientador_cpf
        tcc.email_orientador = Middleware::Usuario.where(:username => orientador_cpf).first.email
        tcc.save!
      end

      tcc.orientador = orientador_cpf
      tcc.save!
    end

    unless failed.empty?
      puts
      puts Terminal::Table.new headings: ['Matrícula Aluno'], rows: failed
      puts "#{failed.count} alunos sem orientador"
    end

  end

  desc 'TCC | Atualiza os emails de estudantes e orientadores'
  task :update_email => :environment do
    # Carrega a tabela user do Moodle
    moodle_config = YAML.load_file("#{Rails.root}/config/moodle.yml")['moodle']

    Remote::MoodleUser.establish_connection moodle_config

    failed = []
    Tcc.all.with_progress 'Atualizando emails' do |tcc|

      matricula = MoodleUser.find_username_by_user_id(tcc.moodle_user)
      orientador_cpf = OrientadorGroup.find_orientador_by_matricula_aluno(matricula)
      usuario_orientador = Middleware::Usuario.where(:username => orientador_cpf).first

      if usuario_orientador.nil?
        failed << [matricula, orientador_cpf]
      else
        orientador_email = usuario_orientador.email
        user = Remote::MoodleUser.find_by_username(matricula)

        if tcc.email_orientador.nil? || tcc.email_orientador.blank?
          tcc.email_orientador = orientador_email if orientador_cpf
        end

        if tcc.email_estudante.nil? || tcc.email_estudante.blank?
          tcc.email_estudante = user.email if user
        end

        tcc.save!
      end

    end

    unless failed.empty?
      puts
      puts Terminal::Table.new headings: ['Matrícula Aluno', 'CPF Orientador'], rows: failed
      puts "#{failed.count} registros falharam"
    end

  end


  #
  # Salva o Tcc de todos os alunos da turma indicada
  #
  def populate_tccs(turma, tcc_definition_id)
    tcc_definition = TccDefinition.find(tcc_definition_id)
    matriculas = get_matriculas_turma(turma)

    result = []
    matriculas.with_progress 'Processando alunos para geração de TCCs' do |aluno|
      user = Remote::MoodleUser.find_by_username(aluno.matricula)
      unless Tcc.find_by_moodle_user(user.id)
        group = TutorGroup.get_tutor_group(aluno.matricula)
        orientador_cpf = OrientadorGroup.find_orientador_by_matricula_aluno(aluno.matricula)
        orientador_email = Middleware::Usuario.where(:username => orientador_cpf).first.email

        tcc = Tcc.new(moodle_user: user.id,
                      name: user.firstname+' '+user.lastname,
                      tutor_group: group,
                      orientador: orientador_cpf,
                      tcc_definition: tcc_definition)

        tcc.email_estudante = user.email
        tcc.email_orientador = orientador_email
        tcc.save

        result << [aluno.matricula, tcc.id]
      end
    end

    # Exibe resumo da operação
    headings = ['Matrícula do usuário', 'Id do TCC']
    table = Terminal::Table.new :headings => headings, :rows => result

    puts table unless result.empty?
    puts "Total de TCCs criados: #{result.count}/#{matriculas.count}"
  end

  #
  # Busca as matrículas dos alunos da turma indicada
  #
  def get_matriculas_turma(turma)
    puts 'Buscando matrículas dos alunos da turma: '+turma

    # Carrega a tabela 'user' do moodle
    moodle_config = YAML.load_file("#{Rails.root}/config/moodle.yml")['moodle']
    Remote::MoodleUser.establish_connection moodle_config

    # Retorna as matriculas
    Middleware::Alunos.find_all_by_periodo_ingresso(turma, select: 'matricula')
  end
end
