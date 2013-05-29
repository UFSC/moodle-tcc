class BookCapRef < ActiveRecord::Base
  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :references

  PARTICIPATION_TYPES = %w(Autor Organizador Compilador Editor)

  attr_accessible :book_author, :book_subtitle, :book_title, :cap_author, :cap_subtitle, :cap_title, :end_page,
                  :initial_page, :local, :publisher, :type_participation, :year

  validates_presence_of :book_author, :book_title, :cap_author, :cap_title, :end_page, :initial_page, :local, :publisher,
                        :type_participation, :year

  validates :type_participation, :inclusion => {:in => PARTICIPATION_TYPES}
  validates :year, :end_page, :initial_page, :numericality => {:only_integer => true}
  validates :year, :inclusion => {:in => lambda { |book| 0..Date.today.year }}

  validates :initial_page, :numericality => {:only_integer => true, :greater_than => 0}
  validates :end_page, :numericality => {:only_integer => true, :greater_than => 0}
  validate :initial_page_less_than_end_page

  private

  def initial_page_less_than_end_page
    if (!initial_page.nil? && !end_page.nil?) && (initial_page > end_page)
      errors.add(:initial_page, "Can't be less than end page")
    end
  end
end
