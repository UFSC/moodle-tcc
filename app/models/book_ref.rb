class BookRef < ActiveRecord::Base

  QUANTITY_TYPES = %w(p ed)

  validates_presence_of :first_author, :edition_number, :local, :year, :title, :publisher
  validates_presence_of :num_quantity, :if => :type_quantity
  validates :type_quantity, :inclusion => { :in => QUANTITY_TYPES }, :allow_blank => true
  validates :year, :numericality => { :only_integer => true }
  validates :year, :inclusion => { :in => lambda{ |book| 0..Date.today.year } }

  attr_accessible :first_author, :edition_number, :et_all, :local, :num_quantity, :publisher, :second_author, :subtitle, :third_author, :title, :type_quantity, :year

  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :references
end
