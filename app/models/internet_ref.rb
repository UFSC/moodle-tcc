class InternetRef < ActiveRecord::Base

  include ModelsUtils
  include Shared::Citacao

  before_save :check_equality
  before_update :check_equality
  after_update :check_difference, if: Proc.new { (self.author_changed?) }
  before_destroy :check_for_usage

  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :references

  VALID_URL_EXPRESSION = /^(http|https|ftp|ftps):\/\/(([a-z0-9]+\:)?[a-z0-9]+\@)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.([a-z]{2,5}|[0-9]{1,3})(([0-9]{1,5})?\/.*)?$/ix
  validates_presence_of :access_date, :author, :title, :url

  attr_accessible :access_date, :author, :subtitle, :title, :url

  validates_format_of :url, :with => VALID_URL_EXPRESSION

  # Garante que os atributos principais estarão dentro de um padrão mínimo:
  # sem espaços no inicio e final e espaços duplos
  normalize_attributes :author, :title, :with => [:squish, :blank]


  alias_attribute :first_author, :author


  def direct_citation
    lastname = UnicodeUtils.upcase(author.split(' ').last)
    "(#{lastname}, #{year})"
  end

  def year
    self.access_date.year
  end

  private

  def get_all_authors
    [author]
  end

  def check_equality
    internet_refs = InternetRef.where('(author = ? ) AND (YEAR(access_date) = ?)', author, access_date.year)

    update_subtype_field(self, internet_refs)
  end

  def check_difference
    internet_refs = InternetRef.where('(author = ? ) AND (YEAR(access_date) = ?)', author, access_date.year)

    update_refs(internet_refs)
    internet_refs = InternetRef.where('(author = ? ) AND (YEAR(access_date) = ?)', author_was, access_date.year)

    update_refs(internet_refs)
  end

end
