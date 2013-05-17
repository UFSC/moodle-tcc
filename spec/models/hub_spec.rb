require 'spec_helper'

describe Hub do
  let!(:hub) { Fabricate(:hub) }

  it { should respond_to(:category, :reflection, :commentary) }

  it 'should versioning' do
    old_version = hub.versions.size
    hub.update_attribute(:reflection, 'new content')
    hub.versions.size.should == ( old_version + 1 )
  end
end
