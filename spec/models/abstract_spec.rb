require 'spec_helper'

describe Abstract do
  let!(:abstract) { Fabricate(:abstract) }

  it { respond_to :commentary, :content_pt, :key_words_pt, :state }

  it 'should versioning' do
    old_version = abstract.versions.size
    abstract.update_attribute(:content_pt, 'new content')
    abstract.versions.size.should == ( old_version + 1 )
  end
end
