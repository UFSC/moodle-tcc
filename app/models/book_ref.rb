class BookRef < ActiveRecord::Base
  include ModelsUtils

  before_save :check_equality
  before_update :check_equality
  after_update :check_difference, if: Proc.new { (self.first_author_changed? || self.second_author_changed? || self.third_author_changed?) }


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

  def direct_et_al
    "(#{first_author.split(' ').last.upcase} et al., #{year})"
  end


  def indirect_et_al
    "#{first_author.split(' ').last.capitalize} et al. (#{year})"
  end

  def direct_citation
    return direct_et_al if et_all

    authors = "#{first_author.split(' ').last.upcase}"
    if !second_author.nil?
      authors = "#{authors}; #{second_author.split(' ').last.upcase}" if !second_author.empty?
    end
    if !third_author.nil?
      authors = "#{authors}; #{third_author.split(' ').last.upcase}" if !third_author.empty?
    end
    authors = "#{first_author.split(' ').last.upcase}; #{first_author.split(' ').first.upcase}"
    if !second_author.nil?
      authors = "#{authors}, #{second_author.split(' ').last.upcase}; #{second_author.split(' ').first.upcase}" if !second_author.empty?
    end
    if !third_author.nil?
      authors = "#{authors}, #{third_author.split(' ').last.upcase}; #{third_author.split(' ').first.upcase}" if !third_author.empty?
    end
    "(#{authors}, #{year})"
  end

  def indirect_citation
    return indirect_et_al if et_all
    authors = "#{UnicodeUtils.titlecase(first_author.split(' ').last)}"
    if !second_author.nil?
      authors = "#{authors}, #{UnicodeUtils.titlecase(second_author.split(' ').last)}" if !second_author.empty?
    end
    if !third_author.nil?
      authors = "#{authors} e #{UnicodeUtils.titlecase(third_author.split(' ').last)}" if !third_author.empty?
    end
    "#{authors} (#{year})"
  end

  def type_quantity_defined?
    !type_quantity.blank?
  end

  private

  def check_equality
    book_refs = BookRef.where('(
                               (first_author = ? AND second_author = ? AND third_author = ?) OR
                               (first_author = ? AND second_author = ? AND third_author = ?) OR
                               (first_author = ? AND second_author = ? AND third_author = ?) OR
                               (first_author = ? AND second_author = ? AND third_author = ?) OR
                               (first_author = ? AND second_author = ? AND third_author = ?) OR
                               (first_author = ? AND second_author = ? AND third_author = ?)                                 )
                                AND year = ?',
                              first_author, second_author, third_author,
                              first_author, third_author, second_author,
                              second_author, first_author, third_author,
                              second_author, third_author, first_author,
                              third_author, first_author, second_author,
                              third_author, second_author, first_author,
                              year)

    update_subtype_field(self, book_refs)
  end

  def check_difference
    book_refs = BookRef.where('(
                                    (first_author = ? AND second_author = ? AND third_author = ?) OR
                                    (first_author = ? AND second_author = ? AND third_author = ?) OR
                                    (first_author = ? AND second_author = ? AND third_author = ?) OR
                                    (first_author = ? AND second_author = ? AND third_author = ?) OR
                                    (first_author = ? AND second_author = ? AND third_author = ?) OR
                                    (first_author = ? AND second_author = ? AND third_author = ?)
                                    )
                                    AND year = ?',
                              first_author, second_author, third_author,
                              first_author, third_author, second_author,
                              second_author, first_author, third_author,
                              second_author, third_author, first_author,
                              third_author, first_author, second_author,
                              third_author, second_author, first_author,
                              year)
    update_refs(book_refs)
    book_refs = BookRef.where('(
                                    (first_author = ? AND second_author = ? AND third_author = ?) OR
                                    (first_author = ? AND second_author = ? AND third_author = ?) OR
                                    (first_author = ? AND second_author = ? AND third_author = ?) OR
                                    (first_author = ? AND second_author = ? AND third_author = ?) OR
                                    (first_author = ? AND second_author = ? AND third_author = ?) OR
                                    (first_author = ? AND second_author = ? AND third_author = ?)
                                    )
                                    AND year = ?',
                              first_author_was, second_author_was, third_author_was,
                              first_author_was, third_author_was, second_author_was,
                              second_author_was, first_author_was, third_author_was,
                              second_author_was, third_author_was, first_author_was,
                              third_author_was, first_author_was, second_author_was,
                              third_author_was, second_author_was, first_author_was,
                              year)

    update_refs(book_refs)
  end
end
