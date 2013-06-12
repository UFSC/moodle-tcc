module TccStateMachine

  @state_name = :state

  def self.state_name=(t)
    @state_name = t
  end

  def self.state_name
    @state_name
  end

  def self.included(base)

    # Virtual attribute
    base.send :attr_accessor, :new_state
    base.attr_accessible :new_state

    base.send :include, AASM
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
    self.class.aasm_column TccStateMachine.state_name
    self.class.has_paper_trail meta: {state: TccStateMachine.state_name}
    if eval("self."+TccStateMachine.state_name.to_s).blank?
      self.aasm_write_state_without_persistence(self.class.aasm_initial_state)
    end
  end
end