class Tcc < ActiveRecord::Base
  attr_accessible :final_considerations, :leader, :moodle_user, :name, :presentation, :summary, :title

  validates_uniqueness_of :moodle_user

  has_many :hubs
  has_one :bibliography
end
