# encoding: utf-8
class BookCapRef < ActiveRecord::Base

  include ModelsUtils
  include Shared::Citacao
  include Shared::Validations

  before_save :check_equality
  before_update :check_equality
  after_update :check_difference, if: Proc.new { (self.first_entire_author_changed? || self.second_entire_author_changed? || self.third_entire_author_changed?) }
  before_destroy :check_for_usage

  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :reference

  PARTICIPATION_TYPES = %w(Autor Organizador Compilador Editor)

  attr_accessible :first_entire_author, :second_entire_author, :third_entire_author, :book_subtitle, :book_title,
                  :first_part_author, :second_part_author, :third_part_author, :cap_subtitle,
                  :cap_title, :end_page,
                  :initial_page, :local, :publisher, :type_participation, :year, :et_al_entire, :et_al_part

  validates_presence_of :first_entire_author, :book_title, :first_part_author, :cap_title, :end_page, :initial_page, :local, :publisher,
                        :type_participation, :year

  validates :type_participation, :inclusion => {in: PARTICIPATION_TYPES}
  validates :year, :end_page, :initial_page, :numericality => {only_integer: true}
  validates :year, :inclusion => {in: lambda { |book| 0..Date.today.year }}

  validates :initial_page, :numericality => {only_integer: true, greater_than: 0}
  validates :end_page, :numericality => {only_integer: true, greater_than: 0}
  validate :initial_page_less_than_end_page

  validates :first_entire_author, :second_entire_author, :third_entire_author, :first_part_author,
            :second_part_author, :third_part_author, complete_name: true

  # Garante que os atributos principais estarão dentro de um padrão mínimo:
  # sem espaços no inicio e final e espaços duplos
  normalize_attributes :first_entire_author, :second_entire_author, :third_entire_author, :first_part_author,
                       :second_part_author, :third_part_author, :book_title, :local, :with => [:squish, :blank]

  alias_attribute :title, :book_title
  alias_attribute :first_author, :first_part_author
  alias_attribute :second_author, :second_part_author
  alias_attribute :third_author, :third_part_author

  def direct_et_al
    "(#{first_author.split(' ').last.upcase} et al., #{year})"
  end

  def direct_citation
    return direct_et_al if et_al_part
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

  private

  def get_all_authors
    [first_author, second_author, third_author]
  end

  def initial_page_less_than_end_page
    if (!initial_page.nil? && !end_page.nil?) && (initial_page > end_page)
      errors.add(:initial_page, 'Deve ser igual ou anterior a página final')
    end
  end

  def check_equality
    book_cap_refs = BookCapRef.where('(
                               (first_entire_author = ? AND second_entire_author = ? AND third_entire_author = ?) OR
                               (first_entire_author = ? AND second_entire_author = ? AND third_entire_author = ?) OR
                               (first_entire_author = ? AND second_entire_author = ? AND third_entire_author = ?) OR
                               (first_entire_author = ? AND second_entire_author = ? AND third_entire_author = ?) OR
                               (first_entire_author = ? AND second_entire_author = ? AND third_entire_author = ?) OR
                               (first_entire_author = ? AND second_entire_author = ? AND third_entire_author = ?)                                 )
                                AND year = ?',
                                     first_entire_author, second_entire_author, third_entire_author,
                                     first_entire_author, third_entire_author, second_entire_author,
                                     second_entire_author, first_entire_author, third_entire_author,
                                     second_entire_author, third_entire_author, first_entire_author,
                                     third_entire_author, first_entire_author, second_entire_author,
                                     third_entire_author, second_entire_author, first_entire_author,
                                     year)
    update_subtype_field(self, book_cap_refs)
  end

  def check_difference
    book_cap_refs = BookCapRef.where('(
                               (first_entire_author = ? AND second_entire_author = ? AND third_entire_author = ?) OR
                               (first_entire_author = ? AND second_entire_author = ? AND third_entire_author = ?) OR
                               (first_entire_author = ? AND second_entire_author = ? AND third_entire_author = ?) OR
                               (first_entire_author = ? AND second_entire_author = ? AND third_entire_author = ?) OR
                               (first_entire_author = ? AND second_entire_author = ? AND third_entire_author = ?) OR
                               (first_entire_author = ? AND second_entire_author = ? AND third_entire_author = ?)                                 )
                                AND year = ?',
                                     first_entire_author, second_entire_author, third_entire_author,
                                     first_entire_author, third_entire_author, second_entire_author,
                                     second_entire_author, first_entire_author, third_entire_author,
                                     second_entire_author, third_entire_author, first_entire_author,
                                     third_entire_author, first_entire_author, second_entire_author,
                                     third_entire_author, second_entire_author, first_entire_author,
                                     year)
    update_refs(book_cap_refs)
    book_cap_refs = BookCapRef.where('(
                               (first_entire_author = ? AND second_entire_author = ? AND third_entire_author = ?) OR
                               (first_entire_author = ? AND second_entire_author = ? AND third_entire_author = ?) OR
                               (first_entire_author = ? AND second_entire_author = ? AND third_entire_author = ?) OR
                               (first_entire_author = ? AND second_entire_author = ? AND third_entire_author = ?) OR
                               (first_entire_author = ? AND second_entire_author = ? AND third_entire_author = ?) OR
                               (first_entire_author = ? AND second_entire_author = ? AND third_entire_author = ?)                                 )
                                AND year = ?',
                                     first_entire_author_was, second_entire_author_was, third_entire_author_was,
                                     first_entire_author_was, third_entire_author_was, second_entire_author_was,
                                     second_entire_author_was, first_entire_author_was, third_entire_author_was,
                                     second_entire_author_was, third_entire_author_was, first_entire_author_was,
                                     third_entire_author_was, first_entire_author_was, second_entire_author_was,
                                     third_entire_author_was, second_entire_author_was, first_entire_author_was,
                                     year)
    update_refs(book_cap_refs)

  end

end
