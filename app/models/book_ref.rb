class BookRef < ActiveRecord::Base

  validates_presence_of :first_author, :edition_number, :local, :year, :title, :publisher
  validates_presence_of :num_quantity, :if => :type_quantity
  validates :type_quantity, :inclusion => %w(p, ed)
  validates :year, :numericality => { :only_integer => true }
  validates :year, :inclusion => { :in => %w(0,->{Date.today.year}) }

  attr_accessible :first_author, :edition_number, :et_all, :local, :num_quantity, :publisher, :second_author, :subtitle, :third_author, :title, :type_quantity, :year

  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :references
end
