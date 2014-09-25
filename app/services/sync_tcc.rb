# app/services/sync_tcc.rb

class SyncTcc

  def initialize(context)
    @tcc_definition = context
    @errors = {people: []}
  end

  def call
    get_students.with_progress 'Sincronizando TCCs' do |student|
      synchronize_tcc(student)
    end
  end

  def display_errors!
    unless @errors[:people].empty?
      rows = []
      rows << %w(Tipo Dados Erros)

      @errors[:people].each do |(person, attributes)|
        rows << ['Person', attributes, person.errors.messages]
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
    person = Person.find_or_initialize_by(moodle_id: moodle_id)

    unless person.persisted?
      attributes = MoodleAPI::MoodleUser.find_users_by_field('id', moodle_id)
      person.moodle_username = attributes.username
      person.email = attributes.email
      person.name = attributes.name

      unless person.valid? && person.save
        @errors[:people] << [person, attributes]
        return false
      end
    end

    person
  end

  def get_students
    students = MoodleAPI::MoodleUser.get_students_by_course(@tcc_definition.course_id)
    students.with_progress("Sincronizando estudantes do curso '#{@tcc_definition.course_id}'").collect do |student_id|
      find_or_create_person(student_id)
    end
  end

  def get_tutor(student)
    tutor_id = MoodleAPI::MoodleUser.find_tutor_by_studentid(student, @tcc_definition.course_id)
    find_or_create_person(tutor_id)
  end

  def get_orientador(student)
    orientador_id = MoodleAPI::MoodleUser.find_orientador_responsavel(student, @tcc_definition.course_id)
    find_or_create_person(orientador_id)
  end

end