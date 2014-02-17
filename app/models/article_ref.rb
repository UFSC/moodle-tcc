class ArticleRef < ActiveRecord::Base

  include ModelsUtils
  include Shared::Citacao
  include Shared::Validations

  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :reference

  before_create :check_equality
  before_update :check_equality
  after_update :check_difference, if: Proc.new { (self.first_author_changed? || self.second_author_changed? || self.third_author_changed?) }
  before_destroy :check_for_usage

  attr_accessible :article_subtitle, :article_title, :end_page, :et_all, :first_author, :initial_page, :journal_name,
                  :local, :number_or_fascicle, :year, :second_author, :third_author, :volume_number

  validates_presence_of :first_author, :article_title, :journal_name, :local, :year, :initial_page, :end_page

  validates :volume_number, :numericality => {only_integer: true, greater_than: 0}, :allow_blank => true
  validates :number_or_fascicle, :numericality => {only_integer: true, greater_than: 0}, :allow_blank => true
  validates :initial_page, :numericality => {only_integer: true, greater_than: 0}
  validates :end_page, :numericality => {only_integer: true, greater_than: 0}
  validates :year, :inclusion => {in: lambda { |article| 0..Date.today.year }}
  validate :initial_page_less_than_end_page

  validates :first_author, :second_author, :third_author, complete_name: true

  # Garante que os atributos principais estarão dentro de um padrão mínimo:
  # sem espaços no inicio e final e espaços duplos
  normalize_attributes :first_author, :second_author, :third_author, :journal_name, :local, :with => [:squish, :blank]

  alias_attribute :title, :article_title

  def direct_et_al
    "(#{first_author.split(' ').last.upcase} et al., #{year})"
  end

  def direct_citation
    return direct_et_al if et_all

    lastname = UnicodeUtils.upcase(first_author.split(' ').last)
    authors = lastname

    unless second_author.nil? || second_author.blank?
      lastname = UnicodeUtils.upcase(second_author.split(' ').last)
      authors = "#{authors}; #{lastname}"
    end

    unless third_author.nil? || third_author.blank?
      lastname = UnicodeUtils.upcase(third_author.split(' ').last)
      authors = "#{authors}; #{lastname}"
    end

    "(#{authors}, #{year})"
  end

  private

  def get_all_authors
    [first_author, second_author, third_author]
  end

  def check_changed
    self.first_author.changed? || self.second_author.changed? || self.third_author.changed?
  end

  def initial_page_less_than_end_page
    if (!initial_page.nil? && !end_page.nil?) && (initial_page > end_page)
      errors.add(:initial_page, "Can't be less than end page")
    end
  end

  def check_equality
    columns =[:first_author, :second_author, :third_author]
    article_refs = get_records(ArticleRef, columns, first_author, second_author, third_author, year)
    update_subtype_field(self, article_refs)
  end

  def check_difference
    columns =[:first_author, :second_author, :third_author]
    article_refs = get_records(ArticleRef, columns, first_author, second_author, third_author, year)
    update_refs(article_refs)

    article_refs = get_records(ArticleRef, columns, first_author_was, second_author_was, third_author_was, year)
    update_refs(article_refs)
  end
end
