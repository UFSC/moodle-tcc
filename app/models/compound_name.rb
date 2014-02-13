class CompoundName < ActiveRecord::Base
  attr_accessible :name

  include Shared::Search
  default_scope order(:name)
  scoped_search :on => [:name]
end
