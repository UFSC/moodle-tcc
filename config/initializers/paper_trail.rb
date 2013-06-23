class Version < ActiveRecord::Base
  unloadable

  attr_accessible :state, :comment
end