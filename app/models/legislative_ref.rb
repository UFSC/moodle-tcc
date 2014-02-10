class LegislativeRef < ActiveRecord::Base

  include ModelsUtils
  include Shared::Citacao

  before_save :check_equality
  before_update :check_equality
  after_update :check_difference, if: Proc.new { (self.publisher_changed?) }
  before_destroy :check_for_usage

  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :references

  validates_presence_of :edition, :jurisdiction_or_header, :local, :publisher, :title, :total_pages, :year

  attr_accessible :edition, :jurisdiction_or_header, :local, :publisher, :title, :total_pages, :year

  validates :total_pages, :numericality => {:only_integer => true, :greater_than => 0}
  validates :edition, :numericality => {:only_integer => true, :greater_than => 0}
  validates :year, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => (Date.today.year)}
  validates :year, :inclusion => {:in => lambda { |book| 0..Date.today.year }}

  alias_attribute :first_author, :jurisdiction_or_header

  # Garante que os atributos principais estarão dentro de um padrão mínimo:
  # sem espaços no inicio e final e espaços duplos
  normalize_attributes :jurisdiction_or_header, :title, :local, :with => [:squish, :blank]


  def direct_citation
    "(#{UnicodeUtils.upcase(jurisdiction_or_header)}, #{year})"
  end

  def indirect_citation
    "#{UnicodeUtils.titlecase(jurisdiction_or_header)} (#{year})"
  end

  private

  def get_all_authors
    [jurisdiction_or_header]
  end

  def check_equality
    legislative_refs = LegislativeRef.where('(publisher = ? ) AND (year = ?)', publisher, year)

    update_subtype_field(self, legislative_refs)
  end

  def check_difference
    legislative_refs = LegislativeRef.where('(publisher = ? ) AND (year = ?)', publisher, year)

    update_refs(legislative_refs)
    legislative_refs = LegislativeRef.where('(publisher = ? ) AND (year = ?)', publisher_was, year)

    update_refs(legislative_refs)
  end

end