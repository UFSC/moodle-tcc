class InternalCourse < ActiveRecord::Base
  include Shared::Search

  attr_accessible :internal_institution_id, :course_name, :department_name, :center_name, :coordinator_name,
                  :presentation_data, :approval_data, :internal_institution_attributes, :coordinator_gender

  belongs_to :internal_institution, inverse_of: :internal_courses #, touch: true

  has_many :tcc_definitions, inverse_of: :internal_course# , dependent: :restrict_with_error

  normalize_attributes :course_name, :department_name, :center_name, :coordinator_name, :with => [:squish, :blank]

  validates_presence_of :internal_institution_id, :course_name, :department_name, :center_name, :coordinator_name,
                        :presentation_data, :approval_data, :coordinator_gender

  validates :internal_institution_id, uniqueness: { scope: [:course_name, :department_name, :center_name],
                   message: 'O conjunto de dados para <b>Instituição/Curso/Departamento/Centro</b> já está cadastrado.'}

  validates_inclusion_of :coordinator_gender, in: %w( m f )

  accepts_nested_attributes_for :internal_institution

  default_scope -> { order(:course_name) }
  scoped_search :on => [:course_name]

  after_create :touch_tcc
  after_update :touch_tcc

  private

  def touch_tcc
    if self.updated_at != self.updated_at_was
      tcc_definitions.each { | td |
        unless td.nil?
          td.updated_at = self.updated_at
          td.save!
        end
      }
    end
  end
end
