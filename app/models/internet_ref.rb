class InternetRef < ActiveRecord::Base

  include ModelsUtils
  include Shared::Citacao

  before_save :check_equality
  before_update :check_equality
  after_update :check_difference, if: Proc.new { (self.first_author_changed? || self.second_author_changed? || self.third_author_changed?) }
  before_destroy :check_for_usage

  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :references

  VALID_URL_EXPRESSION = /^(http|https|ftp|ftps):\/\/(([a-z0-9]+\:)?[a-z0-9]+\@)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.([a-z]{2,5}|[0-9]{1,3})(([0-9]{1,5})?\/.*)?$/ix
  validates_presence_of :access_date, :ref_date, :first_author, :title, :url

  attr_accessible :access_date, :first_author, :second_author, :third_author, :et_al, :complementary_information,
                  :subtitle, :title, :url,
                  :ref_date

  validates_format_of :url, :with => VALID_URL_EXPRESSION

  # Garante que os atributos principais estarão dentro de um padrão mínimo:
  # sem espaços no inicio e final e espaços duplos
  normalize_attributes :first_author, :second_author, :third_author, :title, :with => [:squish, :blank]


  def direct_et_al
    "(#{first_author.split(' ').last.upcase} et al., #{year})"
  end


  def direct_citation
    return direct_et_al if et_al

    authors = "#{first_author.split(' ').last.upcase}"

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

  def year
    self.ref_date.year
  end

  private

  def get_all_authors
    [first_author, second_author, third_author]
  end

  def check_equality
    internet_refs = InternetRef.where('(
                               (first_author = ? AND second_author = ? AND third_author = ?) OR
                               (first_author = ? AND second_author = ? AND third_author = ?) OR
                               (first_author = ? AND second_author = ? AND third_author = ?) OR
                               (first_author = ? AND second_author = ? AND third_author = ?) OR
                               (first_author = ? AND second_author = ? AND third_author = ?) OR
                               (first_author = ? AND second_author = ? AND third_author = ?)                                 )
                                AND ref_date = ?',
                                      first_author, second_author, third_author,
                                      first_author, third_author, second_author,
                                      second_author, first_author, third_author,
                                      second_author, third_author, first_author,
                                      third_author, first_author, second_author,
                                      third_author, second_author, first_author,
                                      ref_date)

    update_subtype_field(self, internet_refs)
  end

  def check_difference
    internet_refs = InternetRef.where('(
                                    (first_author = ? AND second_author = ? AND third_author = ?) OR
                                    (first_author = ? AND second_author = ? AND third_author = ?) OR
                                    (first_author = ? AND second_author = ? AND third_author = ?) OR
                                    (first_author = ? AND second_author = ? AND third_author = ?) OR
                                    (first_author = ? AND second_author = ? AND third_author = ?) OR
                                    (first_author = ? AND second_author = ? AND third_author = ?)
                                    )
                                    AND ref_date = ?',
                                      first_author, second_author, third_author,
                                      first_author, third_author, second_author,
                                      second_author, first_author, third_author,
                                      second_author, third_author, first_author,
                                      third_author, first_author, second_author,
                                      third_author, second_author, first_author,
                                      ref_date)
    update_refs(internet_refs)
    internet_refs = InternetRef.where('(
                                    (first_author = ? AND second_author = ? AND third_author = ?) OR
                                    (first_author = ? AND second_author = ? AND third_author = ?) OR
                                    (first_author = ? AND second_author = ? AND third_author = ?) OR
                                    (first_author = ? AND second_author = ? AND third_author = ?) OR
                                    (first_author = ? AND second_author = ? AND third_author = ?) OR
                                    (first_author = ? AND second_author = ? AND third_author = ?)
                                    )
                                    AND ref_date = ?',
                                      first_author_was, second_author_was, third_author_was,
                                      first_author_was, third_author_was, second_author_was,
                                      second_author_was, first_author_was, third_author_was,
                                      second_author_was, third_author_was, first_author_was,
                                      third_author_was, first_author_was, second_author_was,
                                      third_author_was, second_author_was, first_author_was,
                                      ref_date)

    update_refs(internet_refs)
  end
end
