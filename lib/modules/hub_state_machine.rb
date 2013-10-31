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
                    :on_transition => Proc.new { |hub| hub.clear_commentary! }
      end

      event :send_back_to_student do
        transitions from: [:sent_to_admin_for_revision, :sent_to_admin_for_evaluation, :admin_evaluation_ok], :to => :draft
      end

      event :send_to_admin_for_evaluation do
        transitions from: [:draft, :new], :to => :sent_to_admin_for_evaluation,
                    :on_transition => Proc.new { |hub| hub.clear_commentary! }
      end

      event :admin_evaluate_ok do
        transitions :from => :sent_to_admin_for_evaluation, :to => :admin_evaluation_ok
      end

      event :send_to_terminated do
        transitions :from => :admin_evaluation_ok, :to => :terminated
      end
    end

    # Injetar metodos de instancia
    base.send :include, InstanceMethods
  end

  module InstanceMethods

    # Obtem a ultima versão útil (exclui versões que sejam edições intermediárias dos orientadores)
    def last_useful_version

      if self.sent_to_admin_for_revision? || self.sent_to_admin_for_evaluation?
        # A atividade está com o orientador para revisão ou avaliação
        # Retornar a versão do aluno
        return last_student_version

      elsif self.admin_evaluation_ok? || self.terminated?
        # A atividade foi avaliada
        # Retornar a ultima versão comentada
        return last_commented_version

      elsif self.draft?
        # A atividade está com o estudante
        # Retornar a ultima versão comentada
        return last_commented_version
      end
    end

    def last_student_version
      # Para obter a ultima versão que o aluno envio para revisão ou avaliação
      # Localizamos a ultima versão com estado draft, e pegamos a próxima
      last_version = self.versions.where(state: 'draft').last
      return last_version.reify.next_version unless last_version.nil?
    end

    def last_commented_version
      # Para obter a ultima versão que o coordenador / tutor fez comentários
      # Pegamos a ultima versão que foi enviada para revisão ou avaliação
      last_version = self.versions.where('state = ? OR state = ?',
                                         'sent_to_admin_for_evaluation', 'sent_to_admin_for_revision').last
      return last_version.reify unless last_version.nil?
    end
  end

end