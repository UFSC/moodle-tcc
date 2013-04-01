class Bibliography < ActiveRecord::Base
  belongs_to :tcc
  attr_accessible :content
end
