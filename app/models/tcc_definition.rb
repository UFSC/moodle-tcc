class TccDefinition < ActiveRecord::Base
  has_many :hub_definitions
  has_many :tccs

  validates_presence_of :title

  attr_accessible :title
end