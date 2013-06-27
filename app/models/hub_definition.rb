class HubDefinition < ActiveRecord::Base
  belongs_to :tcc_definition
  has_many :diary_definitions

  validates_presence_of :external_id, :order, :tcc_definition, :title
  attr_accessible :external_id, :order, :title
end