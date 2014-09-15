class ChapterDefinition < ActiveRecord::Base
  belongs_to :tcc_definition, :inverse_of => :chapter_definitions
  has_many :chapters, :inverse_of => :chapter_definitions

  validates_presence_of :order, :tcc_definition, :title
  attr_accessible :order, :position, :title, :subtitle, :tcc_definition, :tcc_definition_id, :moodle_shortname # shortname relacionado ao curso ao qual o usuário deve ser membro para ter o HubDefinition associado

  # TODO: renomear campo order no banco e remover esse workaround
  alias_attribute :order, :position

  default_scope -> { order(:position) }
end