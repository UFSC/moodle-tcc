class FinalConsiderations < ActiveRecord::Base
  include TccStateMachine
  belongs_to :tcc

  attr_accessible :commentary, :content

  validates :content, presence: true, unless: Proc.new { |final| final.new? }

  def empty?
    self.content.blank?
  end
end
