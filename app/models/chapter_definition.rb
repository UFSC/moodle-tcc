class ChapterDefinition < ActiveRecord::Base
  belongs_to :tcc_definition, :inverse_of => :chapter_definitions
  has_many :chapters, :inverse_of => :chapter_definitions

  validates :position, presence: true
  validates :tcc_definition, presence: true
  validates :title, presence: true

  attr_accessible :position, :title, :subtitle, :tcc_definition, :tcc_definition_id

  default_scope -> { order(:position) }
end