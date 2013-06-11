module TccStateMachine

  @state_name
  def self.state_name(t)
    @state_name = t
  end

  def self.included(base)

    # Virtual attribute
    base.send :attr_accessor, :new_state
    base.attr_accessible :new_state

    base.send :include, AASM
    base.aasm_column @state_name
    base.after_initialize :set_state

    base.aasm do
      state :draft, :initial => true
      state :sent_to_admin_for_revision
      state :sent_to_admin_for_evaluation
      state :admin_evaluation_ok

      event :send_to_admin_for_revision do
        transitions :from => :draft, :to => :sent_to_admin_for_revision
      end

      event :send_back_to_student do
        transitions :from => [:sent_to_admin_for_revision, :sent_to_admin_for_evaluation], :to => :draft
      end

      event :send_to_admin_for_evaluation do
        transitions :from => :draft, :to => :sent_to_admin_for_evaluation
      end

      event :evaluation_fails_and_send_back_to_student_for do
        transitions :from => :sent_to_admin_for_evaluation, :to => :draft
      end

      event :admin_evaluate_ok do
        transitions :from => :sent_to_admin_for_evaluation, :to => :admin_evaluation_ok
      end
    end
  end

  def set_state
    if self.state.nil?
      self.aasm_write_state_without_persistence(self.aasm_current_state)
    end
  end
end