class Presentation < ActiveRecord::Base
  belongs_to :tcc
  attr_accessible :commentary, :content

  has_paper_trail meta: {state: :state}

  include TccStateMachine

  def empty?
    self.content.blank?
  end

end
