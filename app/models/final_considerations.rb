class FinalConsiderations < ActiveRecord::Base
  belongs_to :tcc

  attr_accessible :commentary, :content

  def empty?
    self.content.blank?
  end
end
