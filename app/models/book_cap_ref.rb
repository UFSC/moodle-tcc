class BookCapRef < ActiveRecord::Base

  include ModelsUtils
  include Shared::Citacao

  before_save :check_equality
  before_update :check_equality
  after_update :check_difference, if: Proc.new { (self.book_author_changed?) }


  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :reference

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

  alias_attribute :title, :book_title
  alias_attribute :first_author, :book_author

  def direct_citation
    "(#{book_author.split(' ').last.upcase}, #{year})"
  end

  private

  def get_all_authors
    [first_author]
  end

  def initial_page_less_than_end_page
    if (!initial_page.nil? && !end_page.nil?) && (initial_page > end_page)
      errors.add(:initial_page, "Can't be less than end page")
    end
  end

  def check_equality
    book_cap_refs = BookCapRef.where('(book_author = ? ) AND (year = ?)', book_author, year)
    update_subtype_field(self, book_cap_refs)
  end

  def check_difference
    book_cap_refs = BookCapRef.where('(book_author = ? ) AND (year = ?)', book_author, year)
    update_refs(book_cap_refs)
    book_cap_refs = BookCapRef.where('(book_author = ? ) AND (year = ?)', book_author_was, year)
    update_refs(book_cap_refs)

  end
end
