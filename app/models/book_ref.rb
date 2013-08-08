class BookRef < ActiveRecord::Base
  include ModelsUtils

  before_save :check_equality
  before_update :check_equality

  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :reference

  QUANTITY_TYPES = %w(p ed)

  attr_accessible :first_author, :edition_number, :et_all, :local, :num_quantity, :publisher, :second_author, :subtitle,
                  :third_author, :title, :type_quantity, :year

  validates_presence_of :first_author, :local, :year, :title, :publisher
  validates_presence_of :num_quantity, :if => :type_quantity_defined?

  validates :type_quantity, :inclusion => {:in => QUANTITY_TYPES}, :allow_blank => true
  validates :year, :numericality => {:only_integer => true}
  validates :year, :inclusion => {:in => lambda { |book| 0..Date.today.year }}
  validates :edition_number, :numericality => {:only_integer => true, :greater_than => 0}, :allow_blank => true

  def direct_citation
    authors = "#{first_author.split(' ').last.upcase}; #{first_author.split(' ').first.upcase}"
    authors = "#{authors}, #{second_author.split(' ').last.upcase}; #{second_author.split(' ').first.upcase}" if second_author
    authors = "#{authors}, #{third_author.split(' ').last.upcase}; #{third_author.split(' ').first.upcase}" if third_author
    "(#{authors}, #{year})"
  end

  def indirect_citation
    "#{first_author.split(' ').first.capitalize} (#{year})"
  end

  def type_quantity_defined?
    !type_quantity.blank?
  end

  private

  def check_equality
    book_refs = BookRef.where("(first_author = ? OR second_author = ? OR third_author = ?) AND
                                    (first_author = ? OR second_author = ? OR third_author = ?) AND
                                    (first_author = ? OR second_author = ? OR third_author = ?) AND
                                    (year = ?)", first_author, second_author, third_author, first_author, second_author, third_author, first_author, second_author, third_author, year)

    update_subtype_field(self, book_refs)
  end
end
