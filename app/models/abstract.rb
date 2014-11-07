class Abstract < ActiveRecord::Base
  include Shared::DocumentState

  belongs_to :tcc
  has_one :chapter_comment, as: :chapter_commentable, :dependent => :destroy

  attr_accessible :content, :keywords, :chapter_comment

  def empty?
    self.content.blank? && self.keywords.blank?
  end
end