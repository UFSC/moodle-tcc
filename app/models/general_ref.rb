class GeneralRef < ActiveRecord::Base

  validates_presence_of :direct_citation, :indirect_citation, :reference_text

  attr_accessible :direct_citation, :indirect_citation, :reference_text

  alias_attribute :title, :reference_text


  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :reference

end