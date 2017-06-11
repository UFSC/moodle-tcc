class TccDefinition < ActiveRecord::Base
  attr_accessible :internal_name, :activity_url, :course_id, :internal_course_id, :defense_date,
                  :moodle_instance_id, :minimum_references, :auto_save_minutes, :pdf_link_hours,
                  :enabled_sync, :advisor_nomenclature

  has_many :chapter_definitions, :inverse_of => :tcc_definition, :dependent => :destroy
  has_many :tccs, :inverse_of => :tcc_definition

  belongs_to :internal_course, -> { includes :internal_institution }, inverse_of: :tcc_definitions

  validates :internal_name, presence: true
  validates :activity_url, presence: true
  validates :advisor_nomenclature, presence: true

  validates :moodle_instance_id, numericality: { only_integer: true, greater_than_or_equal_to: 1}#, presence: true
  validates :course_id, numericality: { only_integer: true, greater_than_or_equal_to: 1}, uniqueness: true#, presence: true
  validates :minimum_references, numericality: { only_integer: true, greater_than_or_equal_to: 0}
  validates :auto_save_minutes, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  validates :pdf_link_hours, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 72 }

  validates :enabled_sync, :inclusion => {:in => [true, false]}

  after_create :touch_tcc
  after_update :touch_tcc

  private

  def touch_tcc
    if !( (self.changed_attributes.size == 2) &&
        (self.changed_attributes.include?(:enabled_sync)) )
      if (self.updated_at != self.updated_at_was)
        tccs.each  { |tcc |
          tcc.touch unless tcc.nil?
        }
      end
    end
  end
end