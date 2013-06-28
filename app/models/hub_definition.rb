class HubDefinition < ActiveRecord::Base
  belongs_to :tcc_definition
  has_many :diary_definitions

  validates_presence_of :order, :tcc_definition, :title
  attr_accessible :order, :title, :tcc_definition
end