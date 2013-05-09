require 'spec_helper'

describe Presentation do
  let!(:presentation) { Fabricate(:presentation) }

  it { respond_to :commentary, :content }

  it 'should versioning' do
    old_version = presentation.version
    presentation.update_attribute(:content, 'new content')
    presentation.version.should == ( old_version + 1 )
  end
end
