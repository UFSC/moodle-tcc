class BookRef < ActiveRecord::Base
  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :references

  QUANTITY_TYPES = %w(p ed)

  attr_accessible :first_author, :edition_number, :et_all, :local, :num_quantity, :publisher, :second_author, :subtitle,
                  :third_author, :title, :type_quantity, :year

  validates_presence_of :first_author, :local, :year, :title, :publisher
  validates :type_quantity, :inclusion => {:in => QUANTITY_TYPES}, :allow_blank => true
  validates :year, :numericality => {:only_integer => true}
  validates :year, :inclusion => {:in => lambda { |book| 0..Date.today.year }}
  validates :edition_number, :numericality => {:only_integer => true, :greater_than => 0}

  def direct_citation
    authors = first_author.split(' ').last.upcase
    authors = authors + ';' + ' '+second_author.split(' ').last.upcase if second_author
    authors = authors + ';' + ' '+third_author.split(' ').last.upcase if third_author
    "(#{authors}, #{year})"
  end

  def indirect_citation
    "#{first_author} (#{year})"
  end
end
