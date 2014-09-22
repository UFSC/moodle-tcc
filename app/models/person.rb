class Person < ActiveRecord::Base

  validates :name, presence: true
  validates :email, presence: true
  validates :moodle_username, presence: true
  validates :moodle_id, presence: true, numericality: true, uniqueness: true

  attr_accessible :name, :email, :moodle_username, :moodle_id

  has_one :student_tcc, :class_name => 'Tcc', :inverse_of => :student
end