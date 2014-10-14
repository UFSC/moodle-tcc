# app/services/sync_tcc.rb

class SyncTcc

  def initialize(context)
    @tcc_definition = context
    @errors = {person: [], tutor: [], orientador: []}
    @remote_service = MoodleAPI::MoodleUser.new
  end

  def call
    get_students.with_progress 'Sincronizando TCCs' do |student|
      synchronize_tcc(student)
    end
  end

  def display_errors!
    unless @errors[:person].empty? && @errors[:tutor].empty? && @errors[:orientador].empty?
      rows = []
      rows << %w(type, attributes, errors)

      @errors[:person].each do |person|
        rows << ['Person', person.attributes, person.errors.messages]
      end

      @errors[:tutor].each do |student|
        rows << ['Tutor', student, 'tutor não definido para este estudante']
      end

      @errors[:orientador].each do |student|
        rows << ['Orientador', student, 'orientador não definido para este estudante']
      end

      puts Terminal::Table.new rows: rows
    end
  end

  private

  def synchronize_tcc(student)
    tcc = Tcc.find_or_initialize_by(student: student)

    tcc.tcc_definition = @tcc_definition
    tutor = get_tutor(student.moodle_id)
    tcc.tutor = tutor

    orientador = get_orientador(student.moodle_id)
    tcc.orientador = orientador

    tcc.save! if tcc.changed? || !tcc.persisted?
  end

  def find_or_create_person(moodle_id)
    raise ArgumentError.new('É necessário passar um moodle_id') if moodle_id.nil?

    person = Person.find_or_initialize_by(moodle_id: moodle_id)

    # Só busca os dados do usuário se ele ainda foi criado
    unless person.persisted?
      attributes = @remote_service.find_users_by_field('id', moodle_id)
      person.attributes = {moodle_username: attributes.username, email: attributes.email, name: attributes.name}

      unless person.valid? && person.save
        @errors[:person] << [person]
        return nil
      end
    end

    person
  end

  def get_students
    students = @remote_service.get_students_by_course(@tcc_definition.course_id)
    students.with_progress("Sincronizando estudantes do curso '#{@tcc_definition.course_id}'").collect do |student_id|
      find_or_create_person(student_id)
    end
  end

  def get_tutor(student)
    tutor_id = @remote_service.find_tutor_by_studentid(student, @tcc_definition.course_id)

    # Se o estudante não tiver um estudante atribuído, vamos salvar a informação para exibir depois
    if tutor_id.nil?
      @errors[:tutor] << student
      return nil
    end

    find_or_create_person(tutor_id)
  end

  def get_orientador(student)
    orientador_id = @remote_service.find_orientador_responsavel(student, @tcc_definition.course_id)

    # Se o estudante não tiver um orientador atribuído, vamos salvar a informação para exibir depois
    if orientador_id.nil?
      @errors[:orientador] << student
      return nil
    end

    find_or_create_person(orientador_id)
  end

end