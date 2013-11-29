class MoodleAsset < ActiveRecord::Base
  # attr_accessible :title, :body
  mount_uploader :data, MoodlePictureUploader, :mount_on => :data_file_name

  validates_presence_of :data
end
