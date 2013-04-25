class Hub < ActiveRecord::Base
  belongs_to :tcc
  attr_accessible :category, :reflection, :commentary, :diaries_attributes
  has_many :diaries

  accepts_nested_attributes_for :diaries
end
