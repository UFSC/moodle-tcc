require 'spec_helper'

describe Presentation do
  before(:each) do
    TccStateMachine.state_name = :state
  end
  let!(:presentation) { Fabricate(:presentation) }

  it { respond_to :commentary, :content, :state }

  it 'should versioning' do
    old_version = presentation.versions.size
    presentation.update_attribute(:content, 'new content')
    presentation.versions.size.should == ( old_version + 1 )
  end
end
