class FinalConsiderations < ActiveRecord::Base
  belongs_to :tcc
  attr_accessible :commentary, :content

  has_paper_trail
end
