class Hub < ActiveRecord::Base
  belongs_to :tcc
  attr_accessible :category, :reflection, :commentary, :diaries_attributes
  has_many :diaries

  accepts_nested_attributes_for :diaries

  include AASM
  aasm_column :state

  aasm do
    state :draft, :initial => true
    state :sent_to_tutor
    state :sent_to_tutor_for_evaluation
    state :tutor_evaluation_ok

    event :send_to_tutor do
      transitions :from => :draft, :to => :sent_to_tutor#, :guard =>
    end

    event :send_back_to_student do
      transitions :from => :sent_to_tutor, :to => :draft#, :guard =>
    end

    event :send_to_tutor_for_evaluation do
      transitions :from => :draft, :to => :sent_to_tutor_for_evaluation#, :guard =>
    end

    event :tutor_evaluate_ok do
      transitions :from => :sent_to_tutor_for_evaluation, :to => :tutor_evaluation_ok#, :guard =>
    end
  end
end
