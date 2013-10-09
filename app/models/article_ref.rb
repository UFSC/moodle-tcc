class ArticleRef < ActiveRecord::Base

  include ModelsUtils

  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :reference

  before_create :check_equality
  before_update :check_equality
  after_update :check_difference, if: Proc.new { (self.first_author_changed? || self.second_author_changed? || self.third_author_changed?) }

  attr_accessible :article_subtitle, :article_title, :end_page, :et_all, :first_author, :initial_page, :journal_name,
                  :local, :number_or_fascicle, :year, :second_author, :third_author, :volume_number

  validates_presence_of :first_author, :article_title, :journal_name, :local, :year, :initial_page, :end_page

  validates :volume_number, :numericality => {:only_integer => true, :greater_than => 0}, :allow_blank => true
  validates :number_or_fascicle, :numericality => {:only_integer => true, :greater_than => 0}, :allow_blank => true
  validates :initial_page, :numericality => {:only_integer => true, :greater_than => 0}
  validates :end_page, :numericality => {:only_integer => true, :greater_than => 0}
  validates :year, :inclusion => {:in => lambda { |article| 0..Date.today.year }}
  validate :initial_page_less_than_end_page


  def direct_citation
    authors = "#{first_author.split(' ').last.upcase}; #{first_author.split(' ').first.upcase}"
    authors = "#{authors}, #{second_author.split(' ').last.upcase}; #{second_author.split(' ').first.upcase}" if second_author
    authors = "#{authors}, #{third_author.split(' ').last.upcase}; #{third_author.split(' ').first.upcase}" if third_author
    "(#{authors}, #{year})"
  end

  def indirect_citation
    "#{first_author.split(' ').first.capitalize} (#{year})"
  end

  private

  def check_changed
    self.first_author.changed? || self.second_author.changed? || self.third_author.changed?
  end

  def initial_page_less_than_end_page
    if (!initial_page.nil? && !end_page.nil?) && (initial_page > end_page)
      errors.add(:initial_page, "Can't be less than end page")
    end
  end

  def check_equality
    article_refs = ArticleRef.where('(
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

    update_subtype_field(self, article_refs)

  end

  def check_difference
    article_refs = ArticleRef.where('(
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

    update_refs(article_refs)

    article_refs = ArticleRef.where('(
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

    update_refs(article_refs)


  end
end
