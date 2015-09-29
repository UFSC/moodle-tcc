class InternalInstitution < ActiveRecord::Base
  attr_accessible :institution_name, :data_file_name, :image, :image_cache

  has_many :internal_courses, inverse_of: :internal_institution#, dependent: :restrict_with_error

  mount_uploader :image, InternalInstitutionPictureUploader, :mount_on => :data_file_name

  normalize_attributes :institution_name, :with => [:squish, :blank]

  validates_presence_of :institution_name, :image

  validates :institution_name, uniqueness: true
  validate :image

  before_destroy :check_for_courses

  def data_file_size
    if (!image.nil?) && (!image.file.nil?) && (image.file.size.to_f > 1.megabytes.to_f)
      errors.add(:image, " com mais de #{1.megabytes.to_i}MB não pode ser enviado.")
    end
  end

  private

  def check_for_courses
    if internal_courses.count > 0
      errors.add(:base, "Instituição com um ou mais cursos cadastrados.")
      return false
    end
  end
end
