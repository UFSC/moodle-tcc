class Person < ActiveRecord::Base

  validates :name, presence: true
  validates :email, presence: true
  validates :moodle_username, presence: true, uniqueness: true
  validates :moodle_id, presence: true, numericality: true

  attr_accessible :name, :email, :moodle_username, :moodle_id
end