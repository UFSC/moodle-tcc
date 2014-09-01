module PaperTrail
  class Version < ActiveRecord::Base
    include PaperTrail::VersionConcern

    attr_accessible :state, :comment
  end
end