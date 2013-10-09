# encoding: utf-8

# Máquina de estados dos Hubs
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
      state :new, :initial => true
      state :draft
      state :sent_to_admin_for_revision
      state :sent_to_admin_for_evaluation
      state :admin_evaluation_ok
      state :terminated

      # Portifolio events
      event :send_to_draft do
        transitions :from => :new, :to => :draft
      end
      event :send_to_admin_for_revision do
        transitions from: [:draft, :new], :to => :sent_to_admin_for_revision,
                    on_transition: Proc.new { |obj| obj.send_state_changed_mail(obj.tcc.email_orientador) }
      end

      event :send_back_to_student do
        transitions from: [:sent_to_admin_for_revision, :sent_to_admin_for_evaluation, :admin_evaluation_ok], :to => :draft,
                    on_transition: Proc.new { |obj| obj.send_state_changed_mail(obj.tcc.email_estudante) }
      end

      event :send_to_admin_for_evaluation do
        transitions from: [:draft, :new], :to => :sent_to_admin_for_evaluation,
                    on_transition: Proc.new { |obj| obj.send_state_changed_mail(obj.tcc.email_orientador) }
      end

      event :admin_evaluate_ok do
        transitions :from => :sent_to_admin_for_evaluation, :to => :admin_evaluation_ok,
                    on_transition: Proc.new { |obj| obj.send_state_changed_mail(obj.tcc.email_estudante) }
      end

      event :send_to_terminated do
        transitions :from => :admin_evaluation_ok, :to => :terminated
      end
    end

    def send_state_changed_mail(mail_to)
      return if self.type != 'HubTcc'

      old_state = self.state_was
      new_state = self.state
      activity_url = self.tcc.tcc_definition.activity_url

      Mailer.state_altered(mail_to, old_state, new_state, activity_url).deliver
    end

  end

end