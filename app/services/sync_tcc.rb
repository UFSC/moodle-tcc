# app/services/sync_tcc.rb

class SyncTcc

  def initialize(context)
    @tcc_definition = context
    @errors = {}
    @remote_service = MoodleAPI::MoodleUser.new
  end

  def call
    students = get_students

    unless students.nil?
      students.with_progress "Sincronizando #{students.size} TCCs para #{@tcc_definition.internal_name}" do |student|
        synchronize_tcc(student)
      end
    end
  end

  def display_errors!
    unless @errors.empty?
      rows = []
      rows << %w(type, attributes, errors)

      @errors.each do |type, (error_data)|
        rows << [type, error_data[:context], error_data[:message]]
      end

      puts Terminal::Table.new rows: rows
    end
  end

  def find_or_create_person(moodle_id)
    raise ArgumentError, 'É necessário passar um moodle_id' if moodle_id.nil?

    person = Person.find_or_initialize_by(moodle_id: moodle_id)

    # sempre atualiza os dados da pessoa
    attributes = @remote_service.find_users_by_field('id', moodle_id)
    if !@remote_service.success?
      register_error(:person, moodle_id, @remote_service.error_message)

      return nil
    elsif attributes.nil? # pessoa não encontrada no Moodle
      register_error(:person, moodle_id, 'pessoa não encontrada no Moodle')

      return nil
    end

    person.attributes = {moodle_username: attributes.username, email: attributes.email, name: attributes.name}

    unless person.valid? && person.save
      register_error(:person, person.attributes, person.error.messages)
      return nil
    end

    person
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

  def get_students
    students = @remote_service.get_students_by_course(@tcc_definition.course_id)

    unless @remote_service.success?
      register_error(:course, @tcc_definition.course_id, @remote_service.error_message)

      return nil
    end

    students.with_progress("Sincronizando #{students.size} estudantes do curso '#{@tcc_definition.course_id}'").collect do |student_id|
      find_or_create_person(student_id)
    end
  end

  def get_tutor(student)
    tutor_id = @remote_service.find_tutor_by_studentid(student, @tcc_definition.course_id)

    if !@remote_service.success?
      register_error(:tutor, student, @remote_service.error_message)

      return nil
    elsif tutor_id.nil? # estudante sem tutor atribuído
      register_error(:tutor, student, 'tutor não definido para este estudante')

      return nil
    end

    find_or_create_person(tutor_id)
  end

  def get_orientador(student)
    orientador_id = @remote_service.find_orientador_responsavel(student, @tcc_definition.course_id)

    if !@remote_service.success?
      register_error(:orientador, student, @remote_service.error_message)

      return nil
    elsif orientador_id.nil? # estudante sem orientador atribuído
      register_error(:orientador, student, 'orientador não definido para este estudante')

      return nil
    end

    find_or_create_person(orientador_id)
  end

  def register_error(type, context, error_message=nil)
    type = type.to_sym
    @errors[type] = [] unless @errors.has_key? type
    @errors[type] << {context: context, message: error_message}
  end

end