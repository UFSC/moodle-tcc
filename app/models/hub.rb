class Hub < ActiveRecord::Base

  belongs_to :tcc
  has_many :diaries

  # Mass-Assignment
  attr_accessible :category, :reflection, :commentary, :grade, :diaries_attributes

  accepts_nested_attributes_for :diaries

  validates_inclusion_of :grade, in: 0..10, allow_nil: true

  after_initialize :set_state

  has_paper_trail meta: {state: :state}

  #TccStateMachine.state_name = :state
  include TccStateMachine

end
