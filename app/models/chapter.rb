class Chapter < ActiveRecord::Base

  belongs_to :tcc, :inverse_of => :chapters
  belongs_to :chapter_definition, :inverse_of => :chapters

  # Mass-Assignment
  attr_accessible :position, :content, :chapter_definition, :tcc

  # Hubs por tipo (polimórfico)
  scope :reflection_empty, -> { where(content: '') }

  def empty?
    self.content.blank?
  end

end