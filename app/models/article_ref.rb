class ArticleRef < ActiveRecord::Base

  validates_presence_of :first_author, :article_title, :journal_name, :local, :publication_date, :initial_page, :end_page

  attr_accessible :article_subtitle, :article_title, :end_page, :et_all, :first_author, :initial_page, :journal_name, :local, :number_or_fascicle, :publication_date, :second_author, :third_author, :volume_number

  has_one :reference, :as => :element, :dependent => :destroy
  has_one :tcc, :through => :references
end
