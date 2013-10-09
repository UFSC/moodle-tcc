class Presentation < ActiveRecord::Base
  include TccStateMachine
  belongs_to :tcc

  attr_accessible :commentary, :content

  validates :content, presence: true, unless: Proc.new { |presentation| presentation.new? }

  has_paper_trail meta: {state: :state}

  def empty?
    self.content.blank?
  end

end
