class TccDefinition < ActiveRecord::Base
  has_many :chapter_definitions, :inverse_of => :tcc_definition, :dependent => :destroy
  has_many :tccs, :inverse_of => :tcc_definition

  validates :internal_name, presence: true
  validates :activity_url, presence: true
  validates :course_id, uniqueness: true, presence: true

  attr_accessible :internal_name, :activity_url, :course_id, :defense_date
end