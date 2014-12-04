class Abstract < ActiveRecord::Base
  include Shared::DocumentState

  belongs_to :tcc
  has_one :comment, :as => :chapter_commentable, class_name: 'ChapterComment', :dependent => :destroy

  attr_accessible :content, :keywords, :chapter_comment

  def empty?
    self.content.blank? && self.keywords.blank?
  end
end