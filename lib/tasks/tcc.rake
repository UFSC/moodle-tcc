# encoding: utf-8
namespace :tcc do

  desc 'TCC | Faz a migração dos dados do moodle para o Sistema de TCC'
  task :remote, [:coursemodule_id, :hub_position, :tcc_definition_id] => [:environment] do |t, args|

    moodle_config = YAML.load_file("#{Rails.root}/config/moodle.yml")['moodle']
    Remote::OnlineText.establish_connection moodle_config

    result = Remote::OnlineText.find_by_sql(["
 SELECT DISTINCT u.id as id, u.username as username, u.firstname, u.lastname, ot.onlinetext as text,
                 otv.commenttext as comment, ot.assignment, assub.status, otv.status as status_version,
                 assub.timecreated, otv.timecreated as timecreated_version,
                 g.grade
            FROM assign_submission AS assub
            JOIN assignsubmission_onlinetext AS ot
              ON (ot.submission = assub.id)
       LEFT JOIN assignsubmission_textversion AS otv
              ON (otv.submission = assub.id)
            JOIN user u
              ON (assub.userid = u.id)
            JOIN course_modules cm
              ON (cm.instance = assub.assignment)
            JOIN modules m
              ON (m.id = cm.module AND m.name LIKE 'assign')
       LEFT JOIN assign_grades g
              ON (u.id = g.userid AND g.assignment = assub.assignment)
            WHERE cm.id = ?
            ORDER BY u.username, ot.assignment, otv.timecreated", args[:coursemodule_id]])

    result.with_progress("Migrando #{result.count} tuplas do texto online #{args[:coursemodule_id]} do moodle para eixo #{args[:hub_position]}") do |val|
      user_id = val.id

      created_at = (val.timecreated_version.nil?) ? val.timecreated : val.timecreated_version

      tcc = get_tcc(user_id, args[:tcc_definition_id])

      tcc.tutor_group = TutorGroup::get_tutor_group(val.username)
      tcc.name = "#{val.firstname} #{val.lastname}"

      hub = tcc.hubs.find_or_initialize_by_position(args[:hub_position])

      hub.reflection = val.text
      hub.commentary = val.comment
      hub.grade = val.grade
      hub.created_at = created_at

      # status_onlinetext: draft, submitted
      # status_onlinetextversion: null, evaluation, revision

      #
      # Determinando o estado que o hub deve ficar
      #

      states_to_modify = {'revision' => :sent_to_admin_for_revision, 'evaluation' => :sent_to_admin_for_evaluation}

      case val.status
        when 'submitted'
          if val.status_version.nil?

            # Houve envio e tem nota, está finalizado!
            if !val.grade.nil? && val.grade != -1
              new_state = :admin_evaluation_ok
            else
              # Houve envio e não tem nota, aluno quer nota
              new_state = :sent_to_admin_for_evaluation
            end
          else
            new_state = states_to_modify[val.status]
          end

        when 'draft'
          new_state = :draft
      end


      #
      # Transiciona estados
      #

      case new_state
        when :draft
          to_draft(hub)
        when :sent_to_admin_for_revision
          to_revision(hub)
        when :sent_to_admin_for_evaluation
          to_evaluation(hub)
        when :admin_evaluation_ok
          to_evaluation_ok(hub)
      end

      if hub.valid?
        hub.save!
        tcc.save!
      else
        puts "FALHA: #{hub.errors.inspect}"
      end

    end
  end

  def get_tcc(user_id, tcc_definition_id)
    tcc = Tcc.find_by_moodle_user(user_id)

    if tcc.nil?
      tcc = Tcc.create(:moodle_user => user_id)
      tcc.tcc_definition = TccDefinition.find(tcc_definition_id)
      tcc.save!
    end

    tcc
  end

  def to_draft(hub)
    case hub.aasm_current_state
      when :draft
        # ta certo
      when :revision
        send_back_to_student
      when :evaluation
        send_back_to_student
    end
  end

  def to_revision(hub)
    case hub.aasm_current_state
      when :draft
        hub.send_to_admin_for_revision
    end
  end

  def to_evaluation(hub)
    case hub.aasm_current_state
      when :draft
        hub.send_to_admin_for_evaluation
    end
  end

  def to_evaluation_ok(hub)
    case hub.aasm_current_state
      when :draft
        hub.send_to_admin_for_evaluation
        hub.admin_evaluate_ok
    end
  end

end