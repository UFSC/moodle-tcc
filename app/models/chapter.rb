class Chapter < ActiveRecord::Base

  belongs_to :tcc, :inverse_of => :chapters
  belongs_to :chapter_definition, :inverse_of => :chapters
  has_one :chapter_comment, as: :chapter_commentable, :dependent => :destroy

  # Mass-Assignment
  attr_accessible :position, :content, :chapter_definition, :tcc, :chapter_comment

  # Hubs por tipo (polimórfico)
  scope :reflection_empty, -> { where(content: '') }

  def empty?
    (self.content.nil? || self.content.empty?)
  end

end