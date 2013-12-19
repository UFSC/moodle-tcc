# encoding: utf-8
class ThesisRef < ActiveRecord::Base

  include ModelsUtils
  include Shared::Citacao

  TYPES = %w(Volumes Folhas)
  THESIS_TYPES = %W(Tese Dissertação Monografia TCC)

  before_save :check_equality
  before_update :check_equality
  after_update :check_difference, if: Proc.new { (self.author_changed?) }

  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :reference

  attr_accessible :author, :chapter, :course, :degree, :department, :institution, :local, :pages_or_volumes_number, :subtitle, :title, :type_thesis, :type_number, :year

  validates_presence_of :author, :title, :subtitle, :local, :year, :institution, :pages_or_volumes_number,
                        :type_number, :course

  validates :type_number, :inclusion => {:in => TYPES}
  validates :type_thesis, :inclusion => {:in => THESIS_TYPES}

  validates :year, :pages_or_volumes_number, :numericality => {:only_integer => true}

  # Garante que os atributos principais estarão dentro de um padrão mínimo:
  # sem espaços no inicio e final e espaços duplos
  normalize_attributes :author, :subtitle, :title, :local, :with => [:squish, :blank]

  alias_attribute :first_author, :author

  def direct_citation
    lastname = UnicodeUtils.upcase(author.split(' ').last)
    "(#{lastname}, #{year})"
  end

  private

  def get_all_authors
    [author]
  end

  def check_equality
    thesis_refs = ThesisRef.where('(author = ? ) AND (year = ?)', author, year)
    update_subtype_field(self, thesis_refs)
  end

  def check_difference
    thesis_refs = ThesisRef.where('(author = ? ) AND (year = ?)', author, year)
    update_refs(thesis_refs)
    thesis_refs = ThesisRef.where('(author = ? ) AND (year = ?)', author_was, year)
    update_refs(thesis_refs)

  end
end
