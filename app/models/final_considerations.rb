class FinalConsiderations < ActiveRecord::Base
  extend Enumerize
  include TccStateMachine
  belongs_to :tcc

  attr_accessible :commentary, :content, :new_state

  validates :content, presence: true, unless: Proc.new { |final| final.new? }

  enumerize :new_state, in: aasm_states
  has_paper_trail meta: {state: :state}

  def empty?
    self.content.blank?
  end

  def self.new_states_collection
    new_state.options - [['Finalizado', 'terminated']] - [['Novo', 'new']]
  end
end
