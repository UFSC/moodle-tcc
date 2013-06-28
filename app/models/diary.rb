class Diary < ActiveRecord::Base
  belongs_to :hub
  attr_accessible :content, :pos, :title

   # Virtual attribute
  attr_accessor :title
end
