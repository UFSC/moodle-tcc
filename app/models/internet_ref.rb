class InternetRef < ActiveRecord::Base

  include ModelsUtils

  before_save :check_equality
  before_update :check_equality
  after_update :check_difference, if: Proc.new { (self.author_changed?) }


  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :references

  VALID_URL_EXPRESSION = /^(http|https|ftp|ftps):\/\/(([a-z0-9]+\:)?[a-z0-9]+\@)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix

  validates_presence_of :access_date, :author, :title, :url

  attr_accessible :access_date, :author, :subtitle, :title, :url

  validates_format_of :url, :with => VALID_URL_EXPRESSION

  def direct_citation
    "(#{author.split(' ').last.upcase}, #{access_date.year})"
  end

  def indirect_citation
    "#{author.split(' ').last.capitalize} (#{access_date.year})"
  end

  private

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
