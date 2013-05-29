class LegislativeRef < ActiveRecord::Base
  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :references

  validates_presence_of :edition, :jurisdiction_or_header, :local, :publisher, :title, :total_pages, :year

  attr_accessible :edition, :jurisdiction_or_header, :local, :publisher, :title, :total_pages, :year

  validates :total_pages, :numericality => {:only_integer => true, :greater_than => 0}
  validates :edition, :numericality => {:only_integer => true, :greater_than => 0}
  validates :year, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => (Date.today.year)}
  validates :year, :inclusion => { :in => lambda{ |book| 0..Date.today.year } }



end
