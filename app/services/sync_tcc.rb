# app/services/sync_tcc.rb

class SyncTcc < SyncPerson

  private

  def process_sync
    if @tcc_definition.enabled_sync
      students = get_tcc_students

      unless students.nil?
        students.with_progress "Sincronizando #{students.size} TCCs para #{@tcc_definition.id}/#{@tcc_definition.course_id} - #{@tcc_definition.internal_name}" do |student|
          synchronize_tcc(student)
        end
      end
    end
  end

  def synchronize_tcc(student)
    if student.present?
      tcc = Tcc.find_or_initialize_by(student: student)

      tcc.tcc_definition = @tcc_definition unless tcc.tcc_definition.eql?(@tcc_definition)

      tutor = student.moodle_id.present? ? get_tcc_tutor(student.moodle_id) : nil
      tcc.tutor = tutor unless tcc.tutor.eql?(tutor)

      orientador = student.moodle_id.present? ? get_tcc_orientador(student.moodle_id) : nil
      tcc.orientador = orientador unless tcc.orientador.eql?(orientador)

      if tcc.changed? || !tcc.persisted?
        tcc.save!
      end
    end
  end

  def get_tcc_students
    students = @remote_service.get_students_by_course(@tcc_definition.course_id)

    unless @remote_service.success?
      register_error(:course, @tcc_definition.course_id, @remote_service.error_message)

      return nil
    end

    students.with_progress("Sincronizando #{students.size} estudantes do curso '#{@tcc_definition.id}/#{@tcc_definition.course_id}' - '#{@tcc_definition.internal_name}'").collect do |student_id|
      find_or_create_person(student_id)
    end
  end

  def get_tcc_tutor(student_moodle_id)
    tutor_id = @remote_service.find_tutor_by_studentid(student_moodle_id, @tcc_definition.course_id)

    if !@remote_service.success?
      register_error(:tutor, student_moodle_id, @remote_service.error_message)

      return nil
    elsif tutor_id.nil? # estudante sem tutor atribuído
      register_error(:tutor, student_moodle_id, 'tutor não definido para este estudante')

      return nil
    end

    find_or_create_person(tutor_id)
  end

  def get_tcc_orientador(student_moodle_id)
    orientador_id = @remote_service.find_orientador_responsavel(student_moodle_id, @tcc_definition.course_id)

    if !@remote_service.success?
      register_error(:orientador, student_moodle_id, @remote_service.error_message)

      return nil
    elsif orientador_id.nil? # estudante sem orientador atribuído
      register_error(:orientador, student_moodle_id, 'orientador não definido para este estudante')

      return nil
    end

    find_or_create_person(orientador_id)
  end

end