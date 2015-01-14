class Chapter < ActiveRecord::Base
  include Shared::DocumentState

  belongs_to :tcc, :inverse_of => :chapters, touch: true
  belongs_to :chapter_definition, :inverse_of => :chapters
  has_one :comment, :as => :chapter_commentable, class_name: 'Comment', :dependent => :destroy

  # Mass-Assignment
  attr_accessible :position, :content, :chapter_definition, :tcc, :comment

  # Hubs por tipo (polimórfico)
  scope :reflection_empty, -> { where(content: '') }

  def empty?
    (self.content.nil? || self.content.empty?)
  end

end