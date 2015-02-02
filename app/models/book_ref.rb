class BookRef < ActiveRecord::Base

  include ModelsUtils
  include Shared::Citacao

  before_save :check_equality
  before_update :check_equality
  after_update :check_difference, if: Proc.new { (self.first_author_changed? || self.second_author_changed? || self.third_author_changed?) }
  before_destroy :check_for_usage

  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :reference

  QUANTITY_TYPES = %w(p ed)

  attr_accessible :first_author, :edition_number, :et_all, :local, :num_quantity, :publisher, :second_author, :subtitle,
                  :third_author, :title, :type_quantity, :year

  validates_presence_of :first_author, :local, :year, :title, :publisher
  validates_presence_of :num_quantity, :if => :type_quantity_defined?

  validates :type_quantity, :inclusion => {:in => QUANTITY_TYPES}, :allow_blank => true
  validates :year, :numericality => {:only_integer => true}
  validates :year, :inclusion => {:in => lambda { |book| 0..Date.today.year }}
  validates :edition_number, :numericality => {:only_integer => true, :greater_than => 0}, :allow_blank => true

  validates :first_author, :second_author, :third_author, complete_name: true

  after_commit :touch_tcc, on: [:create, :update]
  before_destroy :touch_tcc

  # Garante que os atributos principais estarão dentro de um padrão mínimo:
  # sem espaços no inicio e final e espaços duplos
  normalize_attributes :first_author, :second_author, :third_author, :title, :local, :with => [:squish, :blank]

  def type_quantity_defined?
    !type_quantity.blank?
  end

  private

  def touch_tcc
    reference.tcc.touch unless (reference.nil? || reference.tcc.nil? || reference.tcc.new_record?)
  end

  def get_all_authors
    [first_author, second_author, third_author]
  end

  def check_equality
    columns =[:first_author, :second_author, :third_author]
    book_refs = get_records(BookRef, columns, first_author, second_author, third_author, year)
    update_subtype_field(self, book_refs)
  end

  def check_difference
    columns =[:first_author, :second_author, :third_author]
    book_refs = get_records(BookRef, columns, first_author, second_author, third_author, year)
    update_refs(book_refs)

    book_refs = get_records(BookRef, columns, first_author_was, second_author_was, third_author_was, year)
    update_refs(book_refs)
  end
end
