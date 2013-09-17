class FinalConsiderations < ActiveRecord::Base
  belongs_to :tcc
  attr_accessible :commentary, :content

  validates :content, presence: true, unless: Proc.new { |final| final.new? }

  has_paper_trail meta: {state: :state}

  include TccStateMachine

  def empty?
    self.content.blank?
  end
end
