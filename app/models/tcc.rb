class Tcc < ActiveRecord::Base
  attr_accessible :leader, :moodle_user, :name, :title, :defense_date


  validates_uniqueness_of :moodle_user
  validates_inclusion_of :grade, in: 0..1, allow_nil: true

  has_many :hubs
  has_one :bibliography
  has_one :presentation
  has_one :abstract
  has_one :final_considerations
end
