require 'spec_helper'

describe Abstract do
  let!(:abstract) { Fabricate(:abstract) }

  it { respond_to :commentary, :content_pt, :key_words_pt }

  it 'should versioning' do
    old_version = abstract.version
    abstract.update_attribute(:content_pt, 'new content')
    abstract.version.should == ( old_version + 1 )
  end
end
