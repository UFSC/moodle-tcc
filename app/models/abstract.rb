class Abstract < ActiveRecord::Base
  belongs_to :tcc

  attr_accessible :content, :keywords

  def empty?
    self.content.blank? && self.keywords.blank?
  end
end