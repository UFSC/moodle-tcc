class TccDefinition < ActiveRecord::Base
  has_many :chapter_definitions, :inverse_of => :tcc_definition, :dependent => :destroy
  has_many :tccs, :inverse_of => :tcc_definition

  validates :internal_name, presence: true
  validates :moodle_instance_id, presence: true
  validates :activity_url, presence: true
  validates :course_id, uniqueness: true, presence: true

  attr_accessible :internal_name, :activity_url, :course_id, :defense_date, :moodle_instance_id, :minimum_references

  after_create :touch_tcc
  after_update :touch_tcc

  private

  def touch_tcc
    tccs.each  { |tcc |
      tcc.touch unless tcc.nil?
    }
  end
end