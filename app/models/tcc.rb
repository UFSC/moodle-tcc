class Tcc < ActiveRecord::Base
  attr_accessible :final_considerations, :leader, :moodle_user, :name, :presentation, :summary, :title

  validates_uniqueness_of :moodle_user
  validates_inclusion_of :grade, in: 0..1, allow_nil: true

  has_many :hubs
  has_one :bibliography
end
