# encoding: utf-8

class MoodlePictureUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/moodle/pictures/#{model.tcc_id}/#{model.id}"
  end

  # Tamanho original da figura é o equivalente a uma folha A4
  process :resize_to_fit => [500, 707]

  version :content do
    width = 452
    process :resize_to_fit => [width, (Math.sqrt(2)*width).to_i]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png gif)
  end

end
