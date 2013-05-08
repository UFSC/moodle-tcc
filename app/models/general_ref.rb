class GeneralRef < ActiveRecord::Base

  validates_presence_of :direct_citation, :indirect_citation, :reference_text

  attr_accessible :direct_citation, :indirect_citation, :reference_text

  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :references

end
