class Diary < ActiveRecord::Base
  belongs_to :hub
  belongs_to :diary_definition

  attr_accessible :content, :pos, :diary_definition, :hub

end
