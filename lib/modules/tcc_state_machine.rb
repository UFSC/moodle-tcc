module TccStateMachine
  unloadable

  def self.included(base)

    base.send :include, AASM
    base.aasm_column :state
    base.has_paper_trail meta: {:state => :state, :comment => :commentary}

    # Virtual attribute
    base.send :attr_accessor, :new_state
    base.attr_accessible :new_state

    base.aasm do
      state :new, :initial => true
      state :draft
      state :sent_to_admin_for_revision
      state :sent_to_admin_for_evaluation
      state :admin_evaluation_ok

      event :send_to_draft do
        transitions :from => :new, :to => :draft
      end

      event :send_to_admin_for_revision do
        transitions :from => [:draft, :new], :to => :sent_to_admin_for_revision,
                    :on_transition => Proc.new { |obj| obj.send_mail_to_orientador }
      end

      event :send_back_to_student do
        transitions :from => [:sent_to_admin_for_revision, :sent_to_admin_for_evaluation], :to => :draft,
                    :on_transition => Proc.new { |obj| obj.send_mail_to_student }
      end

      event :send_to_admin_for_evaluation do
        transitions :from => [:draft, :new], :to => :sent_to_admin_for_evaluation,
                    :on_transition => Proc.new { |obj| obj.send_mail_to_orientador }
      end

      event :admin_evaluate_ok do
        transitions :from => :sent_to_admin_for_evaluation, :to => :admin_evaluation_ok,
                    :on_transition => Proc.new { |obj| obj.send_mail_to_student }
      end
    end

    def send_mail_to_student
      mail = self.tcc.email_estudante
      Mailer.state_altered(mail).deliver
    end

    def send_mail_to_orientador
      mail = self.tcc.email_orientador
      Mailer.state_altered(mail).deliver
    end
  end

end