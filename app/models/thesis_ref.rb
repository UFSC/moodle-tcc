# encoding: utf-8
class ThesisRef < ActiveRecord::Base

  include ModelsUtils
  include Shared::Citacao

  TYPES = %w(Volumes Folhas)
  THESIS_TYPES = %W(Tese Dissertação Monografia TCC)
  DEGREE_TYPES = %w(Doutorado Mestrado Especialização Graduação)

  before_save :check_equality
  before_update :check_equality
  after_update :check_difference, if: Proc.new { (self.first_author_changed? || self.second_author_changed? || self.third_author_changed?) }
  before_destroy :check_for_usage

  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :reference

  attr_accessible :first_author, :second_author, :third_author, :et_all, :chapter, :course, :degree, :department,
                  :institution, :local, :pages_or_volumes_number, :subtitle, :title, :type_thesis, :type_number,
                  :year, :year_of_submission

  validates_presence_of :first_author, :title, :local, :year, :institution, :pages_or_volumes_number,
                        :type_number, :course, :year_of_submission

  validates :type_number, :inclusion => {:in => TYPES}
  validates :type_thesis, :inclusion => {:in => THESIS_TYPES}
  validates :degree, :inclusion => {:in => DEGREE_TYPES}

  validates :year, :year_of_submission, :numericality => {:only_integer => true,:greater_than => 0, :less_than_or_equal_to => (Date.today.year)}

  validates :first_author, :second_author, :third_author, complete_name: true

  validates :chapter, :pages_or_volumes_number, :numericality => {only_integer: true, :greater_than => 0}

  # Garante que os atributos principais estarão dentro de um padrão mínimo:
  # sem espaços no inicio e final e espaços duplos
  normalize_attributes :first_author, :second_author, :third_author, :subtitle, :title, :local, :institution,
                       :department, :course, :with => [:squish, :blank]

  after_commit :touch_tcc, on: [:create, :update]
  before_destroy :touch_tcc

  private

  def get_all_authors
    [first_author, second_author, third_author]
  end

  def touch_tcc
    reference.tcc.touch unless (reference.nil? || reference.tcc.nil? || reference.tcc.new_record?)
  end

  def check_equality
    columns =[:first_author, :second_author, :third_author]
    thesis_refs = get_records(ThesisRef, columns, first_author, second_author, third_author, year)
    update_subtype_field(self, thesis_refs)
  end

  def check_difference
    columns =[:first_author, :second_author, :third_author]
    thesis_refs = get_records(ThesisRef, columns, first_author, second_author, third_author, year)
    update_refs(thesis_refs)

    thesis_refs = get_records(ThesisRef, columns, first_author_was, second_author_was, third_author_was, year)
    update_refs(thesis_refs)
  end
end
