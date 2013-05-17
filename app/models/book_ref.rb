class BookRef < ActiveRecord::Base

  validates_presence_of :first_author, :edition_number, :et_all, :local, :year, :title, :publisher

  attr_accessible :first_author, :edition_number, :et_all, :local, :num_quantity, :publisher, :second_author, :subtitle, :third_author, :title, :type_quantity, :year

  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :references
end
