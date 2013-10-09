class TccDefinition < ActiveRecord::Base
  has_many :hub_definitions, :inverse_of => :tcc_definition, :dependent => :destroy
  has_many :tccs, :inverse_of => :tcc_definition

  validates_presence_of :title

  attr_accessible :title, :activity_url
end