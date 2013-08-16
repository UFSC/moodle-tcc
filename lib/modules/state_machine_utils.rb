module StateMachineUtils
  unloadable

  def to_draft(hub)
    case hub.aasm_current_state
      when :sent_to_admin_for_revision
        hub.send_back_to_student
      when :sent_to_admin_for_evaluation
        hub.send_back_to_student
      when :admin_evaluation_ok
        hub.state='draft'
    end
  end

  def to_revision(hub)
    case hub.aasm_current_state
      when :draft
        hub.send_to_admin_for_revision
      when :sent_to_admin_for_evaluation
        hub.send_back_to_student
        hub.send_to_admin_for_revision
      when :admin_evaluation_ok
        hub.state='draft'
        hub.send_to_admin_for_revision
    end
  end

  def to_evaluation(hub)
    case hub.aasm_current_state
      when :draft
        hub.send_to_admin_for_evaluation
      when :send_to_admin_for_revision
        hub.send_back_to_student
        hub.send_to_admin_for_evaluation
      when :admin_evaluation_ok
        hub.state='draft'
        hub.send_to_admin_for_evaluation
    end
  end

  def to_evaluation_ok(hub)
    case hub.aasm_current_state
      when :draft
        hub.send_to_admin_for_evaluation
        hub.admin_evaluate_ok
      when :send_to_admin_for_revision
        hub.admin_evaluate_ok
      when :sent_to_admin_for_evaluation
        hub.admin_evaluate_ok
    end
  end
end