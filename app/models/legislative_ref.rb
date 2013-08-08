class LegislativeRef < ActiveRecord::Base

  include ModelsUtils

  before_save :check_equality
  before_update :check_equality

  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :references

  validates_presence_of :edition, :jurisdiction_or_header, :local, :publisher, :title, :total_pages, :year

  attr_accessible :edition, :jurisdiction_or_header, :local, :publisher, :title, :total_pages, :year

  validates :total_pages, :numericality => {:only_integer => true, :greater_than => 0}
  validates :edition, :numericality => {:only_integer => true, :greater_than => 0}
  validates :year, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => (Date.today.year)}
  validates :year, :inclusion => {:in => lambda { |book| 0..Date.today.year }}

  def direct_citation
    "(#{publisher.split(' ').last.upcase}; #{publisher.split(' ').first.upcase}, #{year})"
  end

  def indirect_citation
    "#{publisher.split(' ').first.capitalize} (#{year})"
  end

  private

  def check_equality
    legislative_refs = ArticleRef.where("(publisher = ? ) AND (year = ?)", publisher, year)

    update_subtype_field(self, legislative_refs)
  end

end
