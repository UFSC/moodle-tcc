class Diary < ActiveRecord::Base
  belongs_to :hub
  attr_accessible :content, :title
end
