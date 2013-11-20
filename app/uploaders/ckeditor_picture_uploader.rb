# encoding: utf-8
class CkeditorPictureUploader < CarrierWave::Uploader::Base
  include Ckeditor::Backend::CarrierWave
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/ckeditor/pictures/#{model.id}"
  end

  version :a4 do
    # Formato a4 com largura definida por width
    width = 500
    process :resize_to_fit => [width, (Math.sqrt(2)*width).to_i]
  end

  version :thumb, :from_version => :a4 do
    process :resize_to_fill => [118, 100]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    Ckeditor.image_file_types
  end
end
