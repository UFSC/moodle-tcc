class BookCapRef < ActiveRecord::Base

  PARTICIPATION_TYPES = %w(Autor Organizador Compilador Editor)

  validates_presence_of :book_author, :book_title, :cap_author, :cap_title, :end_page, :initial_page, :local, :publisher, :type_participation, :year

  validates :type_participation, :inclusion => {:in => PARTICIPATION_TYPES}

  validates :year, :end_page, :initial_page, :numericality => {:only_integer => true}
  validates :year, :inclusion => {:in => lambda { |book| 0..Date.today.year }}

  attr_accessible :book_author, :book_subtitle, :book_title, :cap_author, :cap_subtitle, :cap_title, :end_page, :initial_page, :local, :publisher, :type_participation, :year

  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :references
end
