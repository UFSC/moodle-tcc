# encoding: utf-8
namespace :tcc do

  desc 'TCC | Faz a migração dos dados do moodle para o Sistema de TCC'
  task :remote, [:coursemodule_id, :hub_position, :tcc_definition_id] => [:environment] do |t, args|

    moodle_config = YAML.load_file("#{Rails.root}/config/moodle.yml")['moodle']
    Remote::OnlineText.establish_connection moodle_config

    result = Remote::OnlineText.find_by_sql(["SELECT DISTINCT u.id as id, u.username as username, ot.onlinetext as text, ot.commenttext as comment, ot.assignment, ot.status, ot.timecreated, g.grade
        FROM assignsubmission_textversion AS ot
        JOIN assign_submission AS assub
          ON (ot.submission = assub.id)
        JOIN user u
          ON (assub.userid = u.id)
        JOIN course_modules cm
          ON (cm.instance = ot.assignment)
        JOIN modules m
          ON (m.id = cm.module AND m.name LIKE 'assign')
        LEFT JOIN assign_grades g
          ON (u.id = g.userid AND g.assignment = ot.assignment)
        WHERE cm.id = ?
        ORDER BY u.username, ot.assignment, ot.timecreated;", args[:coursemodule_id]])
    user_id = nil

    result.with_progress("Migrando #{result.count} tuplas do texto online #{args[:coursemodule_id]} do moodle para eixo #{args[:hub_position]}") do |val|
      # Consulta ordenada por usuário
      if user_id != val.id
        user_id = val.id
      end

      tcc = get_tcc(user_id, args[:tcc_definition_id])

      tcc.tutor_group = TutorGroup::get_tutor_group(val.username)

      hub = tcc.hubs.find_or_initialize_by_position(args[:hub_position])

      hub.reflection = val.text
      hub.commentary = val.comment
      hub.grade = val.grade

      #
      # Determinando o estado que o hub deve ficar
      #
      states_to_modify = {nil => :draft, 'revision' => :sent_to_admin_for_revision, 'evaluation' => :sent_to_admin_for_evaluation}

      if !val.grade.nil? && val.grade != -1
        hub_current_state = :admin_evaluation_ok
      else
        hub_current_state = states_to_modify[val.status]
      end

      case hub.aasm_current_state
        when :draft
          to_draft(hub, hub_current_state)
        when :sent_to_admin_for_revision
          to_revision(hub, hub_current_state)
        when :sent_to_admin_for_evaluation
          to_evaluation(hub, hub_current_state)
      end

      if hub.valid?
        hub.save!
        tcc.save!
      else
        hub.errors
      end

    end
  end

  def get_tcc(user_id, tcc_definition_id)
    tcc = Tcc.find_by_moodle_user(user_id)

    unless tcc.nil?
      tcc = Tcc.create(:moodle_user => user_id)
      tcc.tcc_definition = TccDefinition.find(tcc_definition_id)
      tcc.save!
    end

    tcc
  end

  def to_draft(hub, current_state)
    case current_state
      when :sent_to_admin_for_revision
        hub.send_to_admin_for_revision
      when :sent_to_admin_for_evaluation
        hub.send_to_admin_for_evaluation
      when :admin_evaluation_ok
        hub.send_to_admin_for_evaluation
        hub.admin_evaluate_ok
    end
  end

  def to_revision(hub, current_state)
    case current_state
      when :draft
        hub.send_back_to_student
      when :sent_to_admin_for_evaluation
        hub.send_to_admin_for_evaluation
      when :admin_evaluation_ok
        hub.send_to_admin_for_evaluation
        hub.admin_evaluate_ok
    end
  end

  def to_evaluation(hub, current_state)
    case current_state
      when :draft
        hub.send_back_to_student
      when :sent_to_admin_for_revision
        hub.send_back_to_student
        hub.send_to_admin_for_revision
      when :admin_evaluation_ok
        hub.admin_evaluate_ok
    end
  end

end