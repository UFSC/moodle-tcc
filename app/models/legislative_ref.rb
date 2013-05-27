class LegislativeRef < ActiveRecord::Base

  validates_presence_of :edition, :jurisdiction_or_header, :local, :publisher, :title, :total_pages, :year

  attr_accessible :edition, :jurisdiction_or_header, :local, :publisher, :title, :total_pages, :year

  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :references
end
