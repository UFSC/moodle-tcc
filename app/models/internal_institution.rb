class InternalInstitution < ActiveRecord::Base
  include Shared::Search

  attr_accessible :institution_name, :city, :data_file_name, :image, :image_cache

  has_many :internal_courses, inverse_of: :internal_institution,
           dependent: :restrict_with_error

  mount_uploader :image, InternalInstitutionPictureUploader, :mount_on => :data_file_name

  normalize_attributes :institution_name, :with => [:squish, :blank]

  validates_presence_of :institution_name, :city, :image

  validates :institution_name, uniqueness: true
  validate :image

  default_scope -> { order(:institution_name) }
  scoped_search :on => [:institution_name]

  def data_file_size
    if (!image.nil?) && (!image.file.nil?) && (image.file.size.to_f > 1.megabytes.to_f)
      errors.add(:image, " com mais de #{1.megabytes.to_i}MB não pode ser enviado.")
    end
  end

  after_create :touch_tcc
  after_update :touch_tcc

  private

  def touch_tcc
    if self.updated_at != self.updated_at_was
      internal_courses.each  { | ic |
        unless ic.nil?
          ic.updated_at = self.updated_at
          ic.save!
        end
      }
    end
  end
end
