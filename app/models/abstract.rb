class Abstract < ActiveRecord::Base
  belongs_to :tcc
  attr_accessible :commentary, :content, :key_words

  has_paper_trail meta: {state: :state}

  include TccStateMachine

  def empty?
    self.content.blank? && self.key_words.blank?
  end
end
