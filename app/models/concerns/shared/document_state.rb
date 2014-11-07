module Shared::DocumentState
  extend ActiveSupport::Concern

  included do
    attr_accessible :state, :state_date

    state_machine :state, :initial => :draft do

      around_transition do |document, transition, block|
        block.call
        document.state_date = Date.today
      end

      state :draft
      state :review
      state :done

      event :to_review do
        transition :draft => :review
      end

      event :to_draft do
        transition :review => :draft
      end

      event :to_done do
        transition :review => :done
      end

    end
  end
end
