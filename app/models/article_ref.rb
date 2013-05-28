class ArticleRef < ActiveRecord::Base
  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :references

  attr_accessible :article_subtitle, :article_title, :end_page, :et_all, :first_author, :initial_page, :journal_name,
                  :local, :number_or_fascicle, :publication_date, :second_author, :third_author, :volume_number

  validates_presence_of :first_author, :article_title, :journal_name, :local, :publication_date, :initial_page, :end_page

  validates :volume_number, :numericality => { :only_integer => true, :greater_than => 0 }, :allow_blank => true
  validates :number_or_fascicle, :numericality => { :only_integer => true, :greater_than => 0 }, :allow_blank => true
end
