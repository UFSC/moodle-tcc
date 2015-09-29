class InternalCourse < ActiveRecord::Base
  attr_accessible :internal_institution_id, :course_name, :department_name, :center_name, :coordinator_name,
                  :presentation_data, :approval_data, :internal_institution_attributes

  belongs_to :internal_institution, inverse_of: :internal_courses , touch: true

  normalize_attributes :course_name, :department_name, :center_name, :coordinator_name, :with => [:squish, :blank]

  validates_presence_of :internal_institution_id, :course_name, :department_name, :center_name, :coordinator_name,
                        :presentation_data, :approval_data

  validates :internal_institution_id, uniqueness: { scope: [:course_name, :department_name, :center_name],
                   message: 'O conjunto de dados para <b>Instituição/Curso/Departamento/Centro</b> já está cadastrado.'}

  accepts_nested_attributes_for :internal_institution
end
