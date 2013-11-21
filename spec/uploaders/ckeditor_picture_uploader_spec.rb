require 'spec_helper'
require 'carrierwave/test/matchers'

describe CkeditorPictureUploader do
  include CarrierWave::Test::Matchers

  before do
    CkeditorPictureUploader.enable_processing = true
    @uploader = CkeditorPictureUploader.new(Ckeditor::Picture.new, :data)
    @uploader.store!(File.open("#{Rails.root}/spec/support/image_test.jpg"))
  end

  after do
    CkeditorPictureUploader.enable_processing = false
    @uploader.remove!
  end

  context 'the a4 version' do
    it "should scale down a landscape image to fit within a4 pattern" do
      width = 500
      @uploader.should be_no_larger_than(width, (Math.sqrt(2)*width).to_i)
    end
  end

  it "should make the file.." do
    @uploader.should have_permissions(0644)
  end
end
