class Abstract < ActiveRecord::Base
  include Shared::DocumentState

  belongs_to :tcc, touch: true
  has_one :comment, :as => :chapter_commentable, :dependent => :destroy

  attr_accessible :content, :keywords, :comment

  def empty?
    self.content.blank? && self.keywords.blank?
  end
end