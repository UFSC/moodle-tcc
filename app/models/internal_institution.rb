require 'file_size_validator'
class InternalInstitution < ActiveRecord::Base
  attr_accessible :institution_name, :image
  mount_uploader :image, InternalInstitutionPictureUploader, :mount_on => :data_file_name

  validates_presence_of :institution_name

  # validates :image,
  #     :presence => true,
  #     :file_size => {
  #         :maximum => 1.megabytes.to_i
  #     }

  validate :file_size

  def file_size
    if (image.nil?) || (image.file.nil?) || (image.file.size.to_f > 1.megabytes.to_f)
      errors.add(:file, "O arquivo com mais de #{1.megabytes.to_i}MB não pode ser enviado.")
    end
  end
end
