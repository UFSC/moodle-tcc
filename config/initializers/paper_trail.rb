module PaperTrail
  class Version < ActiveRecord::Base
    attr_accessible :state, :comment
  end
end