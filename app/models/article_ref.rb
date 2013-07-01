class ArticleRef < ActiveRecord::Base
  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :reference

  attr_accessible :article_subtitle, :article_title, :end_page, :et_all, :first_author, :initial_page, :journal_name,
                  :local, :number_or_fascicle, :publication_date, :second_author, :third_author, :volume_number

  validates_presence_of :first_author, :article_title, :journal_name, :local, :publication_date, :initial_page, :end_page

  validates :volume_number, :numericality => {:only_integer => true, :greater_than => 0}, :allow_blank => true
  validates :number_or_fascicle, :numericality => {:only_integer => true, :greater_than => 0}, :allow_blank => true
  validates :initial_page, :numericality => {:only_integer => true, :greater_than => 0}
  validates :end_page, :numericality => {:only_integer => true, :greater_than => 0}
  validate :initial_page_less_than_end_page

  private

  def initial_page_less_than_end_page
    if (!initial_page.nil? && !end_page.nil?) && (initial_page > end_page)
      errors.add(:initial_page, "Can't be less than end page")
    end
  end
end
