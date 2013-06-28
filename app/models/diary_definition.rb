class DiaryDefinition < ActiveRecord::Base
  belongs_to :hub_definition

  validates_presence_of :external_id, :hub_definition, :order, :title

  attr_accessible :external_id, :hub_definition_id, :order, :title
end
