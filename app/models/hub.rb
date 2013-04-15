class Hub < ActiveRecord::Base
  belongs_to :tcc
  attr_accessible :category, :reflection, :commentary
  has_many :diaries
end
