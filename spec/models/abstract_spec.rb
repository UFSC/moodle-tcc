require 'spec_helper'

describe Abstract do
  let!(:abstract) { Fabricate(:abstract) }

  it { respond_to :commentary, :content, :key_words, :state }

  it 'should versioning' do
    old_version = abstract.versions.size
    abstract.update_attribute(:content, 'new content')
    abstract.versions.size.should == ( old_version + 1 )
  end
end
