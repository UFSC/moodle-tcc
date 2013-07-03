module HubStateMachine
  unloadable

  def self.included(base)

    base.send :include, AASM
    base.aasm_column :state
    base.has_paper_trail meta: {:state => :state, :comment => :commentary}

    # Virtual attribute
    base.send :attr_accessor, :new_state
    base.attr_accessible :new_state

    base.aasm do
      # Portifolio states
      state :draft, :initial => true
      state :sent_to_admin_for_revision
      state :sent_to_admin_for_evaluation
      state :admin_evaluation_ok

      # TCC states
      state :tcc_draft
      state :sent_to_leader_for_revision
      state :sent_to_leader_for_evaluation
      state :leader_evaluation_ok

      # Portifolio events
      event :send_to_admin_for_revision do
        transitions :from => :draft, :to => :sent_to_admin_for_revision
      end

      event :send_back_to_student do
        transitions :from => [:sent_to_admin_for_revision, :sent_to_admin_for_evaluation], :to => :draft
      end

      event :send_to_admin_for_evaluation do
        transitions :from => :draft, :to => :sent_to_admin_for_evaluation
      end

      event :admin_evaluate_ok do
        transitions :from => :sent_to_admin_for_evaluation, :to => :admin_evaluation_ok
      end

      # TCC events
      event :change_to_tcc do
        transitions :from => :admin_evaluation_ok, :to => :tcc_draft
      end

      event :send_to_leader_for_revision do
        transitions :from => :tcc_draft, :to => :sent_to_leader_for_revision
      end

      event :send_back_to_tcc_student do
        transitions :from => [:sent_to_leader_for_revision, :sent_to_leader_for_evaluation], :to => :tcc_draft
      end

      event :send_to_leader_for_evaluation do
        transitions :from => :tcc_draft, :to => :sent_to_leader_for_evaluation
      end

      event :leader_evaluate_ok do
        transitions :from => :sent_to_leader_for_evaluation, :to => :leader_evaluation_ok
      end
    end
  end

end