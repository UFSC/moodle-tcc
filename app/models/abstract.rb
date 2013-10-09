class Abstract < ActiveRecord::Base
  include TccStateMachine

  belongs_to :tcc

  attr_accessible :commentary, :content, :key_words

  validates :content, presence: true, unless: Proc.new { |abstract| abstract.new? }

  has_paper_trail meta: {state: :state}

  def empty?
    self.content.blank? && self.key_words.blank?
  end
end
