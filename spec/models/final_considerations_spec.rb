require 'spec_helper'

describe FinalConsiderations do
  before(:each) do
    TccStateMachine.state_name = :state
  end
  let!(:final_considerations) { Fabricate(:final_considerations) }

  it { respond_to :commentary, :content, :state }

  it 'should versioning' do
    old_version = final_considerations.versions.size
    final_considerations.update_attribute(:content, 'new content')
    final_considerations.versions.size.should == ( old_version + 1 )
  end
end
