# app/services/sync_tcc.rb

class SyncPerson

  def initialize(context)
    @tcc_definition = context
    @errors = {}
    @remote_service = MoodleAPI::MoodleUser.new
  end

  def call
    if @tcc_definition.present?
      process_sync
    else
      register_error(:context, 'vazio', 'Contexto não pode ser vazio')
    end
  end

  def display_errors!
    unless @errors.empty?
      rows = []
      rows << %w(type, attributes, errors)

      @errors.each do |type, error_data|
        error_data.each do |datum|
          rows << [type, datum[:context], datum[:message]]
        end
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
      register_error(:person, person.attributes.to_s, person.errors.messages.to_s)
      return nil
    end

    person
  end

  private

  def process_sync
    get_students
    get_orientadores
    # get_tutores
  end


  def get_students
    tcc_students = @tcc_definition.tccs.select(:student_id).where.not(student_id: nil).includes(:student).distinct

    tcc_students_count = tcc_students.count
    if tcc_students_count <= 0
      register_error(:course, @tcc_definition.course_id, "Curso sem estudantes nos TCCs")

      return nil
    end

    tcc_students.with_progress("Sincronizando #{tcc_students_count} estudantes do curso '#{@tcc_definition.id}/#{@tcc_definition.course_id}' - '#{@tcc_definition.internal_name}'").collect do |tcc|
      find_or_create_person(tcc.student.moodle_id)
    end
  end

  def get_tutores
    tcc_tutores = @tcc_definition.tccs.select(:tutor_id).where.not(tutor_id: nil).includes(:tutor).distinct

    tcc_tutores_count = tcc_tutores.count
    if tcc_tutores_count <= 0
      register_error(:course, @tcc_definition.course_id, "Curso sem tutores nos TCCs")

      return nil
    end

    tcc_tutores.with_progress("Sincronizando #{tcc_tutores_count} tutores do curso '#{@tcc_definition.id}/#{@tcc_definition.course_id}' - '#{@tcc_definition.internal_name}'").collect do |tcc|
      find_or_create_person(tcc.tutor.moodle_id) if tcc.tutor.present?
    end
  end

  def get_orientadores
    tcc_orientadores = @tcc_definition.tccs.select(:orientador_id).where.not(orientador_id: nil).includes(:orientador).distinct

    tcc_orientadores_count = tcc_orientadores.count
    if tcc_orientadores_count <= 0
      register_error(:course, @tcc_definition.course_id, "Curso sem orientadores nos TCCs")

      return nil
    end

    tcc_orientadores.with_progress("Sincronizando #{tcc_orientadores_count} orientadores do curso '#{@tcc_definition.id}/#{@tcc_definition.course_id}' - '#{@tcc_definition.internal_name}'").collect do |tcc|

      find_or_create_person(tcc.orientador.moodle_id) if tcc.orientador.present?
    end
  end

  def register_error(type, context, error_message=nil)
    type = type.to_sym
    @errors[type] = [] unless @errors.has_key? type
    @errors[type] << {context: context, message: error_message}
  end

end