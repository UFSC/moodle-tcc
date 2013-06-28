class Diary < ActiveRecord::Base
  belongs_to :hub
  belongs_to :diary_definition

  attr_accessible :content, :pos, :title, :diary_definition, :hub

   # Virtual attribute
  attr_accessor :title
end
