module StateMachineUtils
  unloadable


  def change_state(state, o)
    case state
      when 'draft'
        to_draft(o)
      when 'sent_to_admin_for_revision'
        to_revision(o)
      when 'sent_to_admin_for_evaluation'
        to_evaluation(o)
      when 'admin_evaluation_ok'
        to_evaluation_ok(o)
      else
        false
    end
  end

  private

  def to_draft(o)
    case o.aasm_current_state
      when :sent_to_admin_for_revision
        o.send_back_to_student
      when :sent_to_admin_for_evaluation
        o.send_back_to_student
      when :admin_evaluation_ok
        o.state='draft'
    end
  end

  def to_revision(o)
    case o.aasm_current_state
      when :draft
        o.send_to_admin_for_revision
      when :sent_to_admin_for_evaluation
        o.send_back_to_student
        o.send_to_admin_for_revision
      when :admin_evaluation_ok
        o.state='draft'
        o.send_to_admin_for_revision
    end
  end

  def to_evaluation(o)
    case o.aasm_current_state
      when :draft
        o.send_to_admin_for_evaluation
      when :sent_to_admin_for_revision
        o.send_back_to_student
        o.send_to_admin_for_evaluation
      when :admin_evaluation_ok
        o.state='draft'
        o.send_to_admin_for_evaluation
    end
  end

  def to_evaluation_ok(o)
    case o.aasm_current_state
      when :draft
        o.send_to_admin_for_evaluation
        o.admin_evaluate_ok
      when :sent_to_admin_for_revision
        o.send_back_to_student
        o.send_to_admin_for_evaluation
        o.admin_evaluate_ok
      when :sent_to_admin_for_evaluation
        o.admin_evaluate_ok
    end
  end
end